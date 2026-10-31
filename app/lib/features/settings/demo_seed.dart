import 'package:drift/drift.dart';

import '../../data/consent_repository.dart';
import '../../data/database.dart';
import '../../data/enums.dart';
import '../../data/my_data.dart';
import '../../domain/day.dart';
import '../../domain/observation.dart';
import '../starting_point/setup_model.dart';
import '../starting_point/setup_repository.dart';

/// Demo builds only (`--dart-define=DEMO=true`): Settings shows "Load demo data: Rana" or "Sam". A build without it
/// never shows it and never loads anything (seed/README.md).
const demoBuild = bool.fromEnvironment('DEMO');

/// The invented people the demo can load. Nothing here is a real person or real participant data.
enum DemoPersona {
  rana('Rana', 'Moved house, walked for three weeks, a short break, then back'),
  sam('Sam', 'Starting gentle stretching, a few partly done days');

  const DemoPersona(this.label, this.story);
  final String label;
  final String story;
}

/// Every demo row has an id that starts with this, so the app can tell demo data from a real person's and
/// label it as synthetic.
const demoIdPrefix = 'demo_';

/// Loads one persona, relative to the day it is loaded, so "two days ago" stays two days ago and the lapse
/// and return are always recent. Same persona and same day give the same rows (no randomness).
///
/// It starts with the delete-all path, so loading again resets cleanly and nothing mixes with real data
/// (BR-017). It records consent, because a demo is a person who has agreed.
class DemoSeed {
  DemoSeed(this._db, this._myData);

  final LiltDatabase _db;
  final MyDataService _myData;

  Future<void> load(DemoPersona persona, {required DateTime now}) async {
    final today = formatDay(DateTime.utc(now.year, now.month, now.day));
    await _myData.deleteAll();
    await _db.transaction(() async {
      await _db.into(_db.consentRecords).insert(
            ConsentRecordsCompanion.insert(consentVersion: currentConsentVersion, acceptedAt: now.toUtc()),
          );
      await DriftSetupRepository(_db).save(_answers(persona));
      // The followed activity gets a recognisable id so the demo can be labelled.
      await _db.customStatement("UPDATE followed_activity SET id = '$demoIdPrefix' || id");

      switch (persona) {
        case DemoPersona.rana:
          await _rana(today, now);
        case DemoPersona.sam:
          await _sam(today);
      }
    });
  }

  SetupAnswers _answers(DemoPersona p) => switch (p) {
        DemoPersona.rana => const SetupAnswers(
            paths: {SetupPath.keepGoing},
            keepActivity: ActivityKind.walking,
            progress: Progress.upAndDown,
            freeTimes: {'lunch', 'weekends'},
            access: {'none'},
            barriers: {'time'},
            motivations: {'time_with_people'},
            wouldHelp: {'someone_to_go_with'},
          ),
        DemoPersona.sam => const SetupAnswers(
            paths: {SetupPath.startFresh},
            freshChoice: ActivityKind.yoga,
            freeTimes: {'after_work'},
            access: {'none'},
            barriers: {'energy'},
            excluded: {'team_sport'},
          ),
      };

  int _n = 0;

  /// One planned and reflected day. [back] is how many days before today.
  Future<void> _day(
    String today,
    int back, {
    required String actionId,
    required ActivityKind activity,
    required String title,
    required int minutes,
    required ReflectionStatus status,
    String time = '12:30',
    WithWhom with_ = WithWhom.solo,
    int? enjoyment,
    Barrier? barrier,
  }) async {
    final planId = '${demoIdPrefix}plan_${(_n++).toString().padLeft(3, '0')}';
    await _db.into(_db.planItems).insert(
          PlanItemsCompanion.insert(
            id: Value(planId),
            source: PlanSource.offer,
            actionId: Value(actionId),
            activity: activity,
            title: title,
            plannedDay: addDays(today, -back),
            plannedTime: Value(time),
            durationMin: Value(minutes),
            withWhom: Value(with_),
          ),
        );
    await _db.into(_db.reflections).insert(
          ReflectionsCompanion.insert(
            id: Value('${demoIdPrefix}ref_${_n.toString().padLeft(3, '0')}'),
            planItemId: planId,
            status: Value(status),
            enjoyment: Value(status == ReflectionStatus.skipped ? null : enjoyment),
            barrier: Value(status == ReflectionStatus.completed ? null : barrier),
          ),
        );
  }

