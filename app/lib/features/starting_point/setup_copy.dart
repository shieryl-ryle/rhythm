import '../../data/enums.dart';
import 'setup_model.dart';

/// The words and codes for the setup answers (docs/data-model.md §7, frames 1.3 to 1.14). Codes are what is
/// stored; labels are what the person sees.
class Option<T> {
  const Option(this.value, this.label, {this.subtitle});

  final T value;
  final String label;
  final String? subtitle;
}

const pathOptions = [
  Option(SetupPath.keepGoing, 'Keep going with something I do now'),
  Option(SetupPath.pickUpAgain, 'Pick up something I stopped'),
  Option(SetupPath.addNew, 'Add something new to what I do'),
  Option(SetupPath.startFresh, 'Start being active for the first time', subtitle: 'Can’t be combined with the others'),
];

/// An activity the person can pick on one of the first questions. "Other" opens the search (frame 1.6).
class ActivityEntry {
  const ActivityEntry(this.kind, this.label, this.blurb, {this.keywords = const []});

  final ActivityKind kind;
  final String label;

  /// One short line under the name in the search results.
  final String blurb;
  final List<String> keywords;
}

/// Every activity that can be followed, for the chips and the search. The blurbs are plain descriptions and are
/// held to the blocked-claims and never-use lists in `test/features/setup_copy_test.dart`.
const activityCatalogue = [
  ActivityEntry(ActivityKind.walking, 'Walking', 'Easy and anywhere', keywords: ['walk', 'stroll']),
  ActivityEntry(ActivityKind.running, 'Running', 'Easy jogs and run-walks', keywords: ['run', 'jog']),
  ActivityEntry(ActivityKind.gym, 'Gym', 'Machines and weights', keywords: ['weights', 'strength']),
  ActivityEntry(ActivityKind.cycling, 'Cycling', 'Ride outdoors or indoors', keywords: ['bike', 'cycle']),
  ActivityEntry(ActivityKind.swimming, 'Swimming', 'Laps or a class', keywords: ['swim', 'pool']),
  ActivityEntry(ActivityKind.basketball, 'Basketball', 'Shoot hoops or play a game', keywords: ['hoops']),
  ActivityEntry(ActivityKind.racketSports, 'Racket sports', 'Badminton, tennis and more',
      keywords: ['tennis', 'badminton', 'squash', 'racquet']),
  ActivityEntry(ActivityKind.teamSports, 'Team sports', 'Games with other people',
      keywords: ['football', 'soccer', 'netball', 'rugby', 'cricket', 'hockey', 'volleyball']),
  ActivityEntry(ActivityKind.pickleball, 'Pickleball', 'Paddle sport, very social', keywords: ['paddle']),
  ActivityEntry(ActivityKind.yoga, 'Yoga', 'Slow stretching and breathing', keywords: ['stretch']),
  ActivityEntry(ActivityKind.dance, 'Dance', 'Move to music', keywords: ['dancing', 'zumba']),
  ActivityEntry(ActivityKind.hiking, 'Hiking', 'Walks on trails', keywords: ['hike', 'trail']),
  ActivityEntry(ActivityKind.bouldering, 'Bouldering', 'Short climbs, no ropes', keywords: ['climb', 'climbing']),
  ActivityEntry(ActivityKind.pilates, 'Pilates', 'Strength and flexibility', keywords: ['mat', 'reformer']),
];

ActivityEntry? catalogueEntry(ActivityKind kind) {
  for (final e in activityCatalogue) {
    if (e.kind == kind) return e;
  }
  return null;
}

/// Activities already shown as chips on a question, in the order of the frames; "Other" is added after them.
const keepGoingKinds = [
  ActivityKind.walking,
  ActivityKind.running,
  ActivityKind.gym,
  ActivityKind.cycling,
  ActivityKind.swimming,
  ActivityKind.basketball,
  ActivityKind.racketSports,
  ActivityKind.yoga,
];

const addNewKinds = [
  ActivityKind.walking,
  ActivityKind.running,
  ActivityKind.gym,
  ActivityKind.cycling,
  ActivityKind.swimming,
  ActivityKind.yoga,
];

const pickUpKinds = [
  ActivityKind.running,
  ActivityKind.gym,
  ActivityKind.swimming,
  ActivityKind.cycling,
  ActivityKind.basketball,
  ActivityKind.yoga,
  ActivityKind.dance,
];

const freshOptions = [
  Option(ActivityKind.dance, 'Dancing'),
  Option(ActivityKind.teamSports, 'Team sports'),
  Option(ActivityKind.racketSports, 'Racket sports'),
  Option(ActivityKind.notSure, 'Not sure yet'),
];

const progressOptions = [
  Option(Progress.goingWell, 'Going well'),
  Option(Progress.upAndDown, 'Up and down'),
  Option(Progress.gettingHarder, 'Getting harder'),
];

const hardBecauseOptions = [
  Option('finding_time', 'Finding time'),
  Option('energy', 'Energy'),
  Option('getting_bored', 'Getting bored'),
  Option('cost', 'Cost'),
  Option('motivation', 'Motivation'),
];

const stoppedOptions = [
  Option(StoppedAgo.weeks, 'A few weeks ago'),
  Option(StoppedAgo.months, 'A few months ago'),
  Option(StoppedAgo.yearPlus, 'A year or more'),
];

const gotInTheWayOptions = [
  Option('busier', 'Busier at work or study'),
  Option('health_energy', 'Health or energy'),
  Option('moved', 'Moved'),
  Option('group_or_gym_changed', 'Lost my group or gym'),
  Option('just_drifted', 'Just drifted'),
  Option(gotInTheWayPreferNotToSay, 'Prefer not to say'),
];

