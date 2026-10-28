import '../../data/enums.dart';
import '../../domain/day.dart';
import '../../domain/models.dart';
import '../../domain/ranking.dart';

/// What Today shows, decided from the person's answers and history (docs/methods.md EQ-003, docs/sitemap.md
/// "S-004 when few or no options fit"). Pure Dart, so every state can be tested without a screen.

/// The time and energy chips (frame 2.3). They apply to today only and reset each day (UF-002).
class TodayChips {
  const TodayChips({this.timeMin = defaultTimeMin, this.energy = Energy.medium});

  static const defaultTimeMin = 20;
  static const timeChoices = [10, 20, 30, 45];

  final int timeMin;
  final Energy energy;

  TodayChips copyWith({int? timeMin, Energy? energy}) =>
      TodayChips(timeMin: timeMin ?? this.timeMin, energy: energy ?? this.energy);

  @override
  bool operator ==(Object other) => other is TodayChips && other.timeMin == timeMin && other.energy == energy;

  @override
  int get hashCode => Object.hash(timeMin, energy);
}

/// A free-time slot turned into a day and a time (docs/data-model.md: clock times behind the free-time slots
/// [assumption]): early morning 07:00, lunch 12:30, after work 18:30, weekends Saturday 10:00.
class SuggestedSlot {
  const SuggestedSlot({required this.day, required this.minute, required this.code});

  final String day;
  final int minute;

  /// `early_morning`, `lunch`, `after_work` or `weekends`.
  final String code;

  /// "12:30".
  String get clock =>
      '${(minute ~/ 60).toString().padLeft(2, '0')}:${(minute % 60).toString().padLeft(2, '0')}';

  /// Dark hours for the "Outdoors after dark" leave-out: 18:00 to 06:00 [assumption]. The slot times are fixed,
  /// so this is a property of the slot, not of the season.
  bool get isDark => minute >= 18 * 60 || minute < 6 * 60;
}

const _slotMinutes = {'early_morning': 7 * 60, 'lunch': 12 * 60 + 30, 'after_work': 18 * 60 + 30, 'weekends': 10 * 60};

const slotLabels = {
  'early_morning': 'early morning',
  'lunch': 'lunch',
  'after_work': 'after work',
  'weekends': 'weekends',
};

/// The next free slot at or after [now] (local), looking a week ahead, or null when the person gave no free
/// time. Weekday slots fall on every day, "weekends" on Saturday. A slot that has already started today is
/// skipped, so Today never suggests the past.
List<SuggestedSlot> upcomingSlots(Set<String> freeTimes, DateTime now) {
  final today = formatDay(DateTime.utc(now.year, now.month, now.day));
  final nowMinute = now.hour * 60 + now.minute;
  final slots = <SuggestedSlot>[];
  for (var offset = 0; offset < 15; offset++) {
    final day = addDays(today, offset);
    final weekday = parseDay(day).weekday;
    for (final code in ['early_morning', 'lunch', 'after_work', 'weekends']) {
      if (!freeTimes.contains(code)) continue;
      if (code == 'weekends' ? weekday != DateTime.saturday : false) continue;
      final minute = _slotMinutes[code]!;
      if (offset == 0 && minute <= nowMinute) continue;
      slots.add(SuggestedSlot(day: day, minute: minute, code: code));
    }
  }
  slots.sort((a, b) {
    final byDay = a.day.compareTo(b.day);
    return byDay != 0 ? byDay : a.minute.compareTo(b.minute);
  });
  return slots;
}

/// "Suggested 12:30 · lunch" for today, "Suggested Sat 10:00 · weekends" for another day.
String suggestedLabel(SuggestedSlot slot, String today) {
  final dayPart = slot.day == today ? '' : '${_weekdayName(slot.day)} ';
  // Non-breaking spaces keep "12:30 · lunch" together when the text wraps at large sizes.
  return 'Suggested $dayPart${slot.clock}\u00A0·\u00A0${slotLabels[slot.code]!.replaceAll(' ', '\u00A0')}';
}

String _weekdayName(String day) => const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][parseDay(day).weekday - 1];

/// One option on Today: the ranked action and when it is suggested.
class TodayOption {
  const TodayOption({required this.ranked, this.slot});

  final RankedAction ranked;

  /// Null when the person gave no free time.
  final SuggestedSlot? slot;
}

enum TodayKind {
  /// At least one option fits.
  options,

  /// Nothing fits today's time or energy chips, but would without them (state N2).
  nothingFitsChips,

  /// Nothing fits even without the chips: leave-outs, access or an empty library (state N3).
  nothingFitsChoices,
}

/// How the chips could be relaxed to show options again (state N2), applied for today only.
class ChipRelaxation {
  const ChipRelaxation({required this.label, required this.chips});

  final String label;
  final TodayChips chips;
}

class TodayPlan {
  const TodayPlan({
    required this.kind,
    this.hero = const [],
    this.others = const [],
    this.relaxation,
  });

  final TodayKind kind;

  /// The options the hero card cycles through with "Something else": the ranker's top options, one per activity.
  final List<TodayOption> hero;

