import 'models.dart';

/// What an observation is about (EQ-009): `kind:value:outcome`, such as `tag:with_company:enjoyed` or
/// `activity:running:barrier_time`. Kinds are `tag`, `activity` and `time` (morning, afternoon, evening).
/// Outcomes are `enjoyed` or `barrier_<code>`.
class PatternKey {
  const PatternKey({required this.kind, required this.value, required this.outcome});

  final String kind;
  final String value;
  final String outcome;

  /// Null when [key] is not in the machine format, such as a note the person wrote themselves.
  static PatternKey? tryParse(String key) {
    final parts = key.split(':');
    if (parts.length != 3 || parts.any((p) => p.isEmpty)) return null;
    return PatternKey(kind: parts[0], value: parts[1], outcome: parts[2]);
  }

  @override
  String toString() => '$kind:$value:$outcome';

  bool get isPositive => outcome == 'enjoyed';

  /// Whether this pattern is about [action]. A time-of-day pattern says nothing about the action itself.
  bool describes(ActionInfo action) => switch (kind) {
        'tag' => action.tags.contains(value),
        'activity' => action.activity.code == value,
        _ => false,
      };
}

/// The part of the day a planned minute falls in, for `time:` patterns.
String timeOfDay(int minute) => minute < 12 * 60
    ? 'morning'
    : minute < 17 * 60
        ? 'afternoon'
        : 'evening';
