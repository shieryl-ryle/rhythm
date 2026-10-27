import '../data/enums.dart';
import 'models.dart';
import 'patterns.dart';

/// EQ-009 [assumption]: a pattern needs this many known reflections, and two thirds of them must agree.
const minObservationEvidence = 3;

/// Tags worth noting back to a person. Access and leave-out tags describe the library, not a preference.
const _patternTags = {'solo', 'with_company', 'indoors', 'outdoors', 'free', 'paid', 'team_sport'};

/// A pattern the rules noticed, offered to the person to confirm, edit or delete (BR-010). It changes nothing
/// until they confirm it.
class ObservationProposal {
  const ObservationProposal({
    required this.patternKey,
    required this.text,
    required this.matches,
    required this.agreeing,
  });

  final String patternKey;

  /// Template text, never AI-worded here.
  final String text;
  final int matches;
  final int agreeing;
}

/// EQ-009. Proposes at most one new observation per day, so the screen never fills with them.
///
/// For a pattern *p* (a tag, an activity or a time of day) with at least [minObservationEvidence] known
/// reflections, propose it when at least 2/3 of them were done or partly done and enjoyed ("Enjoyed it", 3),
/// or when at least 2/3 were skipped for the same barrier. "Okay" and unanswered enjoyment are neutral.
/// [existingKeys] are all observations already made, including deleted ones, so a deleted observation is not
/// proposed again. [proposedToday] is how many were already proposed on [today].
ObservationProposal? proposeObservation({
  required List<ReflectionRecord> reflections,
  required Set<String> existingKeys,
  required int proposedToday,
}) {
  if (proposedToday >= 1) return null;
  final known = reflections.where((r) => r.isKnown).toList();

  // Group reflections by the pattern they belong to.
  final groups = <String, List<ReflectionRecord>>{};
  void add(String key, ReflectionRecord r) => (groups[key] ??= []).add(r);
  for (final r in known) {
    add('activity:${r.activity.code}', r);
    for (final t in r.tags.where(_patternTags.contains)) {
      add('tag:$t', r);
    }
    final minute = r.plannedMinute;
    if (minute != null) add('time:${timeOfDay(minute)}', r);
  }

  final candidates = <ObservationProposal>[];
  for (final entry in groups.entries) {
    final group = entry.value;
    if (group.length < minObservationEvidence) continue;

    final enjoyed = group.where((r) => r.makesReflectedDay && r.enjoyment == 3).length;
    _consider(candidates, existingKeys, '${entry.key}:enjoyed', group.length, enjoyed);

    final skippedBy = <Barrier, int>{};
    for (final r in group) {
      final b = r.barrier;
      if (r.status == ReflectionStatus.skipped && b != null && b != Barrier.preferNotToSay) {
        skippedBy[b] = (skippedBy[b] ?? 0) + 1;
      }
    }
    for (final b in skippedBy.entries) {
      _consider(candidates, existingKeys, '${entry.key}:barrier_${b.key.code}', group.length, b.value);
    }
  }
  if (candidates.isEmpty) return null;

  // The clearest pattern first, then the one with the most evidence, then by key so the choice is stable.
  candidates.sort((a, b) {
    final ra = a.agreeing / a.matches;
    final rb = b.agreeing / b.matches;
    if (ra != rb) return rb.compareTo(ra);
    if (a.matches != b.matches) return b.matches.compareTo(a.matches);
    return a.patternKey.compareTo(b.patternKey);
  });
  return candidates.first;
}

void _consider(
  List<ObservationProposal> out,
  Set<String> existingKeys,
  String key,
  int matches,
  int agreeing,
) {
  if (agreeing * 3 < matches * 2 || existingKeys.contains(key)) return;
  final text = observationText(key);
  if (text == null) return;
  out.add(ObservationProposal(patternKey: key, text: text, matches: matches, agreeing: agreeing));
}

const _tagLabels = {
  'solo': 'doing things on your own',
  'with_company': 'being active with other people',
  'indoors': 'being active indoors',
  'outdoors': 'being active outdoors',
  'free': 'free activities',
  'paid': 'activities you pay for',
  'team_sport': 'team sports',
};

const _activityLabels = {
  'walking': 'walking',
  'running': 'running',
  'gym': 'the gym',
  'cycling': 'cycling',
  'swimming': 'swimming',
  'basketball': 'basketball',
  'racket_sports': 'racket sports',
  'team_sports': 'team sports',
  'pickleball': 'pickleball',
  'yoga': 'yoga',
  'dance': 'dancing',
  'hiking': 'hiking',
  'bouldering': 'bouldering',
  'pilates': 'pilates',
  'other': 'your own activities',
};

const _barrierLabels = {
  'time': 'Time',
  'low_energy': 'Low energy',
  'schedule': 'Your schedule',
  'weather': 'Weather',
  'other': 'Something else',
};

/// Template wording for a pattern key (EQ-009), or null for a key that is not in the machine format. The
/// wording is checked against the blocked-claims and never-use lists in `test/domain/observation_test.dart`.
String? observationText(String key) {
  final p = PatternKey.tryParse(key);
  if (p == null) return null;
  final label = switch (p.kind) {
    'tag' => _tagLabels[p.value],
    'activity' => _activityLabels[p.value],
    'time' => '${p.value} activity',
    _ => null,
  };
  if (label == null) return null;
  if (p.isPositive) return 'You said $label felt good';
  const prefix = 'barrier_';
  if (!p.outcome.startsWith(prefix)) return null;
  final barrier = _barrierLabels[p.outcome.substring(prefix.length)];
  return barrier == null ? null : '$barrier often gets in the way of $label';
}
