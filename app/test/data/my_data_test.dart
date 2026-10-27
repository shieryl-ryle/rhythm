import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/app/app.dart';
import 'package:lilt/data/database.dart';
import 'package:lilt/data/my_data.dart';
import 'package:lilt/data/providers.dart';

import 'seed_helper.dart';

/// TC-007 (F-007), TC-022 (BR-014) and TC-025 (BR-017): consent before data, export contains every
/// user table, delete-all leaves zero rows, runs its hooks and returns the app to the consent screen.
void main() {
  late LiltDatabase db;

  setUp(() => db = LiltDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  group('TC-022 fresh install', () {
    test('no row is written in any table before consent is accepted', () async {
      final counts = await userRowCounts(db);
      expect(counts.keys.toSet(), MyDataService.deleteOrder.toSet());
      expect(counts.values.every((n) => n == 0), isTrue, reason: '$counts');
    });
  });

  group('TC-007 / TC-025 export', () {
    test('contains every user table and not the library', () async {
      await seedEverything(db);
      final data = await MyDataService(db).exportData();

      final tables = data['tables']! as Map<String, Object?>;
      expect(tables.keys.toSet(), MyDataService.deleteOrder.toSet());
      expect(tables, isNot(contains('action')));
      for (final name in MyDataService.deleteOrder) {
        expect((tables[name]! as List), isNotEmpty, reason: '$name has no exported row');
      }
      expect(data['app'], 'Lilt');
      expect(data['schema_version'], db.schemaVersion);
    });

    test('is a readable JSON file with codes, comma sets and ISO dates as stored', () async {
      await seedEverything(db);
      final json = await MyDataService(db).exportJson();
      final parsed = jsonDecode(json) as Map<String, dynamic>;
      final tables = parsed['tables'] as Map<String, dynamic>;

      final followed = (tables['followed_activity'] as List).single as Map<String, dynamic>;
      expect(followed['activity'], 'running');
      expect(followed['path'], 'pick_up_again');
      expect(followed['got_in_the_way'], 'busier,just_drifted');
      final consent = (tables['consent'] as List).single as Map<String, dynamic>;
      expect(consent['accepted_at'], '2026-10-27T08:00:00.000Z');
      final reflection = (tables['reflection'] as List).single as Map<String, dynamic>;
      expect(reflection['barrier'], 'low_energy');
      expect(reflection['enjoyment'], 2);
    });
  });

  group('TC-007 / TC-025 delete-all', () {
    test('leaves every user table empty and keeps the library', () async {
      await seedEverything(db);
      expect((await userRowCounts(db)).values.every((n) => n > 0), isTrue);

      await MyDataService(db).deleteAll();

      final counts = await userRowCounts(db);
      expect(counts.values.every((n) => n == 0), isTrue, reason: '$counts');
      expect(await db.select(db.actions).get(), hasLength(1));
    });

    test('runs its hooks (notifications, Together) before removing anything', () async {
      await seedEverything(db);
      final calls = <String>[];
      final service = MyDataService(
        db,
        hooks: [
          () async {
            calls.add('cancel notifications');
            // The data is still there while the hooks run.
            expect((await userRowCounts(db))['consent'], 1);
          },
          () async => calls.add('delete Together account'),
        ],
      );

      await service.deleteAll();

      expect(calls, ['cancel notifications', 'delete Together account']);
      expect((await userRowCounts(db))['consent'], 0);
    });

    test('deletes nothing when a hook fails, so the person can retry', () async {
      await seedEverything(db);
      final service = MyDataService(db, hooks: [() async => throw StateError('server unreachable')]);

      await expectLater(service.deleteAll(), throwsStateError);

      expect((await userRowCounts(db)).values.every((n) => n > 0), isTrue);
    });
  });

  testWidgets('TC-025: delete-all sends the person back to the consent screen', (tester) async {
    final calls = <String>[];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          deleteAllHooksProvider.overrideWithValue([() async => calls.add('cancel notifications')]),
        ],
        child: const LiltApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('I agree, continue'));
    await tester.pumpAndSettle();
    expect(find.text('Here’s what fits today'), findsOneWidget);
    expect((await userRowCounts(db))['consent'], 1);

    final container = ProviderScope.containerOf(tester.element(find.byType(LiltApp)));
    await container.read(deleteEverythingProvider)();
    await tester.pumpAndSettle();

    expect(calls, ['cancel notifications']);
    expect(find.text('Welcome to Lilt'), findsOneWidget);
    expect((await userRowCounts(db)).values.every((n) => n == 0), isTrue);
  });
}
