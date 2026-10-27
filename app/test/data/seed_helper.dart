import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:lilt/data/consent_repository.dart';
import 'package:lilt/data/database.dart';
import 'package:lilt/data/enums.dart';

/// Inserts one row into every table (the library included), with fixed ids so tests can refer to them.
Future<void> seedEverything(LiltDatabase db) async {
  await db.into(db.consentRecords).insert(
        ConsentRecordsCompanion.insert(
          consentVersion: currentConsentVersion,
          acceptedAt: DateTime.utc(2026, 10, 27, 8),
        ),
      );
  await db.into(db.profiles).insert(ProfilesCompanion.insert(setupDoneAt: Value(DateTime.utc(2026, 10, 27, 8, 5))));
  // The library may already be loaded; keep the existing row if so.
  await db.into(db.actions).insert(
        mode: InsertMode.insertOrIgnore,
        ActionsCompanion.insert(
          id: 'act_run_walk_20',
          activity: ActivityKind.running,
          title: 'Run-walk around the park',
          description: 'Alternate running and walking.',
          durationMin: 20,
          intensity: Intensity.low,
          energyNeeded: Energy.medium,
          tags: const Value('outdoors,free'),
          libraryVersion: 'test-1',
        ),
      );
  await db.into(db.followedActivities).insert(
        FollowedActivitiesCompanion.insert(
          id: const Value('fol_test'),
          activity: ActivityKind.running,
          path: SetupPath.pickUpAgain,
          stoppedAgo: const Value(StoppedAgo.months),
          gotInTheWay: const Value('busier,just_drifted'),
          wouldHelp: const Value('shorter_sessions'),
        ),
      );
  await db.into(db.preferences).insert(
        PreferencesCompanion.insert(id: const Value('pref_test'), kind: PrefKind.freeTime, value: 'lunch'),
      );
  await db.into(db.optionOffers).insert(
        OptionOffersCompanion.insert(
          id: const Value('off_test'),
          day: '2026-10-27',
          actionId: 'act_run_walk_20',
          followedActivityId: const Value('fol_test'),
          suggestedDay: '2026-10-27',
          suggestedTime: const Value('12:30'),
          status: const Value(OfferStatus.accepted),
          timeInputMin: const Value(20),
          energyInput: const Value(Energy.medium),
        ),
      );
  await db.into(db.offerReasons).insert(
        OfferReasonsCompanion.insert(
          offerId: 'off_test',
          rank: 1,
          reasonCode: 'help',
          reasonText: 'You said shorter sessions would help.',
        ),
      );
  await db.into(db.planItems).insert(
        PlanItemsCompanion.insert(
          id: const Value('plan_test'),
          source: PlanSource.offer,
          offerId: const Value('off_test'),
          actionId: const Value('act_run_walk_20'),
          activity: ActivityKind.running,
          title: 'Run-walk around the park',
          plannedDay: '2026-10-27',
          plannedTime: const Value('12:30'),
          durationMin: const Value(20),
        ),
      );
  await db.into(db.reflections).insert(
        ReflectionsCompanion.insert(
          id: const Value('ref_test'),
          planItemId: 'plan_test',
          status: const Value(ReflectionStatus.partly),
          enjoyment: const Value(2),
          barrier: const Value(Barrier.lowEnergy),
        ),
      );
  await db.into(db.pauses).insert(PausesCompanion.insert(kind: PauseKind.pause, startDay: '2026-10-28'));
  await db.into(db.observations).insert(
        ObservationsCompanion.insert(
          text_: 'Lunch runs seem to work for you.',
          source: ObsSource.rule,
          patternKey: 'time:lunch:enjoyed',
        ),
      );
  await db.into(db.savedActions).insert(SavedActionsCompanion.insert(actionId: 'act_run_walk_20'));
  await db.into(db.returnEvents).insert(
        ReturnEventsCompanion.insert(
          lapseStartDay: '2026-10-01',
          returnDay: '2026-10-20',
          whatChanged: const Value('busier'),
          approach: const Value(ReturnApproach.previous),
        ),
      );
  await db.into(db.achievementsEarned).insert(
        AchievementsEarnedCompanion.insert(code: 'back_at_it', earnedDay: '2026-10-20'),
      );
  await db.into(db.notificationSettings).insert(NotificationSettingsCompanion.insert());
}

/// Row counts for every user table by table name (the library table `action` is not included).
Future<Map<String, int>> userRowCounts(LiltDatabase db) async {
  final counts = <String, int>{};
  for (final table in db.userTables) {
    final name = table.actualTableName;
    final row = await db.customSelect('SELECT COUNT(*) AS n FROM "$name"', readsFrom: {table}).getSingle();
    counts[name] = row.read<int>('n');
  }
  return counts;
}
