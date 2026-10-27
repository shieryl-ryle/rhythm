import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/data/database.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/data/my_data.dart';

import 'seed_helper.dart';

/// The schema matches docs/data-model.md v0.2: tables, constraints, enum codes and the v1 to v2 migration.
void main() {
  late LiltDatabase db;

  setUp(() => db = LiltDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<List<String>> tableNames() async {
    final rows = await db
        .customSelect("SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%'")
        .get();
    return rows.map((r) => r.read<String>('name')).toList();
  }

  test('every table in the data model exists', () async {
    final names = await tableNames();
    expect(names, containsAll([...MyDataService.deleteOrder, 'action']));
    expect(names.length, MyDataService.deleteOrder.length + 1);
  });

  test('the delete order lists exactly the user tables', () {
    final userTables = db.userTables.map((t) => t.actualTableName).toSet();
    expect(userTables, MyDataService.deleteOrder.toSet());
    expect(userTables, isNot(contains('action')));
  });

  test('enums are stored as snake_case codes, not Dart names', () async {
    await seedEverything(db);
    Future<Object?> one(String sql) async => (await db.customSelect(sql).getSingle()).data.values.first;

    expect(await one('SELECT path FROM followed_activity'), 'pick_up_again');
    expect(await one('SELECT stopped_ago FROM followed_activity'), 'months');
    expect(await one('SELECT barrier FROM reflection'), 'low_energy');
    expect(await one('SELECT kind FROM preference'), 'free_time');
    expect(await one('SELECT status FROM option_offer'), 'accepted');
    expect(await one('SELECT source FROM plan_item'), 'offer');
  });

  test('dates are stored as UTC ISO-8601 text', () async {
    await seedEverything(db);
    final accepted =
        (await db.customSelect('SELECT accepted_at FROM consent').getSingle()).read<String>('accepted_at');
    expect(accepted, '2026-10-27T08:00:00.000Z');
  });

  test('a preference is unique by kind and value', () async {
    await db.into(db.preferences).insert(PreferencesCompanion.insert(kind: PrefKind.freeTime, value: 'lunch'));
    expect(
      () => db.into(db.preferences).insert(PreferencesCompanion.insert(kind: PrefKind.freeTime, value: 'lunch')),
      throwsA(isA<Exception>()),
    );
    // The same value under another kind is fine.
    await db.into(db.preferences).insert(PreferencesCompanion.insert(kind: PrefKind.excluded, value: 'lunch'));
  });

  test('a plan item has at most one reflection, and deleting the plan item deletes it', () async {
    await seedEverything(db);
    expect(
      () => db.into(db.reflections).insert(ReflectionsCompanion.insert(planItemId: 'plan_test')),
      throwsA(isA<Exception>()),
    );

    await (db.delete(db.planItems)..where((t) => t.id.equals('plan_test'))).go();
    expect(await db.select(db.reflections).get(), isEmpty);
  });

  test('a reflection is created as unknown and enjoyment must be 1 to 3', () async {
    await seedEverything(db);
    await db.into(db.planItems).insert(
          PlanItemsCompanion.insert(
            id: const Value('plan_two'),
            source: PlanSource.custom,
            activity: ActivityKind.gym,
            title: 'Gym',
            plannedDay: '2026-10-28',
          ),
        );
    await db.into(db.reflections).insert(ReflectionsCompanion.insert(planItemId: 'plan_two'));
    final created = await (db.select(db.reflections)..where((t) => t.planItemId.equals('plan_two'))).getSingle();
    expect(created.status, ReflectionStatus.unknown);
    expect(created.enjoyment, isNull);

    expect(
      () => (db.update(db.reflections)..where((t) => t.planItemId.equals('plan_two')))
          .write(const ReflectionsCompanion(enjoyment: Value(4))),
      throwsA(isA<Exception>()),
    );
  });

  test('foreign keys are enforced: an offer needs a real library action, and a used action cannot be deleted',
      () async {
    expect(
      () => db.into(db.optionOffers).insert(
            OptionOffersCompanion.insert(day: '2026-10-27', actionId: 'act_missing', suggestedDay: '2026-10-27'),
          ),
      throwsA(isA<Exception>()),
    );

    await seedEverything(db);
    expect(
      () => (db.delete(db.actions)..where((t) => t.id.equals('act_run_walk_20'))).go(),
      throwsA(isA<Exception>()),
    );
  });

  test('deleting an offer deletes its reasons and leaves the plan item', () async {
    await seedEverything(db);
    await (db.delete(db.optionOffers)..where((t) => t.id.equals('off_test'))).go();

    expect(await db.select(db.offerReasons).get(), isEmpty);
    final plan = await db.select(db.planItems).getSingle();
    expect(plan.offerId, isNull);
  });

  test('at most 3 motivations can be stored', () async {
    for (final value in ['more_energy', 'less_stress', 'sleep_better']) {
      await db.into(db.preferences).insert(PreferencesCompanion.insert(kind: PrefKind.motivation, value: value));
    }
    expect(
      () => db.into(db.preferences).insert(
            PreferencesCompanion.insert(kind: PrefKind.motivation, value: 'feel_stronger'),
          ),
      throwsA(isA<Exception>()),
    );
    // The limit is per kind: other kinds are not affected.
    await db.into(db.preferences).insert(PreferencesCompanion.insert(kind: PrefKind.freeTime, value: 'lunch'));
  });

  test('a day has one offer per swap position, also for suggestions with no followed activity', () async {
    await seedEverything(db);
    Future<void> offer(String id, int swap) => db.into(db.optionOffers).insert(
          OptionOffersCompanion.insert(
            id: Value(id),
            day: '2026-10-28',
            actionId: 'act_run_walk_20',
            suggestedDay: '2026-10-28',
            swapIndex: Value(swap),
          ),
        );
    await offer('off_new_1', 1);
    await offer('off_new_2', 2);
    expect(() => offer('off_new_dup', 1), throwsA(isA<Exception>()));
  });

  test('an offer has at most one plan item', () async {
    await seedEverything(db);
    expect(
      () => db.into(db.planItems).insert(
            PlanItemsCompanion.insert(
              source: PlanSource.offer,
              offerId: const Value('off_test'),
              activity: ActivityKind.running,
              title: 'Again',
              plannedDay: '2026-10-27',
            ),
          ),
      throwsA(isA<Exception>()),
    );
  });

  test('the profile and notification settings are single rows with the id me', () async {
    await db.into(db.profiles).insert(ProfilesCompanion.insert());
    await db.into(db.notificationSettings).insert(NotificationSettingsCompanion.insert());
    expect(
      () => db.into(db.profiles).insert(ProfilesCompanion.insert(id: const Value('other'))),
      throwsA(isA<Exception>()),
    );
    expect(
      () => db.into(db.notificationSettings).insert(NotificationSettingsCompanion.insert(id: const Value('other'))),
      throwsA(isA<Exception>()),
    );
  });

  test('upgrading a version 1 database keeps the consent and converts its date', () async {
    // This test deliberately opens a second database next to the one from setUp.
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final old = NativeDatabase.memory(
      setup: (raw) {
        raw.execute(
          'CREATE TABLE consent (id INTEGER PRIMARY KEY AUTOINCREMENT, consent_version TEXT NOT NULL, '
          'accepted_at INTEGER NOT NULL)',
        );
        // 2026-10-27T08:00:00Z as unix seconds, the way the skeleton stored it.
        raw.execute("INSERT INTO consent (consent_version, accepted_at) VALUES ('2026-10-27.1', 1793088000)");
        raw.execute('PRAGMA user_version = 1');
      },
    );
    final upgraded = LiltDatabase(old);
    addTearDown(upgraded.close);

    final names = (await upgraded
            .customSelect("SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%'")
            .get())
        .map((r) => r.read<String>('name'))
        .toList();
    expect(names, containsAll([...MyDataService.deleteOrder, 'action']));

    final extras = (await upgraded.customSelect("SELECT name FROM sqlite_master WHERE type IN ('index', 'trigger')").get())
        .map((r) => r.read<String>('name'))
        .toSet();
    expect(extras, containsAll(['option_offer_day', 'plan_item_day', 'followed_activity_unfollowed']));
    expect(extras, containsAll(['option_offer_new_swap', 'plan_item_offer', 'preference_motivation_limit']));

    final consent = await upgraded.select(upgraded.consentRecords).getSingle();
    expect(consent.consentVersion, '2026-10-27.1');
    expect(consent.acceptedAt.toUtc(), DateTime.utc(2026, 10, 27, 8));
  });
}
