import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/enums.dart';
import '../../data/providers.dart';
import '../../domain/day.dart';
import '../../domain/grid.dart';
import '../../domain/lapse.dart';
import 'today_data.dart';
import 'today_logic.dart';
import 'today_repository.dart';

final todayRepositoryProvider = Provider<TodayRepository>((ref) => TodayRepository(ref.watch(databaseProvider)));

/// The clock. Tests replace it so "today" is a fixed day.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Weeks the Rhythm grid card shows (frame 2.3: "Your rhythm · last 12 weeks").
const rhythmWeeks = 12;

/// The state Today is in, decided from what is stored (docs/sitemap.md S-004 states).
enum TodayMode { options, nothingFitsChips, nothingFitsChoices, paused, allDone }

/// One day on the grid card: its level, whether it is today, and the date for screen readers.
class GridDay {
  const GridDay({required this.day, required this.cell, required this.isToday});

  final String day;
  final GridCell cell;
  final bool isToday;
}

/// Everything the Today screen draws.
class TodayView {
  const TodayView({
    required this.today,
    required this.mode,
    required this.chips,
    required this.plan,
    required this.offers,
    required this.pause,
    required this.hasHistory,
    required this.grid,
    required this.weekStrip,
    required this.lighterAvailable,
    required this.followedPaths,
  });

  final String today;
  final TodayMode mode;
  final TodayChips chips;
  final TodayPlan plan;
  final List<StoredOffer> offers;
  final ActivePause? pause;

  /// At least one reflected day exists, so the 12-week grid is shown rather than the day-one week strip.
  final bool hasHistory;

  /// The last [rhythmWeeks] weeks up to today, oldest first (future days are not drawn).
  final List<GridDay> grid;

  /// This week, Monday to Sunday (frame 1.16, day one).
  final List<GridDay> weekStrip;

  /// "Something lighter" is offered only when a lighter option exists (spec: never a dead row).
  final bool lighterAvailable;
  final Map<ActivityKind, SetupPath> followedPaths;

  StoredOffer? get shown => shownOffer(offers);

  /// Offers the person accepted today: the plan.
  List<StoredOffer> get accepted => [for (final o in offers) if (o.status == OfferStatus.accepted) o];

  /// "N of M" on the hero card: the options stepped past plus the one shown, out of those plus what is left.
  int get heroPosition => offers.where((o) => o.status == OfferStatus.replaced).length + 1;
  int get heroTotal => offers.where((o) => o.status == OfferStatus.replaced || o.status == OfferStatus.offered).length;

  /// "Something else" is hidden on the last option rather than cycling back: each swap counts against the
  /// acceptance metric (docs/methods.md EQ-010).
  bool get canSwap => heroPosition < heroTotal;

  List<TodayOption> get compact {
    // Once something is accepted there is no hero card, so every other followed activity can show.
    final heroActivity = accepted.isNotEmpty ? null : shown?.action.activity;
    final acceptedActivities = {for (final a in accepted) a.action.activity};
    final declinedIds = {for (final o in offers) if (o.status == OfferStatus.declined) o.action.id};
    return [
      for (final c in plan.others)
        if (c.ranked.action.activity != heroActivity &&
            !acceptedActivities.contains(c.ranked.action.activity) &&
            !declinedIds.contains(c.ranked.action.id))
          c,
    ].take(maxCompactCards).toList();
  }
}

/// Today's state and what the person can do on it. Every change is written to the database first and the view is
/// then read back, so what is on screen is always what is stored.
class TodayController extends AsyncNotifier<TodayView> {
  TodayChips _chips = const TodayChips();
  String? _chipsDay;

  TodayRepository get _repo => ref.read(todayRepositoryProvider);

  @override
  Future<TodayView> build() async {
    // Without consent Today does nothing: after delete-all it must not write a row back (BR-014).
    // A consent that is being re-read (after delete-all it is invalidated) counts as no consent: its old value
    // must not let Today write a row back.
    final consent = ref.watch(consentProvider);
    if (consent.isLoading || !(consent.value ?? false)) throw StateError('Today needs consent');
    // The library loads after consent; Today waits for it, so it never ranks an empty one.
    await ref.watch(libraryReadyProvider.future);
    return _read();
  }

  DateTime get _now => ref.read(clockProvider)();

