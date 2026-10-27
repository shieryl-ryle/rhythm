import '../data/enums.dart';

/// One day on the Rhythm grid (EQ-002). [level] is 0 to 3; a paused day with nothing done is [isPause], drawn
/// like level 0 but labelled "paused" (ADR-012).
class GridCell {
  const GridCell({required this.level, this.isPause = false});

  final int level;
  final bool isPause;

  @override
  bool operator ==(Object other) =>
      other is GridCell && other.level == level && other.isPause == isPause;

  @override
  int get hashCode => Object.hash(level, isPause);

  @override
  String toString() => 'GridCell(level: $level${isPause ? ', pause' : ''})';
}

/// EQ-002. `s` = completed + 0.5 × partly, `r = s / dailyGoal`: level 0 if r = 0, 1 if r < 0.5, 2 if r < 1,
/// 3 otherwise. `skipped` and `unknown` add nothing, and never lower a day below its level.
GridCell gridCell({
  required Iterable<ReflectionStatus> statuses,
  required int dailyGoal,
  required bool paused,
}) {
  if (dailyGoal < 1) throw ArgumentError.value(dailyGoal, 'dailyGoal', 'must be at least 1');
  var s = 0.0;
  for (final status in statuses) {
    if (status == ReflectionStatus.completed) s += 1;
    if (status == ReflectionStatus.partly) s += 0.5;
  }
  final r = s / dailyGoal;
  if (r == 0) return GridCell(level: 0, isPause: paused);
  if (r < 0.5) return const GridCell(level: 1);
  if (r < 1) return const GridCell(level: 2);
  return const GridCell(level: 3);
}