  /// Rana: walks about five days in seven for three weeks, three days paused in a busy week, a six-day lapse,
  /// and back two days ago through My Way Back (what changed: moved; a different approach). Four walks with
  /// company were enjoyed, so one observation is confirmed and one is proposed. Some days were never answered
  /// (BR-009).
  Future<void> _rana(String today, DateTime now) async {
    // Earlier weeks: now and then, never three open days in a row (that would be a lapse of its own).
    const mix = [
      ReflectionStatus.completed,
      ReflectionStatus.partly,
      ReflectionStatus.completed,
      ReflectionStatus.skipped,
      ReflectionStatus.completed,
    ];
    const earlier = {
      44: ReflectionStatus.completed,
      41: ReflectionStatus.partly,
      38: ReflectionStatus.completed,
      35: ReflectionStatus.completed,
      32: ReflectionStatus.partly,
    };
    for (final e in earlier.entries) {
      await _day(today, e.key,
          actionId: 'act_walk_10',
          activity: ActivityKind.walking,
          title: 'A ten-minute easy walk',
          minutes: 10,
          status: e.value,
          enjoyment: e.value == ReflectionStatus.completed ? 2 : null,
          barrier: e.value == ReflectionStatus.partly ? Barrier.lowEnergy : null);
    }
    // One planned walk the person did not get to, between two that they did.
    await _day(today, 40,
        actionId: 'act_walk_10',
        activity: ActivityKind.walking,
        title: 'A ten-minute easy walk',
        minutes: 10,
        status: ReflectionStatus.skipped,
        barrier: Barrier.weather);

    // The regular three weeks (30 to 9 days ago), five days in seven. The pause covers 20 to 18.
    const withCompany = {27, 23, 14, 11};
    for (var back = 30; back >= 9; back--) {
      if (back <= 20 && back >= 18) continue;
      if (back % 7 == 3 || back % 7 == 5) continue; // two days in seven are left open
      if (withCompany.contains(back)) {
        await _day(today, back,
            actionId: 'act_walk_friend_20',
            activity: ActivityKind.walking,
            title: 'Walk and talk with a friend',
            minutes: 20,
            status: ReflectionStatus.completed,
            time: '18:00',
            with_: WithWhom.friends,
            enjoyment: 3);
        continue;
      }
      final s = mix[back % mix.length];
      if (back == 16) {
        // Planned, and never answered: unknown is not skipped (BR-009).
        await _day(today, back,
            actionId: 'act_walk_lunch',
            activity: ActivityKind.walking,
            title: 'A lunchtime walk',
            minutes: 15,
            status: ReflectionStatus.unknown);
        continue;
      }
      await _day(today, back,
          actionId: 'act_walk_lunch',
          activity: ActivityKind.walking,
          title: 'A lunchtime walk',
          minutes: 15,
          status: s,
          enjoyment: s == ReflectionStatus.completed ? (back % 2 == 0 ? 3 : 2) : null,
          barrier: s == ReflectionStatus.skipped
              ? Barrier.weather
              : s == ReflectionStatus.partly
                  ? Barrier.lowEnergy
                  : null);
    }

    // The busy week: a three-day pause. `end_day` is the first active day again.
    await _db.into(_db.pauses).insert(
          PausesCompanion.insert(
            id: Value('${demoIdPrefix}pause_1'),
            kind: PauseKind.pause,
            startDay: addDays(today, -20),
            endDay: Value(addDays(today, -17)),
          ),
        );

    // 8 to 3 days ago: nothing planned. Back 2 and 1 days ago, small.
    await _day(today, 2,
        actionId: 'act_walk_10',
        activity: ActivityKind.walking,
        title: 'A ten-minute easy walk',
        minutes: 10,
        status: ReflectionStatus.completed);
    await _day(today, 1,
        actionId: 'act_walk_10',
        activity: ActivityKind.walking,
        title: 'A ten-minute easy walk',
        minutes: 10,
        status: ReflectionStatus.partly,
        barrier: Barrier.lowEnergy,
        enjoyment: 2);

    await _db.into(_db.returnEvents).insert(
          ReturnEventsCompanion.insert(
            id: Value('${demoIdPrefix}ret_1'),
            lapseStartDay: addDays(today, -8),
            returnDay: addDays(today, -2),
            whatChanged: const Value('moved'),
            approach: const Value(ReturnApproach.different),
          ),
        );

    const confirmed = 'tag:with_company:enjoyed';
    const proposed = 'time:lunch:enjoyed';
    await _db.into(_db.observations).insert(
          ObservationsCompanion.insert(
            id: Value('${demoIdPrefix}obs_1'),
            text_: observationText(confirmed)!,
            source: ObsSource.rule,
            status: const Value(ObsStatus.confirmed),
            patternKey: confirmed,
            confirmedAt: Value(now.toUtc()),
          ),
        );
    await _db.into(_db.observations).insert(
          ObservationsCompanion.insert(
            id: Value('${demoIdPrefix}obs_2'),
            text_: observationText(proposed)!,
            source: ObsSource.rule,
            patternKey: proposed,
          ),
        );
  }

  /// Sam: two weeks of ten-minute stretching, mostly partly done, two days skipped for low energy, one never
  /// answered, two quiet days. Team sports are left out (BR-011). Never three open days in a row.
  Future<void> _sam(String today) async {
    const days = {
      13: ReflectionStatus.partly,
      12: ReflectionStatus.completed,
      11: ReflectionStatus.partly,
      9: ReflectionStatus.partly,
      8: ReflectionStatus.skipped,
      7: ReflectionStatus.unknown,
      6: ReflectionStatus.partly,
      4: ReflectionStatus.partly,
      3: ReflectionStatus.completed,
      2: ReflectionStatus.skipped,
      1: ReflectionStatus.partly,
    };
    for (final e in days.entries) {
      final s = e.value;
      await _day(today, e.key,
          actionId: 'act_yoga_stretch_10',
          activity: ActivityKind.yoga,
          title: 'Ten minutes of gentle stretching',
          minutes: 10,
          status: s,
          time: '18:00',
          enjoyment: s == ReflectionStatus.partly ? 2 : null,
          barrier: s == ReflectionStatus.skipped
              ? Barrier.lowEnergy
              : s == ReflectionStatus.partly
                  ? Barrier.time
                  : null);
    }
  }
}
