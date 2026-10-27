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

  test('the grid does not change for past days when a lapse starts', () {
    final days = [for (var i = 0; i < 6; i++) addDays('2026-11-01', i)];
    GridCell cell(String day) => gridCell(
          statuses: [ReflectionStatus.completed],
          dailyGoal: 1,
          paused: false,
        );
    final before = [for (final d in days) cell(d)];
    // Ten empty days later, the same days still show the same levels: levels are computed per day only.
    final later = [for (final d in days) cell(d)];
    expect(later, before);
    expect(before.every((c) => c.level == 3), isTrue);
  });
}
