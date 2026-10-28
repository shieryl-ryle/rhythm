import '../../data/enums.dart';

/// The setup wizard (S-003, docs/sitemap.md; frames 1.3 to 1.15). Pure Dart, so the order of the questions and
/// what each one needs can be tested without a screen.

/// One question. The first and last three are shared; the middle ones depend on the paths ticked on the first.
enum SetupStep {
  brings,
  keepActivity,
  keepProgress,
  addNew,
  pickUpWhich,
  pickUpStopped,
  pickUpGotInWay,
  pickUpHelp,
  startFresh,
  week,
  why,
  leaveOut,
}

/// The longest "why it matters" list (BR: up to 3).
const maxMotivations = 3;

/// Codes stored for the exclusive answers, which clear everything else in their group.
const accessNone = 'none';
const motivationPreferNotToSay = 'prefer_not_to_say';
const gotInTheWayPreferNotToSay = 'prefer_not_to_say';

/// What the person has answered so far. Immutable: every change returns a new value.
class SetupAnswers {
  const SetupAnswers({
    this.paths = const {},
    this.keepActivity,
    this.keepCustomName,
    this.progress,
    this.hardBecause = const {},
    this.addNewActivity,
    this.addNewCustomName,
    this.pickUpActivity,
    this.pickUpCustomName,
    this.stoppedAgo,
    this.gotInTheWay = const {},
    this.wouldHelp = const {},
    this.freshChoice,
    this.freeTimes = const {},
    this.access = const {},
    this.barriers = const {},
    this.motivations = const {},
    this.excluded = const {},
  });

  final Set<SetupPath> paths;

  // Keep going (frames 1.5, 1.7).
  final ActivityKind? keepActivity;
  final String? keepCustomName;
  final Progress? progress;
  final Set<String> hardBecause;

  // Add something new (frame 9.12): the activity they already do.
  final ActivityKind? addNewActivity;
  final String? addNewCustomName;

  // Pick up again (frames 1.8 to 1.11).
  final ActivityKind? pickUpActivity;
  final String? pickUpCustomName;
  final StoppedAgo? stoppedAgo;
  final Set<String> gotInTheWay;
  final Set<String> wouldHelp;

  // Start fresh (frame 9.13): dance, team_sports, racket_sports or not_sure.
  final ActivityKind? freshChoice;

  // Your week, why it matters, what to leave out (frames 1.12 to 1.14).
  final Set<String> freeTimes;
  final Set<String> access;
  final Set<String> barriers;
  final Set<String> motivations;
  final Set<String> excluded;

  SetupAnswers copyWith({
    Set<SetupPath>? paths,
    Object? keepActivity = _keep,
    Object? keepCustomName = _keep,
    Object? progress = _keep,
    Set<String>? hardBecause,
    Object? addNewActivity = _keep,
    Object? addNewCustomName = _keep,
    Object? pickUpActivity = _keep,
    Object? pickUpCustomName = _keep,
    Object? stoppedAgo = _keep,
    Set<String>? gotInTheWay,
    Set<String>? wouldHelp,
    Object? freshChoice = _keep,
    Set<String>? freeTimes,
    Set<String>? access,
    Set<String>? barriers,
    Set<String>? motivations,
    Set<String>? excluded,
  }) =>
      SetupAnswers(
        paths: paths ?? this.paths,
        keepActivity: identical(keepActivity, _keep) ? this.keepActivity : keepActivity as ActivityKind?,
        keepCustomName: identical(keepCustomName, _keep) ? this.keepCustomName : keepCustomName as String?,
        progress: identical(progress, _keep) ? this.progress : progress as Progress?,
        hardBecause: hardBecause ?? this.hardBecause,
        addNewActivity: identical(addNewActivity, _keep) ? this.addNewActivity : addNewActivity as ActivityKind?,
        addNewCustomName: identical(addNewCustomName, _keep) ? this.addNewCustomName : addNewCustomName as String?,
        pickUpActivity: identical(pickUpActivity, _keep) ? this.pickUpActivity : pickUpActivity as ActivityKind?,
        pickUpCustomName: identical(pickUpCustomName, _keep) ? this.pickUpCustomName : pickUpCustomName as String?,
        stoppedAgo: identical(stoppedAgo, _keep) ? this.stoppedAgo : stoppedAgo as StoppedAgo?,
        gotInTheWay: gotInTheWay ?? this.gotInTheWay,
        wouldHelp: wouldHelp ?? this.wouldHelp,
        freshChoice: identical(freshChoice, _keep) ? this.freshChoice : freshChoice as ActivityKind?,
        freeTimes: freeTimes ?? this.freeTimes,
        access: access ?? this.access,
        barriers: barriers ?? this.barriers,
        motivations: motivations ?? this.motivations,
        excluded: excluded ?? this.excluded,
      );

