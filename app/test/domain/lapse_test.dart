import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/domain/day.dart';
import 'package:lilt/domain/lapse.dart';
import 'package:lilt/domain/models.dart';

import '../support/domain_support.dart';
import 'package:lilt/data/enums.dart';

/// TC-029 (EQ-001): lapse detection, as a table.
void main() {
  // Reflected on 2026-11-01. Each case says what "today" is and what days are paused.
  const reflected = {'2026-11-01'};

  final cases = <({String name, Set<String> reflected, Set<String> paused, String today, String? lapseStart})>[
    (name: 'no history: no lapse', reflected: {}, paused: {}, today: '2026-11-20', lapseStart: null),
    (name: '2 empty days: no lapse', reflected: reflected, paused: {}, today: '2026-11-04', lapseStart: null),
    (name: '3 empty days: lapse from the first empty day', reflected: reflected, paused: {}, today: '2026-11-05', lapseStart: '2026-11-02'),
    (name: 'today does not count as an empty day', reflected: reflected, paused: {}, today: '2026-11-03', lapseStart: null),
    (
      name: '3 paused days: no lapse',
      reflected: reflected,
      paused: {'2026-11-02', '2026-11-03', '2026-11-04'},
      today: '2026-11-05',
      lapseStart: null,
    ),
    (
      name: 'a paused day in the middle breaks the run',
      reflected: reflected,
      paused: {'2026-11-03'},
      today: '2026-11-05',
      lapseStart: null,
    ),
    (
      name: 'a pause that ends, then 3 empty days: lapse from after the pause',
      reflected: reflected,
      paused: {'2026-11-02', '2026-11-03'},
      today: '2026-11-08',
      lapseStart: '2026-11-04',
    ),
    (
      name: 'reflecting today ends it',
      reflected: {'2026-11-01', '2026-11-05'},
      paused: {},
      today: '2026-11-05',
      lapseStart: null,
    ),
  ];

  for (final c in cases) {
    test(c.name, () {
      final lapse = openLapse(reflectedDays: c.reflected, pausedDays: c.paused, today: c.today);
      expect(lapse?.startDay, c.lapseStart);
    });
  }

  test('a reflected day after a lapse closes it, and that day is the return (EQ-011)', () {
    final spans = findLapses(
      reflectedDays: {'2026-11-01', '2026-11-08', '2026-11-09'},
      pausedDays: {},
      today: '2026-11-09',
    );
    expect(spans, [const LapseSpan(startDay: '2026-11-02', returnDay: '2026-11-08')]);
  });

  test('two separate lapses give two returns, and recording is idempotent', () {
    final spans = findLapses(
      reflectedDays: {'2026-11-01', '2026-11-06', '2026-11-12'},
      pausedDays: {},
      today: '2026-11-12',
    );
    expect(spans.map((s) => s.returnDay), ['2026-11-06', '2026-11-12']);

    final first = returnsToRecord(spans, {});
    expect(first, hasLength(2));
    final recorded = {for (final s in first) s.returnDay!};
    expect(returnsToRecord(spans, recorded), isEmpty);
  });

  test('skipped and unknown reflections do not make a reflected day', () {
    final days = reflectedDaysOf([
      reflect('2026-11-01', ReflectionStatus.skipped),
      reflect('2026-11-02', ReflectionStatus.unknown),
      reflect('2026-11-03', ReflectionStatus.partly),
      reflect('2026-11-04', ReflectionStatus.completed),
    ]);
    expect(days, {'2026-11-03', '2026-11-04'});
  });

  test('pausedDays expands ranges and runs an open pause up to today', () {
    final days = pausedDays(
      [
        const PauseSpan(startDay: '2026-11-01', endDay: '2026-11-03'),
        const PauseSpan(startDay: '2026-11-10'),
        const PauseSpan(startDay: '2026-12-01', endDay: '2026-12-05'),
      ],
      '2026-11-12',
    );
    expect(days, {'2026-11-01', '2026-11-02', '2026-11-03', '2026-11-10', '2026-11-11', '2026-11-12'});
  });

  test('days handle month ends and a leap day', () {
    expect(addDays('2028-02-28', 2), '2028-03-01');
    expect(addDays('2026-12-31', 1), '2027-01-01');
    expect(daysBetween('2026-11-01', '2026-11-08'), 7);
    expect(weekStart('2026-11-08'), '2026-11-02'); // a Sunday belongs to the week that began on Monday
    expect(() => parseDay('2026-02-30'), throwsFormatException);
  });
}
