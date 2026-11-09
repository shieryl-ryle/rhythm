import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/enums.dart';
import '../../data/providers.dart';
import '../../domain/day.dart';
import '../../domain/grid.dart';
import '../../domain/lapse.dart';
import '../../domain/models.dart';
import '../way_back/way_back_logic.dart';
import 'reflection_copy.dart';
import 'reflection_sheet.dart';
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

/// The days from [from] to [to], each with its level from that day's reflections (EQ-002) and a paused day drawn
/// as level 0 (ADR-012). Days after [today] are left out unless [includeFuture]. Today and My rhythm share it, so
/// the two grids can never disagree.
List<GridDay> gridDays({
  required String from,
  required String to,
  required String today,
  required List<ReflectionRecord> reflections,
  required List<PauseSpan> pauses,
  bool includeFuture = false,
}) {
  final paused = pausedDays(pauses, today);
  final byDay = <String, List<ReflectionStatus>>{};
  for (final r in reflections) {
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
    required this.planned,
    this.wayBackOffered = false,
  });

  /// The welcome-back banner is shown (S-005): the person is in a lapse (EQ-001), nothing is planned or paused,
  /// they have not said "Not now" today, and have not already been through My Way Back for this lapse.
  final bool wayBackOffered;

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

  /// The plan: today and later, and anything earlier that is still unanswered (read by the planned day).
  final List<PlannedItem> planned;

  List<PlannedItem> get todayItems => [for (final p in planned) if (p.item.plannedDay == today) p];
  List<PlannedItem> get upcomingItems => [for (final p in planned) if (p.item.plannedDay.compareTo(today) > 0) p];
  List<PlannedItem> get earlierOpen =>
      [for (final p in planned) if (p.item.plannedDay.compareTo(today) < 0 && p.isOpen) p];

  /// Something is planned for today, so the hero card steps aside and the screen is "Today's plan".
  bool get hasPlan => accepted.isNotEmpty || todayItems.isNotEmpty;

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
    final heroActivity = hasPlan ? null : shown?.action.activity;
    final acceptedActivities = {
      for (final a in accepted) a.action.activity,
      for (final p in todayItems) p.item.activity,
    };
    final declinedIds = {for (final o in offers) if (o.status == OfferStatus.declined) o.action.id};
    // An activity the hero stepped past with "Something else" does not come back as a compact card.
    final steppedPast = {for (final o in offers) if (o.status == OfferStatus.replaced) o.action.activity};
    return [
      for (final c in plan.others)
        if (c.ranked.action.activity != heroActivity &&
            !acceptedActivities.contains(c.ranked.action.activity) &&
            !steppedPast.contains(c.ranked.action.activity) &&
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
  bool _busy = false;

  /// The day "Not now" was tapped on the welcome-back banner. It comes back tomorrow if the lapse goes on.
  String? _wayBackDismissedDay;

  /// What "I'll try this" just did, so Undo can take it back: the offer, and whether accepting created it.
  ({String offerId, bool wasNew})? _lastAccept;

  TodayRepository get _repo => ref.read(todayRepositoryProvider);

  @override
  Future<TodayView> build() async {
    // A new person (or the same one after delete-all) starts from the default chips.
    _chips = const TodayChips();
    _chipsDay = null;
    _lastAccept = null;
    _wayBackDismissedDay = null;
    _assertConsent();
    // The library loads after consent; Today waits for it, so it never ranks an empty one.
    await ref.watch(libraryReadyProvider.future);
    return _read();
  }

  /// Without consent Today does nothing: after delete-all it must not write a row back (BR-014). A consent that is
  /// being re-read (delete-all invalidates it) counts as no consent: its old value must not allow a write.
  void _assertConsent() {
    final consent = ref.watch(consentProvider);
    if (consent.isLoading || !(consent.value ?? false)) throw StateError('Today needs consent');
  }

  void _assertConsentNow() {
    final consent = ref.read(consentProvider);
    if (consent.isLoading || !(consent.value ?? false)) throw StateError('Today needs consent');
  }

  DateTime get _now => ref.read(clockProvider)();

  String get _clockDay {
    final now = _now;
    return formatDay(DateTime.utc(now.year, now.month, now.day));
  }

  /// Runs one action. A second tap while one is running is ignored (a double tap must not plan twice), and an
  /// action started on a screen left over from yesterday refreshes the screen instead of writing under the old day.
  Future<void> _act(Future<void> Function(TodayView view) body, {bool requireSameDay = true}) async {
    final view = state.valueOrNull;
    if (view == null || _busy) return;
    _busy = true;
    try {
      _assertConsentNow();
      if (requireSameDay && view.today != _clockDay) {
        await _reload();
        return;
      }
      await body(view);
    } finally {
      _busy = false;
    }
  }

  /// Called when the app comes back to the front: if the day changed meanwhile, show the new day (the chips
  /// reset, a pause that ended is over, the options are new).
  Future<void> refreshIfNewDay() async {
    final view = state.valueOrNull;
    if (view != null && view.today != _clockDay && !_busy) await _reload();
  }

  Future<TodayView> _read() async {
    final now = _now;
    final today = _clockDay;
    if (_chipsDay != today) {
      // The chips reset each day (UF-002).
      _chips = const TodayChips();
      _chipsDay = today;
    }

    final inputs = await _repo.inputs();
    final actionsById = {for (final a in inputs.actions) a.id: a};
    final pause = await _repo.activePause(today);

    // A reflected day that ends a lapse is a return, recorded once (EQ-011). Doing it here covers every way a day
    // can become reflected (Today, or a changed answer from the day detail).
    final paused = pausedDays(inputs.pauses, today);
    final lapses = findLapses(reflectedDays: inputs.reflectedDays, pausedDays: paused, today: today);
    final due = returnsToRecord(lapses, await _repo.recordedReturnDays());
    if (due.isNotEmpty) {
      _assertConsentNow();
      final answers = ref.read(wayBackAnswersProvider);
      await _repo.recordReturns(
        due,
        answersLapseStart: answers?.lapseStartDay,
        whatChanged: answers?.whatChangedCsv,
        approach: answers?.approach,
      );
      if (answers != null && due.any((s) => s.startDay == answers.lapseStartDay)) {
        ref.read(wayBackAnswersProvider.notifier).state = null;
      }
    }
    final lapse = lapses.isNotEmpty && lapses.last.isOpen ? lapses.last : null;
    // Answers that belong to a lapse that is no longer the open one match nothing, so they are dropped.
    final stored = ref.read(wayBackAnswersProvider);
    if (stored != null && stored.lapseStartDay != lapse?.startDay) {
      ref.read(wayBackAnswersProvider.notifier).state = null;
    }

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
      _assertConsentNow(); // a delete-all during the load above must not let the chain be written back
      await _repo.createHeroChain(today, current, _chips);
      offers = await _repo.offersFor(today, actionsById);
    }

    // A waiting option whose time has passed moves to the next free slot, so a time in the past is never shown.
    final slot = upcomingSlots(inputs.freeTimes, now).firstOrNull;
    final nowMinute = now.hour * 60 + now.minute;
    final stale = offers.any((o) =>
        o.status == OfferStatus.offered &&
        o.offer.suggestedTime != null &&
        (o.offer.suggestedDay.compareTo(today) < 0 ||
            (o.offer.suggestedDay == today && _minuteOf(o.offer.suggestedTime!) <= nowMinute)));
    if (pause == null && stale) {
      _assertConsentNow();
      await _repo.reslotWaiting(today, slot);
      offers = await _repo.offersFor(today, actionsById);
    }

    final planned = await _repo.planItems(today, actionsById);
    final shown = shownOffer(offers);
    // "Something lighter" is offered only if a lighter option exists and the one shown is not already that light;
    // otherwise the row would do nothing (spec: never a dead row).
    final shownIsLight = shown != null && shown.action.durationMin <= 10 && shown.action.energyNeeded == Energy.low;
    final lighterAvailable =
        pause == null && shown != null && !shownIsLight && plan(_chips, lighter: true).kind == TodayKind.options;
    final accepted = offers.any((o) => o.status == OfferStatus.accepted) || planned.any((p) => p.item.plannedDay == today);
    final waiting = shown != null;

    final mode = pause != null
        ? TodayMode.paused
        : switch (current.kind) {
            _ when waiting || accepted => TodayMode.options,
            TodayKind.nothingFitsChips => TodayMode.nothingFitsChips,
            TodayKind.nothingFitsChoices => TodayMode.nothingFitsChoices,
            TodayKind.options => TodayMode.allDone,
          };

    final answered = ref.read(wayBackAnswersProvider)?.lapseStartDay;
    return TodayView(
      wayBackOffered: lapse != null &&
          pause == null &&
          !accepted &&
          _wayBackDismissedDay != today &&
          answered != lapse.startDay,
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
      planned: planned,
    );
  }

  static int _minuteOf(String clock) => int.parse(clock.substring(0, 2)) * 60 + int.parse(clock.substring(3));

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

  List<GridDay> _days(String from, String to, String today, TodayInputs inputs, {bool includeFuture = false}) =>
      gridDays(
        from: from,
        to: to,
        today: today,
        reflections: inputs.reflections,
        pauses: inputs.pauses,
        includeFuture: includeFuture,
      );

  // ---- chips

  /// A new time or energy: re-rank what has not been acted on, for today only.
  Future<void> setChips(TodayChips chips) => _act((view) async {
        _chips = chips;
        final inputs = await _repo.inputs();
        final plan = buildTodayPlan(
          actions: inputs.actions,
          person: inputs.person,
          libraryVersion: inputs.libraryVersion,
          followedOrder: inputs.followedOrder,
          freeTimes: inputs.freeTimes,
          chips: chips,
          now: _now,
        );
        // Re-ranks what has not been acted on. When nothing fits the new chips the waiting offers are dropped, so
        // the screen shows the empty state and not a stale card.
        await _repo.createHeroChain(view.today, plan, chips);
        await _reload();
      });

  // ---- options

  /// "I'll try this" on the hero card. Returns true when it planned something, so the screen can offer Undo.
  Future<bool> acceptShown() async {
    var planned = false;
    await _act((view) async {
      final shown = view.shown;
      if (shown == null) return;
      planned = await _repo.accept(shown);
      if (planned) _lastAccept = (offerId: shown.offer.id, wasNew: false);
      await _reload();
    });
    return planned;
  }

  Future<bool> acceptCompact(TodayOption option) async {
    var planned = false;
    await _act((view) async {
      final id = await _repo.acceptNew(view.today, option, _chips);
      planned = id != null;
      if (id != null) _lastAccept = (offerId: id, wasNew: true);
      await _reload();
    });
    return planned;
  }

  /// Undo for the last "I'll try this": the plan item and its unknown reflection are removed.
  Future<void> undoLastAccept() async {
    final last = _lastAccept;
    if (last == null) return;
    await _act((_) async {
      await _repo.undoAccept(last.offerId, wasNew: last.wasNew);
      _lastAccept = null;
      await _reload();
    });
  }

  Future<void> swapShown() => _act((view) async {
        if (view.shown == null || !view.canSwap) return;
        await _repo.replace(view.shown!);
        await _reload();
      });

  /// "Something lighter" from the Not today sheet.
  Future<void> lighter() => _act((view) async {
        final shown = view.shown;
        if (shown == null || !view.lighterAvailable) return;
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
      });

  // ---- reflection

  /// Saves how it went and returns the one sentence that says what will change (F-003). Closing the sheet without
  /// saving never reaches here, so the reflection stays unknown (BR-009).
  Future<String?> saveReflection(PlannedItem item, ReflectionAnswer answer) async {
    String? sentence;
    // An answer belongs to its plan item, not to the day it was given, so it is saved even if midnight passed
    // while the sheet was open; the screen then shows the new day.
    await _act(
      (_) async {
        final result = await _repo.saveReflection(
          item.item.id,
          status: answer.status,
          enjoyment: answer.enjoyment,
          barrier: answer.barrier,
        );
        // The sentence only when something was written: never a confirmation for a save that did not happen.
        if (result == ReflectionSave.saved) {
          sentence = whatChangesNext(status: answer.status, enjoyment: answer.enjoyment, barrier: answer.barrier);
        }
        await _reload();
      },
      requireSameDay: false,
    );
    return sentence;
  }

  // ---- My Way Back (S-005)

  /// "Not now" on the welcome-back banner: it costs nothing and comes back tomorrow if the lapse goes on.
  Future<void> dismissWayBack() => _act((view) async {
        _wayBackDismissedDay = view.today;
        await _reload();
      });

  /// The end of My Way Back: keeps the answers for the return they belong to (EQ-011) and puts one small first
  /// step at the top of Today. It only offers it; nothing is planned until the person taps "I'll try this" (BR-005).
  /// Returns what it offered, or null when nothing fits (the answers are kept all the same).
  Future<WayBackStart?> startWayBack({required Set<String> whatChanged, required ReturnApproach approach}) async {
    WayBackStart? start;
    await _act((view) async {
      final inputs = await _repo.inputs();
      final pool = wayBackPool(
        actions: inputs.actions,
        reflections: inputs.reflections,
        wanted: approach,
        excluded: inputs.person.excluded,
      );
      final lapses = findLapses(
        reflectedDays: inputs.reflectedDays,
        pausedDays: pausedDays(inputs.pauses, view.today),
        today: view.today,
      );
      // Answers are kept only for a lapse that is open: with none there is no return to put them on.
      final open = lapses.isNotEmpty && lapses.last.isOpen ? lapses.last : null;
      ref.read(wayBackAnswersProvider.notifier).state = open == null
          ? null
          : WayBackAnswers(whatChanged: whatChanged, approach: pool.approach, lapseStartDay: open.startDay);

      // A small step first: the lighter options of the pool, then of the whole library, then anything that fits.
      const chips = TodayChips();
      _chips = chips;
      TodayPlan? chosen;
      for (final (actions, lighter) in [(pool.actions, true), (inputs.actions, true), (inputs.actions, false)]) {
        final plan = buildTodayPlan(
          actions: actions,
          person: inputs.person,
          libraryVersion: inputs.libraryVersion,
          followedOrder: inputs.followedOrder,
          freeTimes: inputs.freeTimes,
          chips: chips,
          now: _now,
          lighter: lighter,
        );
        if (plan.kind == TodayKind.options) {
          chosen = plan;
          break;
        }
      }
      if (chosen != null) {
        await _repo.createHeroChain(view.today, chosen, chips);
        final first = chosen.hero.first.ranked.action;
        start = WayBackStart(
          title: first.title,
          durationMin: first.durationMin,
          activity: first.activity,
          reason: chosen.hero.first.ranked.reason.text,
        );
      }
      await _reload();
    });
    return start;
  }

  // ---- pause

  /// "Pause for a while" (3, 7 or 14 days). [option] is the compact card the sheet was opened from, if any. With
  /// something already planned the sheet came from that state, so no waiting option is declined.
  Future<void> pause(int days, {TodayOption? option}) => _act((view) async {
        await _repo.pause(
          view.today,
          days,
          shown: option == null && view.accepted.isEmpty ? view.shown : null,
          declinedNew: option,
          chips: _chips,
        );
        await _reload();
      });

  Future<void> resume() => _act((view) async {
        await _repo.resume(view.today);
        await _reload();
      });
}

final todayControllerProvider = AsyncNotifierProvider<TodayController, TodayView>(TodayController.new);