  static const _keep = Object();

  /// Ticking a path (frames 1.3, 1.4). "Start fresh" clears the others and the others clear it: it cannot be
  /// combined (F-001).
  SetupAnswers togglePath(SetupPath path) {
    final next = {...paths};
    if (next.contains(path)) {
      next.remove(path);
    } else if (path == SetupPath.startFresh) {
      next
        ..clear()
        ..add(path);
    } else {
      next
        ..remove(SetupPath.startFresh)
        ..add(path);
    }
    return copyWith(paths: next);
  }

  /// A multi-select group where one answer excludes the rest (None of these, Prefer not to say, Nothing to
  /// leave out). Choosing the exclusive one clears the others; choosing any other clears the exclusive one.
  static Set<String> toggleExclusive(Set<String> current, String code, {required String exclusive, int? max}) {
    final next = {...current};
    if (next.contains(code)) return next..remove(code);
    if (code == exclusive) return {exclusive};
    next.remove(exclusive);
    if (max != null && next.length >= max) return next; // the limit is reached: the extra tap does nothing
    return next..add(code);
  }

  static Set<String> toggle(Set<String> current, String code) {
    final next = {...current};
    return next.contains(code) ? (next..remove(code)) : (next..add(code));
  }

  /// "Why it matters": up to [maxMotivations], with "Prefer not to say" on its own.
  SetupAnswers toggleMotivation(String code) => copyWith(
        motivations: toggleExclusive(motivations, code, exclusive: motivationPreferNotToSay, max: maxMotivations),
      );

  SetupAnswers toggleAccess(String code) =>
      copyWith(access: toggleExclusive(access, code, exclusive: accessNone));

  SetupAnswers toggleGotInTheWay(String code) =>
      copyWith(gotInTheWay: toggleExclusive(gotInTheWay, code, exclusive: gotInTheWayPreferNotToSay));

  /// What to leave out. "Nothing to leave out" is not stored: an empty set means nothing.
  SetupAnswers toggleExcluded(String code) => copyWith(excluded: toggle(excluded, code));

  /// Whether the "What's making it harder?" question shows under the progress answer (frame 1.7).
  bool get asksWhatMakesItHarder =>
      progress == Progress.upAndDown || progress == Progress.gettingHarder;
}

/// The questions for the ticked paths, in the order of the frames: the first question, then each path's
/// questions (keep going, add new, pick up again), or the start-fresh question, then the three shared ones.
List<SetupStep> stepsFor(Set<SetupPath> paths) => [
      SetupStep.brings,
      if (paths.contains(SetupPath.keepGoing)) ...[SetupStep.keepActivity, SetupStep.keepProgress],
      // "What do you do now?" is asked once: Keep going already holds the activity they do today.
      if (paths.contains(SetupPath.addNew) && !paths.contains(SetupPath.keepGoing)) SetupStep.addNew,
      if (paths.contains(SetupPath.pickUpAgain)) ...[
        SetupStep.pickUpWhich,
        SetupStep.pickUpStopped,
        SetupStep.pickUpGotInWay,
        SetupStep.pickUpHelp,
      ],
      if (paths.contains(SetupPath.startFresh)) SetupStep.startFresh,
      SetupStep.week,
      SetupStep.why,
      SetupStep.leaveOut,
    ];

