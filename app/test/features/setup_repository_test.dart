import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/data/database.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/features/starting_point/setup_model.dart';
import 'package:lilt/features/starting_point/setup_repository.dart';

/// What the wizard stores, and that it stores nothing until "Show me today" (BR-014).
void main() {
  late LiltDatabase db;
  late DriftSetupRepository repo;

  setUp(() {
    db = LiltDatabase(NativeDatabase.memory());
    repo = DriftSetupRepository(db);
  });
  tearDown(() => db.close());

  Future<List<FollowedActivity>> followed() => (db.select(db.followedActivities)..orderBy([(t) => OrderingTerm(expression: t.path)])).get();
  Future<Set<String>> prefs(PrefKind kind) async =>
      {for (final p in await (db.select(db.preferences)..where((t) => t.kind.equalsValue(kind))).get()) p.value};

  test('nothing is stored before save, and setup is not done', () async {
    expect(await repo.isDone(), isFalse);
    expect(await db.select(db.followedActivities).get(), isEmpty);
    expect(await db.select(db.preferences).get(), isEmpty);
    expect(await db.select(db.profiles).get(), isEmpty);
  });

  test('keep going: the activity, how it is going, and what makes it harder (only when asked)', () async {
    await repo.save(const SetupAnswers(
      paths: {SetupPath.keepGoing},
      keepActivity: ActivityKind.gym,
      progress: Progress.upAndDown,
      hardBecause: {'finding_time', 'cost'},
      freeTimes: {'lunch'},
    ));
    final row = (await followed()).single;
    expect(row.activity, ActivityKind.gym);
    expect(row.path, SetupPath.keepGoing);
    expect(row.progress, Progress.upAndDown);
    expect(row.hardBecause, 'cost,finding_time');
    expect(await repo.isDone(), isTrue);
  });

  test('"what makes it harder" is dropped when going well', () async {
    await repo.save(const SetupAnswers(
      paths: {SetupPath.keepGoing},
      keepActivity: ActivityKind.running,
      progress: Progress.goingWell,
      hardBecause: {'energy'},
      freeTimes: {'lunch'},
    ));
    expect((await followed()).single.hardBecause, isNull);
  });

  test('pick up again: when it stopped, what got in the way, what would help', () async {
    await repo.save(const SetupAnswers(
      paths: {SetupPath.pickUpAgain},
      pickUpActivity: ActivityKind.running,
      stoppedAgo: StoppedAgo.months,
      gotInTheWay: {'busier'},
      wouldHelp: {'shorter_sessions', 'different_time'},
      freeTimes: {'weekends'},
    ));
    final row = (await followed()).single;
    expect(row.path, SetupPath.pickUpAgain);
    expect(row.stoppedAgo, StoppedAgo.months);
    expect(row.gotInTheWay, 'busier');
    expect(row.wouldHelp, 'different_time,shorter_sessions');
  });

  test('skipped follow-ups store null, not an empty string', () async {
    await repo.save(const SetupAnswers(
      paths: {SetupPath.pickUpAgain},
      pickUpActivity: ActivityKind.yoga,
      stoppedAgo: StoppedAgo.weeks,
      freeTimes: {'lunch'},
    ));
    final row = (await followed()).single;
    expect(row.gotInTheWay, isNull);
    expect(row.wouldHelp, isNull);
  });

  test('a typed activity is stored as other with its name', () async {
    await repo.save(const SetupAnswers(
      paths: {SetupPath.keepGoing},
      keepActivity: ActivityKind.other,
      keepCustomName: '  Padel ',
      progress: Progress.goingWell,
      freeTimes: {'lunch'},
    ));
    final row = (await followed()).single;
    expect(row.activity, ActivityKind.other);
    expect(row.customName, 'Padel');
  });

  test('add something new keeps the activity they already do, once', () async {
    await repo.save(const SetupAnswers(
      paths: {SetupPath.keepGoing, SetupPath.addNew},
      keepActivity: ActivityKind.running,
      progress: Progress.goingWell,
      addNewActivity: ActivityKind.running,
      freeTimes: {'lunch'},
    ));
    expect(await followed(), hasLength(1));
  });

  test('add something new with a different activity keeps both', () async {
    await repo.save(const SetupAnswers(
      paths: {SetupPath.keepGoing, SetupPath.addNew},
      keepActivity: ActivityKind.running,
      progress: Progress.goingWell,
      addNewActivity: ActivityKind.walking,
      freeTimes: {'lunch'},
    ));
    expect((await followed()).map((r) => r.activity).toSet(), {ActivityKind.running, ActivityKind.walking});
  });

  test('start fresh with a real activity stores it with the start_fresh path (frame 9.13)', () async {
    await repo.save(const SetupAnswers(
      paths: {SetupPath.startFresh},
      freshChoice: ActivityKind.swimming,
      freeTimes: {'lunch'},
    ));
    final row = (await followed()).single;
    expect(row.activity, ActivityKind.swimming);
    expect(row.path, SetupPath.startFresh);
  });

  test('start fresh stores the one choice, including "not sure yet"', () async {
    await repo.save(const SetupAnswers(
      paths: {SetupPath.startFresh},
      freshChoice: ActivityKind.notSure,
      freeTimes: {'lunch'},
    ));
    final row = (await followed()).single;
    expect(row.activity, ActivityKind.notSure);
    expect(row.path, SetupPath.startFresh);
  });

  test('preferences: free times, access, barriers, motivations and leave-outs', () async {
    await repo.save(const SetupAnswers(
      paths: {SetupPath.startFresh},
      freshChoice: ActivityKind.dance,
      freeTimes: {'lunch', 'weekends'},
      access: {'pool', 'courts_or_park'},
      barriers: {'time', 'weather'},
      motivations: {'more_energy', 'less_stress'},
      excluded: {'after_dark', 'swimming'},
    ));
    expect(await prefs(PrefKind.freeTime), {'lunch', 'weekends'});
    expect(await prefs(PrefKind.access), {'pool', 'courts_or_park'});
    expect(await prefs(PrefKind.usualBarrier), {'time', 'weather'});
    expect(await prefs(PrefKind.motivation), {'more_energy', 'less_stress'});
    expect(await prefs(PrefKind.excluded), {'after_dark', 'swimming'});
  });

  test('"nothing to leave out" and "none of these" are stored as what they are', () async {
    await repo.save(const SetupAnswers(
      paths: {SetupPath.startFresh},
      freshChoice: ActivityKind.dance,
      freeTimes: {'lunch'},
      access: {accessNone},
    ));
    expect(await prefs(PrefKind.excluded), isEmpty);
    expect(await prefs(PrefKind.access), {'none'});
  });

  test('more than 3 motivations are cut to 3 and never reach the database trigger', () async {
    await repo.save(const SetupAnswers(
      paths: {SetupPath.startFresh},
      freshChoice: ActivityKind.dance,
      freeTimes: {'lunch'},
      motivations: {'a', 'b', 'c', 'd'},
    ));
    expect(await prefs(PrefKind.motivation), hasLength(3));
  });

  test('setup can only be saved once: a later save cannot wipe followed activities and preferences', () async {
    const first = SetupAnswers(
      paths: {SetupPath.startFresh},
      freshChoice: ActivityKind.dance,
      freeTimes: {'lunch'},
    );
    await repo.save(first);
    await expectLater(
      repo.save(first.copyWith(freshChoice: ActivityKind.teamSports, freeTimes: {'weekends'})),
      throwsStateError,
    );
    expect((await followed()).single.activity, ActivityKind.dance);
    expect(await prefs(PrefKind.freeTime), {'lunch'});
    expect(await db.select(db.profiles).get(), hasLength(1));
  });

  test('a typed name is compared without regard to case when removing a duplicate', () async {
    await repo.save(const SetupAnswers(
      paths: {SetupPath.keepGoing, SetupPath.addNew},
      keepActivity: ActivityKind.other,
      keepCustomName: 'Padel',
      progress: Progress.goingWell,
      addNewActivity: ActivityKind.other,
      addNewCustomName: 'padel',
      freeTimes: {'lunch'},
    ));
    expect(await followed(), hasLength(1));
  });

  test('a failure part way through stores nothing', () async {
    // A motivation row that breaks the unique key rolls the whole save back.
    final broken = const SetupAnswers(
      paths: {SetupPath.startFresh},
      freshChoice: ActivityKind.dance,
      freeTimes: {'lunch'},
    );
    await db.customStatement('CREATE TRIGGER fail_prefs BEFORE INSERT ON preference BEGIN SELECT RAISE(ABORT, "no"); END');
    await expectLater(repo.save(broken), throwsA(anything));
    expect(await db.select(db.followedActivities).get(), isEmpty);
    expect(await repo.isDone(), isFalse);
  });
}
