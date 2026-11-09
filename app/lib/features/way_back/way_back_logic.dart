import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/enums.dart';
import '../../data/providers.dart';
import '../../domain/models.dart';
import '../../domain/ranking.dart';

/// S-005 My Way Back (F-005, UF-004). Pure rules: what the person can say changed, and which actions a "way back"
/// draws from. Nothing here writes anything.

/// "What changed?" (frame 4.1). The codes are what `return_event.what_changed` stores (docs/data-model.md).
const whatChangedOptions = <({String code, String label})>[
  (code: 'busier', label: 'Busier at work or study'),
  (code: 'health_energy', label: 'Health or energy'),
  (code: 'family_caring', label: 'Family or caring'),
  (code: 'moved', label: 'Moved or travelling'),
  (code: 'group_or_gym_changed', label: 'My group or gym changed'),
  (code: 'just_drifted', label: 'Just drifted'),
  (code: 'prefer_not_to_say', label: 'Prefer not to say'),
];

const preferNotToSay = 'prefer_not_to_say';

/// "Prefer not to say" is exclusive: picking it clears the others, and picking another clears it (data model rule).
Set<String> toggleWhatChanged(Set<String> current, String code) {
  if (current.contains(code)) return {...current}..remove(code);
  if (code == preferNotToSay) return {preferNotToSay};
  return {...current, code}..remove(preferNotToSay);
}

/// What the person said on the way back, kept until the return it belongs to is recorded (EQ-011). [lapseStartDay]
/// ties the answers to one lapse, so they can never be filed against a later one.
class WayBackAnswers {
  const WayBackAnswers({required this.whatChanged, required this.approach, this.lapseStartDay});

  final Set<String> whatChanged;
  final ReturnApproach approach;
  final String? lapseStartDay;

  /// A skipped question stores nothing (null), not an empty string (data model, frame 4.1).
  String? get whatChangedCsv => whatChanged.isEmpty ? null : (whatChanged.toList()..sort()).join(',');
}

/// The answers waiting for the person to come back, held in memory only: an app restart before the first
/// reflection loses them, and the return is then recorded without them (they are optional, BR-008).
final wayBackAnswersProvider = StateProvider<WayBackAnswers?>((ref) {
  // Watching consent means delete-all, which invalidates it, also clears the answers (BR-017).
  ref.watch(consentProvider);
  return null;
});

/// Activities the person has done before (a `completed` or `partly` reflection), most recent first.
List<ActivityKind> previousActivities(Iterable<ReflectionRecord> reflections) {
  final done = [
    for (final r in reflections)
      if (r.makesReflectedDay) r,
  ]..sort((a, b) => b.day.compareTo(a.day));
  final seen = <ActivityKind>[];
  for (final r in done) {
    if (!seen.contains(r.activity)) seen.add(r.activity);
  }
  return seen;
}

/// The actions a way back draws from, and the approach that really applied. "Go back to what helped" offers only
/// activities the person has done; with none it falls back to the library's starters (UF-004 branch point).
/// "Try something different" leaves out the activity done most recently, unless that leaves nothing.
({List<ActionInfo> actions, ReturnApproach approach}) wayBackPool({
  required List<ActionInfo> actions,
  required Iterable<ReflectionRecord> reflections,
  required ReturnApproach wanted,
  Set<String> excluded = const {},
}) {
  // What the person left out is never part of a way back (BR-011).
  actions = [
    for (final a in actions)
      if (!isExcludedAction(a, excluded)) a,
  ];
  final previous = previousActivities(reflections);
  if (wanted == ReturnApproach.different) {
    final others = previous.isEmpty
        ? actions
        : [
            for (final a in actions)
              if (a.activity != previous.first) a,
          ];
    return (actions: others.isEmpty ? actions : others, approach: ReturnApproach.different);
  }
  final helped = [
    for (final a in actions)
      if (previous.contains(a.activity)) a,
  ];
  if (helped.isNotEmpty) return (actions: helped, approach: ReturnApproach.previous);
  final starters = [
    for (final a in actions)
      if (a.isStarter) a,
  ];
  return (actions: starters.isEmpty ? actions : starters, approach: ReturnApproach.starter);
}

/// What the way back offered as the small first step, for the last screen.
class WayBackStart {
  const WayBackStart({required this.title, required this.durationMin, required this.activity, required this.reason});

  /// Why this one (BR-004).
  final String reason;

  final String title;
  final int durationMin;
  final ActivityKind activity;
}
