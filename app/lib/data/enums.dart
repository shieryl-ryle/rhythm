import 'package:drift/drift.dart';

/// Enums from docs/data-model.md §3. They are stored as their snake_case `code` (text), never as the Dart
/// name. Never rename or remove a live code: add new values, and keep a retired value readable.
abstract interface class Coded {
  String get code;
}

/// Stores a [Coded] enum as its code, and serialises it to JSON the same way.
class CodedEnumConverter<T extends Enum> extends TypeConverter<T, String>
    with JsonTypeConverter2<T, String, String> {
  const CodedEnumConverter(this.values);

  final List<T> values;

  @override
  T fromSql(String fromDb) => values.firstWhere(
        (v) => (v as Coded).code == fromDb,
        orElse: () => throw StateError('Unknown ${T.toString()} code "$fromDb"'),
      );

  @override
  String toSql(T value) => (value as Coded).code;

  @override
  T fromJson(String json) => fromSql(json);

  @override
  String toJson(T value) => toSql(value);
}

enum ActivityKind implements Coded {
  walking('walking'),
  running('running'),
  gym('gym'),
  cycling('cycling'),
  swimming('swimming'),
  basketball('basketball'),
  racketSports('racket_sports'),
  teamSports('team_sports'),
  pickleball('pickleball'),
  yoga('yoga'),
  dance('dance'),
  hiking('hiking'),
  bouldering('bouldering'),
  pilates('pilates'),
  other('other'),
  notSure('not_sure');

  const ActivityKind(this.code);
  @override
  final String code;
}

enum SetupPath implements Coded {
  keepGoing('keep_going'),
  pickUpAgain('pick_up_again'),
  addNew('add_new'),
  startFresh('start_fresh');

  const SetupPath(this.code);
  @override
  final String code;
}

enum Progress implements Coded {
  goingWell('going_well'),
  upAndDown('up_and_down'),
  gettingHarder('getting_harder');

  const Progress(this.code);
  @override
  final String code;
}

enum StoppedAgo implements Coded {
  weeks('weeks'),
  months('months'),
  yearPlus('year_plus');

  const StoppedAgo(this.code);
  @override
  final String code;
}

enum Familiarity implements Coded {
  alreadyPlay('already_play'),
  usedToPlay('used_to_play'),
  newToMe('new_to_me');

  const Familiarity(this.code);
  @override
  final String code;
}

enum PrefKind implements Coded {
  freeTime('free_time'),
  access('access'),
  usualBarrier('usual_barrier'),
  motivation('motivation'),
  excluded('excluded'),
  constraint('constraint'),
  preference('preference');

  const PrefKind(this.code);
  @override
  final String code;
}

enum Intensity implements Coded {
  veryLow('very_low'),
  low('low'),
  moderate('moderate');

  const Intensity(this.code);
  @override
  final String code;
}

enum Energy implements Coded {
  low('low'),
  medium('medium'),
  high('high');

  const Energy(this.code);
  @override
  final String code;
}

enum OfferStatus implements Coded {
  offered('offered'),
  accepted('accepted'),
  edited('edited'),
  replaced('replaced'),
  declined('declined');

  const OfferStatus(this.code);
  @override
  final String code;
}

enum PlanSource implements Coded {
  offer('offer'),
  custom('custom'),
  togetherEvent('together_event');

  const PlanSource(this.code);
  @override
  final String code;
}

enum WithWhom implements Coded {
  solo('solo'),
  friends('friends'),
  event('event');

  const WithWhom(this.code);
  @override
  final String code;
}

enum ReflectionStatus implements Coded {
  completed('completed'),
  partly('partly'),
  skipped('skipped'),
  unknown('unknown');

  const ReflectionStatus(this.code);
  @override
  final String code;
}

enum Barrier implements Coded {
  time('time'),
  lowEnergy('low_energy'),
  schedule('schedule'),
  weather('weather'),
  other('other'),
  preferNotToSay('prefer_not_to_say');

  const Barrier(this.code);
  @override
  final String code;
}

enum PauseKind implements Coded {
  pause('pause'),
  lighter('lighter'),
  reschedule('reschedule');

  const PauseKind(this.code);
  @override
  final String code;
}

enum ObsSource implements Coded {
  rule('rule'),
  aiDraft('ai_draft'),
  user('user');

  const ObsSource(this.code);
  @override
  final String code;
}

enum ObsStatus implements Coded {
  proposed('proposed'),
  confirmed('confirmed'),
  deleted('deleted');

  const ObsStatus(this.code);
  @override
  final String code;
}

enum ReturnApproach implements Coded {
  previous('previous'),
  different('different'),
  starter('starter');

  const ReturnApproach(this.code);
  @override
  final String code;
}