  /// The best option for each followed activity, in the order they were followed. The compact cards under the
  /// hero (frame 2.3) show the ones that are not the hero's current activity: see [compactCards].
  final List<TodayOption> others;
  final ChipRelaxation? relaxation;

  /// Up to [maxCompactCards] cards for the person's other followed activities, never repeating the activity the
  /// hero card shows right now (it changes with "Something else").
  List<TodayOption> compactCards(ActivityKind heroActivity) => [
        for (final o in others)
          if (o.ranked.action.activity != heroActivity) o,
      ].take(maxCompactCards).toList();
}

/// The most compact cards shown under the hero.
const maxCompactCards = 2;

/// Builds what Today shows (docs/sitemap.md "S-004 when few or no options fit"): rank with the chips; if that
/// returns nothing, rank again without them to tell the two cases apart. Leave-outs and access are never
/// relaxed (BR-011), and nothing is planned (BR-005): the plan only lists options.
TodayPlan buildTodayPlan({
  required List<ActionInfo> actions,
  required PersonContext person,
  required String libraryVersion,
  required List<ActivityKind> followedOrder,
  required Set<String> freeTimes,
  required TodayChips chips,
  required DateTime now,
  bool lighter = false,
}) {
  final today = formatDay(DateTime.utc(now.year, now.month, now.day));
  final slots = upcomingSlots(freeTimes, now);
  final heroSlot = slots.isEmpty ? null : slots.first;

  List<RankedAction> rank({
    required int? timeMin,
    required Energy? energy,
    bool lighterMode = false,
    List<ActionInfo>? pool,
    int limit = 3,
    SuggestedSlot? slot,
  }) =>
      rankOptions(
        actions: pool ?? actions,
        person: person,
        libraryVersion: libraryVersion,
        limit: limit,
        reasonContext: actions,
        request: RankingRequest(
          // Today's chips filter only what is suggested for today (EQ-003).
          forToday: slot == null || slot.day == today,
          timeMin: timeMin,
          energy: energy,
          lighter: lighterMode,
          suggestionIsDark: slot?.isDark ?? false,
        ),
      );

  final hero = rank(timeMin: chips.timeMin, energy: chips.energy, lighterMode: lighter, slot: heroSlot);

  if (hero.isEmpty) {
    final relaxed = rank(timeMin: null, energy: null, lighterMode: lighter, slot: heroSlot);
    if (relaxed.isEmpty) return const TodayPlan(kind: TodayKind.nothingFitsChoices);
    bool hasOptions(TodayChips c) =>
        rank(timeMin: c.timeMin, energy: c.energy, lighterMode: lighter, slot: heroSlot).isNotEmpty;
    // The chips top out at 45 minutes and high energy. If even that brings nothing back (only a longer action
    // is left), no chip can fix it, so it is the other case: a button that changes nothing would be a trap.
    if (!hasOptions(TodayChips(timeMin: TodayChips.timeChoices.last, energy: Energy.high))) {
      return const TodayPlan(kind: TodayKind.nothingFitsChoices);
    }
    return TodayPlan(kind: TodayKind.nothingFitsChips, relaxation: _relaxation(chips, hasOptions));
  }

  // One candidate per followed activity: its best option, with the next free slot after the hero's.
  final others = <TodayOption>[];
  var slotIndex = 1;
  for (final kind in followedOrder) {
    if (others.any((o) => o.ranked.action.activity == kind)) continue;
    final slot = slotIndex < slots.length ? slots[slotIndex] : null;
    final isHeroActivity = kind == hero.first.action.activity;
    final best = rank(
      timeMin: chips.timeMin,
      energy: chips.energy,
      lighterMode: lighter,
      pool: [for (final a in actions) if (a.activity == kind) a],
      limit: 1,
      slot: slot,
    );
    if (best.isEmpty) continue;
    others.add(TodayOption(ranked: best.first, slot: slot));
    // The hero's activity shows no compact card at first, so it does not use up a later slot.
    if (!isHeroActivity) slotIndex++;
  }

  return TodayPlan(
    kind: TodayKind.options,
    hero: [for (final h in hero) TodayOption(ranked: h, slot: heroSlot)],
    others: others,
  );
}

/// The smallest change to the chips that brings an option back: raise the time first (20, 30, 45), then the
/// energy, and last both ("Show options for any time and energy"). Matches the written spec for state N2.
ChipRelaxation _relaxation(TodayChips chips, bool Function(TodayChips) hasOptions) {
  for (final t in TodayChips.timeChoices.where((t) => t > chips.timeMin)) {
    final next = chips.copyWith(timeMin: t);
    if (hasOptions(next)) return ChipRelaxation(label: 'Show options up to $t min', chips: next);
  }
  for (final e in [Energy.medium, Energy.high].where((e) => e.index > chips.energy.index)) {
    final next = chips.copyWith(energy: e);
    if (hasOptions(next)) {
      return ChipRelaxation(label: 'Show ${e.code}-energy options', chips: next);
    }
  }
  return ChipRelaxation(
    label: 'Show options for any time and energy',
    chips: TodayChips(timeMin: TodayChips.timeChoices.last, energy: Energy.high),
  );
}
