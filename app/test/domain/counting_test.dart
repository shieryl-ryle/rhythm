import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/domain/day.dart';
import 'package:lilt/domain/grid.dart';
import 'package:lilt/domain/lapse.dart';
import 'package:lilt/domain/metrics.dart';
import 'package:lilt/domain/models.dart';

import '../support/domain_support.dart';

/// TC-015 (BR-007), the counting part: after a 10-day lapse, active days and returns are unchanged or higher.
/// There are no streaks: nothing here has a number that resets. (The wording part is in
/// `test/content/guilt_words_test.dart`.)
void main() {
  test('a 10-day lapse leaves active days and returns unchanged, and a return only adds', () {
    final before = [for (var i = 0; i < 6; i++) done(addDays('2026-11-01', i))]; // days 1-6
    final during = [
      for (var i = 6; i < 16; i++)
        if (i.isEven) reflect(addDays('2026-11-01', i), ReflectionStatus.skipped), // 10 days: skips, no reflection
    ];
    final after = [done(addDays('2026-11-01', 16)), done(addDays('2026-11-01', 17))];

    Totals at(String today, List<ReflectionRecord> reflections) {
      final lapses = findLapses(
        reflectedDays: reflectedDaysOf(reflections),
        pausedDays: const {},
        today: today,
      );
      return totals(reflections: reflections, returnEvents: returnsToRecord(lapses, {}).length);
    }

    final beforeLapse = at('2026-11-06', before);
    final inLapse = at('2026-11-16', [...before, ...during]);
    final afterReturn = at('2026-11-18', [...before, ...during, ...after]);

    expect(inLapse.activeDays, greaterThanOrEqualTo(beforeLapse.activeDays));
    expect(inLapse.returns, greaterThanOrEqualTo(beforeLapse.returns));
    expect(afterReturn.activeDays, beforeLapse.activeDays + 2);
    expect(afterReturn.returns, beforeLapse.returns + 1);
  });

  test('the grid for past days does not change when a lapse starts or ends', () {
    const start = '2026-11-01';
    final days = [for (var i = 0; i < 6; i++) addDays(start, i)];
    final history = [
      for (var i = 0; i < 6; i++) i.isEven ? done(days[i]) : reflect(days[i], ReflectionStatus.partly),
    ];

    // The grid is built from the day's own reflections, the way the Progress screen will.
    List<GridCell> gridAsOf(List<ReflectionRecord> reflections, Set<String> paused) => [
          for (final d in days)
            gridCell(
              statuses: [
                for (final r in reflections)
                  if (r.day == d) r.status,
              ],
              dailyGoal: 1,
              paused: paused.contains(d),
            ),
        ];

    final before = gridAsOf(history, const {});
    expect(before.map((c) => c.level), [3, 2, 3, 2, 3, 2]);

    // Ten empty days pass (skips and unknowns), then a return: the first six days are unchanged.
    final later = [
      ...history,
      for (var i = 6; i < 16; i++)
        reflect(addDays(start, i), i.isEven ? ReflectionStatus.skipped : ReflectionStatus.unknown),
      done(addDays(start, 16)),
    ];
    expect(gridAsOf(later, const {}), before);

    // A pause that starts after those days does not touch them either.
    expect(gridAsOf(later, {addDays(start, 7), addDays(start, 8)}), before);
  });
}
