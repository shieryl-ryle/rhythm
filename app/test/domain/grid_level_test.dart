import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/domain/grid.dart';

/// TC-030 (EQ-002): grid levels for goal 1 and 2, with completed, partly, skipped, unknown and pause.
void main() {
  const c = ReflectionStatus.completed;
  const p = ReflectionStatus.partly;
  const s = ReflectionStatus.skipped;
  const u = ReflectionStatus.unknown;

  test('with the daily goal at 1 no day is ever level 1, so the legend needs no entry for it', () {
    // Level 1 is a share under half a day's goal, which a goal of 1 cannot produce (the least is one partly = 0.5).
    // A daily goal above 1 needs a legend entry and a colour at least 3:1 against grid-0 first (docs/sitemap.md S-006).
    const all = [ReflectionStatus.completed, ReflectionStatus.partly, ReflectionStatus.skipped, ReflectionStatus.unknown];
    for (final a in all) {
      for (final b in all) {
        expect(gridCell(statuses: [a, b], dailyGoal: 1, paused: false).level, isNot(1));
      }
      expect(gridCell(statuses: [a], dailyGoal: 1, paused: false).level, isNot(1));
    }
  });

  final cases = <({String name, List<ReflectionStatus> statuses, int goal, bool paused, GridCell cell})>[
    (name: 'goal 1, nothing', statuses: [], goal: 1, paused: false, cell: const GridCell(level: 0)),
    (name: 'goal 1, completed', statuses: [c], goal: 1, paused: false, cell: const GridCell(level: 3)),
    (name: 'goal 1, partly', statuses: [p], goal: 1, paused: false, cell: const GridCell(level: 2)),
    (name: 'goal 1, two partly add up to done', statuses: [p, p], goal: 1, paused: false, cell: const GridCell(level: 3)),
    (name: 'goal 1, skipped adds nothing', statuses: [s], goal: 1, paused: false, cell: const GridCell(level: 0)),
    (name: 'goal 1, unknown adds nothing', statuses: [u], goal: 1, paused: false, cell: const GridCell(level: 0)),
    (name: 'goal 1, skipped never lowers a done day', statuses: [c, s], goal: 1, paused: false, cell: const GridCell(level: 3)),
    (name: 'goal 1, unknown never lowers a partly day', statuses: [p, u], goal: 1, paused: false, cell: const GridCell(level: 2)),
    (name: 'goal 2, one completed is half way', statuses: [c], goal: 2, paused: false, cell: const GridCell(level: 2)),
    (name: 'goal 2, one partly is a quarter', statuses: [p], goal: 2, paused: false, cell: const GridCell(level: 1)),
    (name: 'goal 2, two completed', statuses: [c, c], goal: 2, paused: false, cell: const GridCell(level: 3)),
    (name: 'goal 2, completed and partly', statuses: [c, p], goal: 2, paused: false, cell: const GridCell(level: 2)),
    (name: 'goal 2, completed, partly, partly', statuses: [c, p, p], goal: 2, paused: false, cell: const GridCell(level: 3)),
    (name: 'paused with nothing done is the pause state', statuses: [], goal: 1, paused: true, cell: const GridCell(level: 0, isPause: true)),
    (name: 'paused with a skip is still the pause state', statuses: [s], goal: 1, paused: true, cell: const GridCell(level: 0, isPause: true)),
    (name: 'a paused day with something done shows its level', statuses: [c], goal: 1, paused: true, cell: const GridCell(level: 3)),
  ];

  for (final t in cases) {
    test(t.name, () {
      expect(gridCell(statuses: t.statuses, dailyGoal: t.goal, paused: t.paused), t.cell);
    });
  }

  test('a daily goal below 1 is rejected', () {
    expect(() => gridCell(statuses: [], dailyGoal: 0, paused: false), throwsArgumentError);
  });
}