const wouldHelpOptions = [
  Option('shorter_sessions', 'Shorter sessions'),
  Option('someone_to_go_with', 'Someone to go with'),
  Option('different_time', 'A different time'),
  Option('something_similar', 'Something similar'),
  Option('not_sure', 'Not sure'),
];

const freeTimeOptions = [
  Option('early_morning', 'Early morning'),
  Option('lunch', 'Lunch'),
  Option('after_work', 'After work'),
  Option('weekends', 'Weekends'),
];

const accessOptions = [
  Option('gym_membership', 'Gym membership'),
  Option('pool', 'Pool'),
  Option('courts_or_park', 'Courts or a park nearby'),
  Option('home_equipment', 'Equipment at home'),
  Option(accessNone, 'None of these'),
];

const barrierOptions = [
  Option('time', 'Time'),
  Option('energy', 'Energy'),
  Option('money', 'Money'),
  Option('weather', 'Weather'),
  Option('motivation', 'Motivation'),
];

const motivationOptions = [
  Option('more_energy', 'More energy'),
  Option('less_stress', 'Less stress'),
  Option('sleep_better', 'Sleep better'),
  Option('time_with_people', 'Time with people'),
  Option('feel_stronger', 'Feel stronger'),
  Option('be_there_for_family', 'Be there for family'),
  Option('just_for_fun', 'Just for fun'),
  Option(motivationPreferNotToSay, 'Prefer not to say'),
];

/// What to leave out. "Nothing to leave out" is a button of its own on the screen, not a stored value. The
/// swimming entry is an activity kind; the rest are library tags (docs/data-model.md §7, frame 1.14).
const leaveOutOptions = [
  Option('after_dark', 'Outdoors after dark'),
  Option('team_sport', 'Team sports'),
  Option('high_impact', 'High impact'),
  Option('swimming', 'Swimming'),
];

String labelOf<T>(List<Option<T>> options, T value) {
  for (final o in options) {
    if (o.value == value) return o.label;
  }
  return value.toString();
}

/// The name shown for an activity the person picked: the typed name for "other", else the catalogue label.
String activityLabel(ActivityKind? kind, String? customName) {
  if (kind == null) return '';
  if (kind == ActivityKind.other) return (customName == null || customName.isEmpty) ? 'Other' : customName;
  return catalogueEntry(kind)?.label ?? kind.code;
}

/// The one-line summary under the section label once earlier answers are folded away, such as
/// "Gym · up and down" (frames 1.8 to 1.11). Null when the step has nothing earlier to summarise.
String? summaryFor(SetupStep step, SetupAnswers a) {
  switch (step) {
    case SetupStep.keepProgress:
      final name = activityLabel(a.keepActivity, a.keepCustomName);
      return name.isEmpty ? null : name;
    case SetupStep.pickUpStopped:
      return _join([activityLabel(a.pickUpActivity, a.pickUpCustomName)]);
    case SetupStep.pickUpGotInWay:
    case SetupStep.pickUpHelp:
      final parts = [
        activityLabel(a.pickUpActivity, a.pickUpCustomName),
        if (a.stoppedAgo != null) labelOf(stoppedOptions, a.stoppedAgo!).toLowerCase(),
        if (step == SetupStep.pickUpHelp && a.gotInTheWay.isNotEmpty)
          labelOf(gotInTheWayOptions, a.gotInTheWay.first).toLowerCase(),
      ];
      return _join(parts);
    default:
      return null;
  }
}

String? _join(List<String> parts) {
  final kept = parts.where((p) => p.isNotEmpty).toList();
  return kept.isEmpty ? null : kept.join(' · ');
}

/// The question text for each step. Titles use the person's own activity name where the frame does.
String titleFor(SetupStep step, SetupAnswers a) => switch (step) {
      SetupStep.brings => 'What brings you here?',
      SetupStep.keepActivity => 'What do you do now?',
      SetupStep.keepProgress => 'How’s the ${activityLabel(a.keepActivity, a.keepCustomName).toLowerCase()} going?',
      SetupStep.addNew => 'What do you do now?',
      SetupStep.pickUpWhich => 'What would you like to pick up again?',
      SetupStep.pickUpStopped => 'When did you stop, roughly?',
      SetupStep.pickUpGotInWay => 'What got in the way?',
      SetupStep.pickUpHelp => 'What would make it easier now?',
      SetupStep.startFresh => 'What sounds good to try?',
      SetupStep.week => 'When could you fit it in?',
      SetupStep.why => 'Why does being active matter to you?',
      SetupStep.leaveOut => 'Anything to leave out?',
    };

String? helperFor(SetupStep step, SetupAnswers a) => switch (step) {
      SetupStep.brings => 'Tick all that fit. You can have more than one activity.',
      SetupStep.keepActivity => 'Pick one. You can add more later.',
      SetupStep.keepProgress || SetupStep.pickUpStopped => 'Pick one.',
      SetupStep.addNew || SetupStep.pickUpWhich || SetupStep.startFresh => 'Pick one.',
      SetupStep.pickUpGotInWay => 'Pick any. There’s no wrong answer.',
      SetupStep.why => 'Pick up to $maxMotivations · ${a.motivations.where((m) => m != motivationPreferNotToSay).length} of $maxMotivations picked',
      SetupStep.leaveOut => 'We won’t suggest these. Change it anytime in Settings.',
      _ => null,
    };
