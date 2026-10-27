import 'day.dart';
import 'models.dart';

/// EQ-001: a lapse starts after this many consecutive empty, unpaused days [assumption].
const lapseWindowDays = 3;

/// A stretch of days with nothing reflected. [returnDay] is the first reflected day afterwards, or null while
/// the lapse is still open.
class LapseSpan {
  const LapseSpan({required this.startDay, this.returnDay});

  final String startDay;
  final String? returnDay;

  bool get isOpen => returnDay == null;

  @override
  bool operator ==(Object other) =>
      other is LapseSpan && other.startDay == startDay && other.returnDay == returnDay;

  @override
  int get hashCode => Object.hash(startDay, returnDay);

  @override
  String toString() => 'LapseSpan($startDay -> ${returnDay ?? 'open'})';
}

/// The days covered by [pauses] up to and including [today]. A pause without an end runs until [today].
Set<String> pausedDays(List<PauseSpan> pauses, String today) {
  final days = <String>{};
  for (final p in pauses) {
    final end = p.endDay == null || p.endDay!.compareTo(today) > 0 ? today : p.endDay!;
    for (var d = p.startDay; d.compareTo(end) <= 0; d = addDays(d, 1)) {
      days.add(d);
    }
  }
  return days;
}

/// Every lapse in a history, oldest first (EQ-001). Only the last one can be open.
///
/// A person with no reflected day has no lapse. After that, [lapseWindowDays] days in a row before [today]
/// that are neither reflected nor paused start a lapse on the first of them. A paused day breaks the run, and
/// today does not count (it is not over yet). The lapse closes on the first reflected day, which is the return
/// (EQ-011). Nothing here ever reduces a total (BR-007): a lapse only labels a stretch of days.
List<LapseSpan> findLapses({
  required Set<String> reflectedDays,
  required Set<String> pausedDays,
  required String today,
}) {
  if (reflectedDays.isEmpty) return const [];
  final first = reflectedDays.reduce((a, b) => a.compareTo(b) <= 0 ? a : b);

  final spans = <LapseSpan>[];
  String? open;
  String? runStart;
  var run = 0;

  for (var day = addDays(first, 1); day.compareTo(today) <= 0; day = addDays(day, 1)) {
    if (reflectedDays.contains(day)) {
      if (open != null) spans.add(LapseSpan(startDay: open, returnDay: day));
      open = null;
      runStart = null;
      run = 0;
    } else if (open == null && day.compareTo(today) < 0) {
      if (pausedDays.contains(day)) {
        runStart = null;
        run = 0;
      } else {
        runStart ??= day;
        run++;
        if (run >= lapseWindowDays) open = runStart;
      }
    }
  }
  if (open != null) spans.add(LapseSpan(startDay: open));
  return spans;
}

/// The lapse the person is in on [today], or null.
LapseSpan? openLapse({
  required Set<String> reflectedDays,
  required Set<String> pausedDays,
  required String today,
}) {
  final spans = findLapses(reflectedDays: reflectedDays, pausedDays: pausedDays, today: today);
  return spans.isNotEmpty && spans.last.isOpen ? spans.last : null;
}

/// Reflected days from a list of reflections (EQ-001).
Set<String> reflectedDaysOf(Iterable<ReflectionRecord> reflections) => {
      for (final r in reflections)
        if (r.makesReflectedDay) r.day,
    };

/// Returns that are not recorded yet (EQ-011): each closed lapse whose return day has no `return_event`.
/// Recording one is idempotent, so calling this again after saving gives an empty list.
List<LapseSpan> returnsToRecord(List<LapseSpan> lapses, Set<String> recordedReturnDays) => [
      for (final l in lapses)
        if (!l.isOpen && !recordedReturnDays.contains(l.returnDay)) l,
    ];