  Future<TodayView> _read() async {
    final now = _now;
    final today = formatDay(DateTime.utc(now.year, now.month, now.day));
    if (_chipsDay != today) {
      // The chips reset each day (UF-002).
      _chips = const TodayChips();
      _chipsDay = today;
    }

    final inputs = await _repo.inputs();
    final actionsById = {for (final a in inputs.actions) a.id: a};
    final pause = await _repo.activePause(today);

    TodayPlan plan(TodayChips chips, {bool lighter = false}) => buildTodayPlan(
          actions: inputs.actions,
          person: inputs.person,
          libraryVersion: inputs.libraryVersion,
          followedOrder: inputs.followedOrder,
          freeTimes: inputs.freeTimes,
          chips: chips,
          now: now,
          lighter: lighter,
        );

    final current = plan(_chips);
    var offers = await _repo.offersFor(today, actionsById);
    if (pause == null && offers.isEmpty && current.kind == TodayKind.options) {
      await _repo.createHeroChain(today, current, _chips);
      offers = await _repo.offersFor(today, actionsById);
    }

    final lighterAvailable = pause == null && plan(_chips, lighter: true).kind == TodayKind.options;
    final accepted = offers.any((o) => o.status == OfferStatus.accepted);
    final waiting = offers.any((o) => o.status == OfferStatus.offered);

    final mode = pause != null
        ? TodayMode.paused
        : switch (current.kind) {
            _ when waiting || accepted => TodayMode.options,
            TodayKind.nothingFitsChips => TodayMode.nothingFitsChips,
            TodayKind.nothingFitsChoices => TodayMode.nothingFitsChoices,
            TodayKind.options => TodayMode.allDone,
          };

    return TodayView(
      today: today,
      mode: mode,
      chips: _chips,
      plan: current,
      offers: offers,
      pause: pause,
      hasHistory: inputs.reflectedDays.isNotEmpty,
      grid: _grid(today, inputs),
      weekStrip: _weekStrip(today, inputs),
      lighterAvailable: lighterAvailable,
      followedPaths: inputs.followedPaths,
    );
  }

  Future<void> _reload() async => state = AsyncData(await _read());

  /// The 12-week grid: each day's level from that day's reflections (EQ-002), a paused day drawn as level 0
  /// (ADR-012). Days after today are not drawn.
  List<GridDay> _grid(String today, TodayInputs inputs) {
    final start = addDays(weekStart(today), -7 * (rhythmWeeks - 1));
    return _days(start, today, today, inputs);
  }

  List<GridDay> _weekStrip(String today, TodayInputs inputs) {
    final start = weekStart(today);
    return _days(start, addDays(start, 6), today, inputs, includeFuture: true);
  }

  List<GridDay> _days(String from, String to, String today, TodayInputs inputs, {bool includeFuture = false}) {
    final paused = pausedDays(inputs.pauses, today);
    final byDay = <String, List<ReflectionStatus>>{};
    for (final r in inputs.reflections) {
      (byDay[r.day] ??= []).add(r.status);
    }
    final days = <GridDay>[];
    for (var d = from; d.compareTo(to) <= 0; d = addDays(d, 1)) {
      if (!includeFuture && d.compareTo(today) > 0) break;
      days.add(GridDay(
        day: d,
        isToday: d == today,
        cell: gridCell(statuses: byDay[d] ?? const [], dailyGoal: 1, paused: paused.contains(d)),
      ));
    }
    return days;
  }

  // ---- chips

  /// A new time or energy: re-rank what has not been acted on, for today only.
  Future<void> setChips(TodayChips chips) async {
    _chips = chips;
    final view = state.valueOrNull;
    if (view == null) return;
    final inputs = await _repo.inputs();
    final now = _now;
    final plan = buildTodayPlan(
      actions: inputs.actions,
      person: inputs.person,
      libraryVersion: inputs.libraryVersion,
      followedOrder: inputs.followedOrder,
      freeTimes: inputs.freeTimes,
      chips: chips,
      now: now,
    );
    // Re-ranks what has not been acted on. When nothing fits the new chips the waiting offers are dropped, so
    // the screen shows the empty state and not a stale card.
    await _repo.createHeroChain(view.today, plan, chips);
    await _reload();
  }

  // ---- options

  Future<void> acceptShown() async {
    final shown = state.valueOrNull?.shown;
    if (shown == null) return;
    await _repo.accept(shown);
    await _reload();
  }

  Future<void> acceptCompact(TodayOption option) async {
    final view = state.valueOrNull;
    if (view == null) return;
    await _repo.acceptNew(view.today, option, _chips);
    await _reload();
  }

  Future<void> swapShown() async {
    final view = state.valueOrNull;
    if (view == null || view.shown == null || !view.canSwap) return;
    await _repo.replace(view.shown!);
    await _reload();
  }

  /// "Something lighter" from the Not today sheet.
  Future<void> lighter() async {
    final view = state.valueOrNull;
    final shown = view?.shown;
    if (view == null || shown == null || !view.lighterAvailable) return;
    final inputs = await _repo.inputs();
    final plan = buildTodayPlan(
      actions: inputs.actions,
      person: inputs.person,
      libraryVersion: inputs.libraryVersion,
      followedOrder: inputs.followedOrder,
      freeTimes: inputs.freeTimes,
      chips: _chips,
      now: _now,
      lighter: true,
    );
    if (plan.kind != TodayKind.options) return;
    await _repo.swapToLighter(view.today, shown, plan, _chips);
    await _reload();
  }

  // ---- pause

  /// "Pause for a while" (3, 7 or 14 days). [option] is the compact card the sheet was opened from, if any.
  Future<void> pause(int days, {TodayOption? option}) async {
    final view = state.valueOrNull;
    if (view == null) return;
    await _repo.pause(view.today, days, shown: option == null ? view.shown : null, declinedNew: option, chips: _chips);
    await _reload();
  }

  Future<void> resume() async {
    final view = state.valueOrNull;
    if (view == null) return;
    await _repo.resume(view.today);
    await _reload();
  }
}

final todayControllerProvider = AsyncNotifierProvider<TodayController, TodayView>(TodayController.new);
