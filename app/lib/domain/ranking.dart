import '../data/enums.dart';
import 'models.dart';
import 'patterns.dart';
import 'reasons.dart';

/// What the ranker knows about the person (their answers and history).
class PersonContext {
  const PersonContext({
    this.excluded = const {},
    this.access = const {},
    this.wouldHelp = const {},
    this.motivations = const {},
    this.followed = const {},
    this.savedActionIds = const {},
    this.observations = const [],
    this.reflections = const [],
  });

  /// `excluded` preference values: a tag (`after_dark`) or an activity code (`swimming`) (BR-011).
  final Set<String> excluded;

  /// `access` preference values: `gym_membership`, `pool`, `courts_or_park`, `home_equipment`, `none`.
  final Set<String> access;

  /// `would_help` codes across the activities they follow.
  final Set<String> wouldHelp;

  /// `motivation` preference values.
  final Set<String> motivations;

  final Set<ActivityKind> followed;
  final Set<String> savedActionIds;
  final List<ObservationInfo> observations;
  final List<ReflectionRecord> reflections;
}

/// What this request is for.
class RankingRequest {
  const RankingRequest({
    this.forToday = true,
    this.timeMin,
    this.energy,
    this.lighter = false,
    this.suggestionIsDark = false,
  });

  /// The chips (time, energy) filter only options suggested for today; a card for another day is not
  /// filtered by today's chips (EQ-003).
  final bool forToday;
  final int? timeMin;
  final Energy? energy;

  /// Lighter mode (UJ-004): at most 10 minutes and low energy.
  final bool lighter;

  /// The suggested time falls in dark hours. With "Outdoors after dark" left out, outdoor actions are then
  /// not offered, whatever their `after_dark` tag says.
  final bool suggestionIsDark;
}

/// The pieces of one action's score, kept so the reason can name the largest one (EQ-004).
class ScoreParts {
  const ScoreParts({
    required this.known,
    required this.done,
    required this.fit,
    required this.enjoyAnswers,
    required this.enjoy,
    required this.help,
    required this.saved,
    required this.observations,
  });

  /// Known reflections of this action (status other than `unknown`).
  final int known;

  /// completed + 0.5 × partly.
  final double done;
  final double fit;
  final int enjoyAnswers;
  final double enjoy;

  /// The `would_help` code that matched, or null.
  final String? help;
  final bool saved;

  /// Confirmed, positive observations whose pattern describes this action.
  final List<ObservationInfo> observations;

  double get bonus => (saved ? 0.2 : 0) + 0.2 * observations.length;
  double get helpTerm => help == null ? 0 : 0.1;

  /// EQ-003: 0.5 × fit + 0.3 × enjoy + help + bonus.
  double get score => 0.5 * fit + 0.3 * enjoy + helpTerm + bonus;
}

class RankedAction {
  const RankedAction({required this.action, required this.parts, required this.reason});

  final ActionInfo action;
  final ScoreParts parts;
  final Reason reason;

  double get score => parts.score;
}

const _accessTags = {
  'gym_membership': 'needs_gym',
  'pool': 'needs_pool',
  'courts_or_park': 'needs_courts_or_park',
  'home_equipment': 'needs_home_equipment',
};

const _tolerance = 1e-9;

