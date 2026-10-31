import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/data/database.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/data/library/library_loader.dart';
import 'package:lilt/data/my_data.dart';
import 'package:lilt/domain/day.dart';
import 'package:lilt/domain/lapse.dart';
import 'package:lilt/domain/metrics.dart';
import 'package:lilt/features/settings/demo_seed.dart';
import 'package:lilt/features/today/today_data.dart';

import '../support/test_support.dart';

/// The demo people (seed/README.md): synthetic, the same every time, and doing what they say they do.
void main() {
  final now = DateTime(2026, 10, 23, 9);
  final today = formatDay(DateTime.utc(2026, 10, 23));

  late LiltDatabase db;
  late MyDataService myData;
  late DemoSeed seed;

  setUp(() async {
    db = inMemoryDatabase();
    await DriftLibraryLoader(db, readAssetFile).load();
    myData = MyDataService(db);
    seed = DemoSeed(db, myData);
  });
  tearDown(() => db.close());

  Future<int> count(String table) async =>
      (await db.customSelect('SELECT COUNT(*) AS n FROM "$table"').getSingle()).read<int>('n');

  group('Rana', () {
    setUp(() => seed.load(DemoPersona.rana, now: now));

    test('has agreed and finished setup, so the demo opens on Today', () async {
      expect(await count('consent'), 1);
      expect((await db.select(db.profiles).getSingle()).setupDoneAt, isNotNull);
      final followed = await db.select(db.followedActivities).get();
      expect(followed.map((f) => f.activity), [ActivityKind.walking]);
    });

    test('walked for three weeks, broke for six days, and came back two days ago (EQ-001, EQ-011)', () async {
      final inputs = await loadTodayInputs(db);
      final reflected = reflectedDaysOf(inputs.reflections);
      final spans = findLapses(reflectedDays: reflected, pausedDays: pausedDays(inputs.pauses, today), today: today);

      expect(spans, hasLength(1), reason: 'one lapse, no accidental gaps: $spans');
      expect(spans.single.startDay, addDays(today, -8));
      expect(spans.single.returnDay, addDays(today, -2));
      expect(openLapse(reflectedDays: reflected, pausedDays: pausedDays(inputs.pauses, today), today: today), isNull);

      final returns = await db.select(db.returnEvents).get();
      expect(returns, hasLength(1));
      expect(returns.single.returnDay, spans.single.returnDay);
      expect(returns.single.whatChanged, 'moved');
    });

    test('a three-day pause in a busy week is not a lapse', () async {
      final pauses = await db.select(db.pauses).get();
      expect(pauses, hasLength(1));
      expect(daysBetween(pauses.single.startDay, pauses.single.endDay!), 3);
    });

    test('some days were never answered, and they are not counted as skipped (BR-009)', () async {
      final rows = await db.select(db.reflections).get();
      expect(rows.where((r) => r.status == ReflectionStatus.unknown), isNotEmpty);
    });

    test('totals only count days someone did something, and the walks with company were enjoyed', () async {
      final inputs = await loadTodayInputs(db);
      final t = totals(reflections: inputs.reflections, returnEvents: 1);
      expect(t.activeDays, greaterThan(15));
      expect(t.returns, 1);

      final company = (await db.select(db.planItems).get()).where((p) => p.withWhom == WithWhom.friends).toList();
      expect(company, hasLength(4));
      final enjoyed = await (db.select(db.reflections)..where((r) => r.enjoyment.equals(3))).get();
      expect(enjoyed.length, greaterThanOrEqualTo(4));
    });

    test('one observation is confirmed and one is only proposed (BR-010)', () async {
      final obs = await db.select(db.observations).get();
      expect(obs.where((o) => o.status == ObsStatus.confirmed), hasLength(1));
      expect(obs.where((o) => o.status == ObsStatus.proposed), hasLength(1));
      for (final o in obs) {
        expect(o.text_, startsWith('You said'));
      }
    });

    test('every demo row says it is demo data, so the app can label it', () async {
      for (final table in ['followed_activity', 'plan_item', 'reflection', 'pause', 'return_event', 'observation']) {
        final rows = await db.customSelect('SELECT id FROM "$table"').get();
        expect(rows, isNotEmpty, reason: table);
        for (final r in rows) {
          expect(r.read<String>('id'), startsWith(demoIdPrefix), reason: table);
        }
      }
    });
  });

  group('Sam', () {
    setUp(() => seed.load(DemoPersona.sam, now: now));

    test('follows stretching, leaves out team sports, and has no lapse', () async {
      final followed = await db.select(db.followedActivities).get();
      expect(followed.map((f) => f.activity), [ActivityKind.yoga]);
      final excluded = await (db.select(db.preferences)..where((p) => p.kind.equals(PrefKind.excluded.code))).get();
      expect(excluded.map((p) => p.value), ['team_sport']);

      final inputs = await loadTodayInputs(db);
      expect(findLapses(reflectedDays: reflectedDaysOf(inputs.reflections), pausedDays: const {}, today: today), isEmpty);
    });

    test('most days are partly done, and none is a streak', () async {
      final rows = await db.select(db.reflections).get();
      expect(rows.where((r) => r.status == ReflectionStatus.partly).length, greaterThan(rows.where((r) => r.status == ReflectionStatus.completed).length));
      expect(await count('return_event'), 0);
    });
  });

  group('loading', () {
    test('is repeatable: the same persona on the same day gives the same rows', () async {
      await seed.load(DemoPersona.rana, now: now);
      final first = [for (final t in ['plan_item', 'reflection', 'observation', 'pause']) await count(t)];
      await seed.load(DemoPersona.rana, now: now);
      expect([for (final t in ['plan_item', 'reflection', 'observation', 'pause']) await count(t)], first);
    });

    test('replaces whatever was there, so demo and real data never mix (BR-017)', () async {
      await seed.load(DemoPersona.rana, now: now);
      await seed.load(DemoPersona.sam, now: now);
      expect(await count('return_event'), 0);
      expect(await count('observation'), 0);
      expect((await db.select(db.followedActivities).get()).map((f) => f.activity), [ActivityKind.yoga]);
    });

    test('delete everything afterwards leaves no user rows, and keeps the library (TC-025)', () async {
      await seed.load(DemoPersona.rana, now: now);
      await myData.deleteAll();
      for (final table in db.userTables) {
        expect(await count(table.actualTableName), 0, reason: table.actualTableName);
      }
      expect(await db.select(db.actions).get(), isNotEmpty);
    });
  });
}