/// Whether Next is enabled. A required question with no answer keeps Next grey with a hint above it; an
/// optional one (the follow-ups to "why it stopped", why it matters, what to leave out) can be skipped.
bool canContinue(SetupStep step, SetupAnswers a) => switch (step) {
      SetupStep.brings => a.paths.isNotEmpty,
      SetupStep.keepActivity => a.keepActivity != null,
      SetupStep.keepProgress => a.progress != null,
      SetupStep.addNew => a.addNewActivity != null,
      SetupStep.pickUpWhich => a.pickUpActivity != null,
      SetupStep.pickUpStopped => a.stoppedAgo != null,
      SetupStep.startFresh => a.freshChoice != null,
      SetupStep.week => a.freeTimes.isNotEmpty,
      SetupStep.pickUpGotInWay ||
      SetupStep.pickUpHelp ||
      SetupStep.why ||
      SetupStep.leaveOut =>
        true,
    };

/// Questions with a Skip button under Next (BR-008: the reason it stopped is never forced).
bool canSkip(SetupStep step) =>
    step == SetupStep.pickUpGotInWay || step == SetupStep.pickUpHelp;

/// The hint above a grey Next.
String? requiredHint(SetupStep step) => switch (step) {
      SetupStep.brings => 'Pick at least one to continue.',
      SetupStep.week => 'Pick at least one time you are usually free.',
      SetupStep.keepActivity ||
      SetupStep.addNew ||
      SetupStep.pickUpWhich ||
      SetupStep.startFresh =>
        'Pick one to continue.',
      SetupStep.keepProgress || SetupStep.pickUpStopped => 'Pick one to continue.',
      _ => null,
    };

/// The label that names a section above the title ("Keep going", "Pick up again", ...), or null.
String? eyebrowFor(SetupStep step) => switch (step) {
      SetupStep.keepActivity || SetupStep.keepProgress => 'Keep going',
      SetupStep.addNew => 'Add something new',
      SetupStep.pickUpWhich ||
      SetupStep.pickUpStopped ||
      SetupStep.pickUpGotInWay ||
      SetupStep.pickUpHelp =>
        'Pick up again',
      SetupStep.startFresh => 'Start fresh',
      SetupStep.week => 'Your week',
      SetupStep.why => 'Almost done',
      SetupStep.leaveOut => 'Last step',
      SetupStep.brings => null,
    };

/// The first step of the section [step] belongs to, which "Edit" on the summary row goes back to. With Keep
/// going ticked, the row on "What would you like to pick up again?" summarises that section, so Edit goes there.
SetupStep sectionStart(SetupStep step, {bool keepGoingTicked = false}) => switch (step) {
      SetupStep.keepProgress => SetupStep.keepActivity,
      SetupStep.pickUpWhich when keepGoingTicked => SetupStep.keepActivity,
      SetupStep.pickUpStopped || SetupStep.pickUpGotInWay || SetupStep.pickUpHelp => SetupStep.pickUpWhich,
      _ => step,
    };

/// Leave-outs that cover something the person said they follow (BR-011: the leave-out wins). "Swimming" covers
/// swimming; "Team sports" (the tag `team_sport`) covers team sports and basketball, the same way the ranker
/// filters (docs/methods.md EQ-003).
List<ActivityKind> leaveOutConflicts(SetupAnswers a) {
  final followed = <ActivityKind>{
    ?a.keepActivity,
    ?a.addNewActivity,
    ?a.pickUpActivity,
    ?a.freshChoice,
  };
  final covered = <ActivityKind>{
    if (a.excluded.contains('swimming')) ActivityKind.swimming,
    if (a.excluded.contains('team_sport')) ...[ActivityKind.teamSports, ActivityKind.basketball],
  };
  return [
    for (final k in ActivityKind.values)
      if (followed.contains(k) && covered.contains(k)) k,
  ];
}