/// EQ-003: filter, score, and take the top [limit] with at most one per activity. The same inputs always
/// give the same answer (no randomness), which is what makes TC-019 and TC-031 testable.
///
/// Filters, in order: the current [libraryVersion] only (a retired action is never offered again); nothing
/// the person left out (BR-011); nothing that needs access they do not have (an empty or `none` answer drops
/// every `needs_*` action); no outdoor action in dark hours when "after dark" is left out; today's chips;
/// lighter mode. With no known reflection at all, starters are offered (any action that passes the filters if
/// there is no starter). The result can still be shorter than [limit], or empty: the screen then shows its
/// "nothing fits today" state. An action that needs several kinds of access (`needs_*` tags) needs all of them. A person's history only counts
/// reflections whose status is not `unknown` (BR-009), and only confirmed observations count (BR-010).
List<RankedAction> rankOptions({
  required List<ActionInfo> actions,
  required PersonContext person,
  required RankingRequest request,
  required String libraryVersion,
  int limit = 3,
  List<ActionInfo>? reasonContext,
}) {
  final known = person.reflections.where((r) => r.isKnown).toList();
  // A reason can name an action outside the pool that was ranked ("Similar to ..."), so it looks in the whole
  // library when the caller passes it.
  final byId = {for (final a in reasonContext ?? actions) a.id: a};

  var pool = actions.where((a) => _isOffered(a, person, request, libraryVersion)).toList();
  if (known.isEmpty) {
    // Starters first; if none fit what the person allows, anything that does is better than an empty card.
    final starters = pool.where((a) => a.isStarter).toList();
    if (starters.isNotEmpty) pool = starters;
  }

  final scored = [
    for (final a in pool) _score(a, person, known),
  ];

  scored.sort((a, b) {
    final diff = b.score - a.score;
    if (diff.abs() > _tolerance) return diff > 0 ? 1 : -1;
    // A tie goes to what the person already follows, then to the id, so the order never changes by chance.
    final fa = person.followed.contains(a.action.activity) ? 0 : 1;
    final fb = person.followed.contains(b.action.activity) ? 0 : 1;
    if (fa != fb) return fa.compareTo(fb);
    return a.action.id.compareTo(b.action.id);
  });

  final picked = <RankedAction>[];
  final activities = <ActivityKind>{};
  for (final s in scored) {
    if (picked.length == limit) break;
    if (!activities.add(s.action.activity)) continue;
    picked.add(
      RankedAction(
        action: s.action,
        parts: s.parts,
        reason: chooseReason(action: s.action, parts: s.parts, person: person, request: request, byId: byId),
      ),
    );
  }
  return picked;
}

// Leaving out "Team sports" (frame 1.14, stored as the tag `team_sport`) also removes the team-sport and
// basketball activities, whether or not each action carries the tag (BR-011: never offered).
const _exclusionActivities = {
  'team_sport': ['team_sports', 'basketball'],
};

bool _isExcluded(ActionInfo a, Set<String> excluded) {
  if (excluded.contains(a.activity.code) || a.tags.any(excluded.contains)) return true;
  return excluded.any((e) => (_exclusionActivities[e] ?? const []).contains(a.activity.code));
}

bool _isOffered(ActionInfo a, PersonContext person, RankingRequest request, String libraryVersion) {
  if (a.libraryVersion != libraryVersion) return false;
  if (_isExcluded(a, person.excluded)) return false;

  final granted = {for (final code in person.access) ?_accessTags[code]};
  if (a.tags.any((t) => t.startsWith('needs_') && !granted.contains(t))) return false;

  if (request.suggestionIsDark && person.excluded.contains('after_dark') && a.tags.contains('outdoors')) {
    return false;
  }
  if (request.forToday) {
    final time = request.timeMin;
    if (time != null && a.durationMin > time) return false;
    if (request.energy == Energy.low && a.energyNeeded == Energy.high) return false;
  }
  if (request.lighter && (a.durationMin > 10 || a.energyNeeded != Energy.low)) return false;
  return true;
}

({ActionInfo action, ScoreParts parts, double score}) _score(
  ActionInfo a,
  PersonContext person,
  List<ReflectionRecord> known,
) {
  final mine = known.where((r) => r.actionId == a.id).toList();
  var done = 0.0;
  var enjoySum = 0;
  var enjoyAnswers = 0;
  for (final r in mine) {
    if (r.status == ReflectionStatus.completed) done += 1;
    if (r.status == ReflectionStatus.partly) done += 0.5;
    final e = r.enjoyment;
    if (e != null) {
      enjoySum += e;
      enjoyAnswers++;
    }
  }

  String? help;
  if (person.wouldHelp.contains('shorter_sessions') && a.durationMin <= 20) {
    help = 'shorter_sessions';
  } else if (person.wouldHelp.contains('someone_to_go_with') && a.tags.contains('with_company')) {
    help = 'someone_to_go_with';
  }

  final parts = ScoreParts(
    known: mine.length,
    done: done,
    fit: (done + 1) / (mine.length + 2),
    enjoyAnswers: enjoyAnswers,
    enjoy: enjoyAnswers == 0 ? 0 : (enjoySum - enjoyAnswers) / (2 * enjoyAnswers + 1),
    help: help,
    saved: person.savedActionIds.contains(a.id),
    observations: [
      for (final o in person.observations)
        if (o.status == ObsStatus.confirmed && (PatternKey.tryParse(o.patternKey)?.isPositive ?? false))
          if (PatternKey.tryParse(o.patternKey)!.describes(a)) o,
    ],
  );
  return (action: a, parts: parts, score: parts.score);
}
