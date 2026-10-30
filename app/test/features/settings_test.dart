import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/app/app.dart';
import 'package:lilt/data/consent_repository.dart';
import 'package:lilt/data/database.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/data/providers.dart';
import 'package:lilt/features/settings/demo_seed.dart';
import 'package:lilt/features/settings/settings_providers.dart';
import 'package:lilt/features/starting_point/setup_model.dart';
import 'package:lilt/features/starting_point/setup_repository.dart';
import 'package:lilt/features/support/support_providers.dart';

import '../support/test_support.dart';

/// S-008 Settings & My Data, first version (frames 7.1, 7.4 to 7.7): export, delete everything, support, and in a
/// demo build the synthetic people. "Today" is Friday 23 October 2026, 09:00.
const _runner = SetupAnswers(
  paths: {SetupPath.keepGoing},
  keepActivity: ActivityKind.gym,
  progress: Progress.goingWell,
  freeTimes: {'lunch'},
  access: {'gym_membership'},
);

Future<LiltDatabase> _open(
  WidgetTester tester, {
  bool demo = false,
  double textScale = 1,
  Size size = const Size(360, 800),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final db = inMemoryDatabase();
  addTearDown(db.close);
  await DriftConsentRepository(db).agree();
  await DriftSetupRepository(db).save(_runner);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...todayTestOverrides(db),
        assetReaderProvider.overrideWithValue(readAssetFile),
        demoBuildProvider.overrideWithValue(demo),
      ],
      child: MediaQuery(
        data: MediaQueryData(size: size, textScaler: TextScaler.linear(textScale)),
        child: const LiltApp(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return db;
}

Future<void> _tap(WidgetTester tester, String text) async {
  final finder = find.text(text).first;
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _openSettings(WidgetTester tester) async {
  await tester.tap(find.bySemanticsLabel('Settings'));
  await tester.pumpAndSettle();
}

Future<int> _rows(LiltDatabase db, String table) async =>
    (await db.customSelect('SELECT COUNT(*) AS n FROM "$table"').getSingle()).read<int>('n');

void main() {
  group('opening Settings', () {
    testWidgets('the profile button on Today opens it, and Back returns to Today', (tester) async {
      await _open(tester);
      await _openSettings(tester);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Export my data'), findsOneWidget);
      expect(find.text('Delete everything'), findsOneWidget);
      expect(find.text('Need support?'), findsOneWidget);

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.text('Today’s plan'), findsNothing);
      expect(find.text('I’ll try this'), findsWidgets);
    });

    testWidgets('a release build has no demo rows and no demo label', (tester) async {
      await _open(tester);
      await _openSettings(tester);
      expect(find.textContaining('demo data'), findsNothing);
      expect(find.textContaining('Demo'), findsNothing);
    });

    testWidgets('"Need support?" opens the support message', (tester) async {
      await _open(tester);
      await _openSettings(tester);
      await _tap(tester, 'Need support?');
      expect(find.text('You don’t have to handle this alone'), findsOneWidget);
    });
  });

  group('export (TC-007, TC-025)', () {
    testWidgets('copies every table as JSON and says so', (tester) async {
      String? copied;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == 'Clipboard.setData') copied = (call.arguments as Map)['text'] as String;
        return null;
      });
      addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));

      final db = await _open(tester);
      await _openSettings(tester);
      await _tap(tester, 'Export my data');

      expect(find.text('Copied. Paste it into a note or a file to keep it.'), findsOneWidget);
      expect(copied, isNotNull);
      expect(copied, contains('"app": "Lilt"'));
      for (final table in db.userTables) {
        expect(copied, contains('"${table.actualTableName}"'), reason: 'the export holds ${table.actualTableName}');
      }
    });

    testWidgets('a failed export says so and can be tried again', (tester) async {
      var fail = true;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == 'Clipboard.setData' && fail) throw PlatformException(code: 'denied');
        return null;
      });
      addTearDown(() => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, null));

      await _open(tester);
      await _openSettings(tester);
      await _tap(tester, 'Export my data');
      expect(find.text('That didn’t work. Try again.'), findsOneWidget);

      fail = false;
      await _tap(tester, 'Export my data');
      expect(find.text('Copied. Paste it into a note or a file to keep it.'), findsOneWidget);
    });
  });

  group('delete everything (TC-025, BR-017)', () {
    testWidgets('"Keep my data" is the default and deletes nothing', (tester) async {
      final db = await _open(tester);
      await _openSettings(tester);
      await _tap(tester, 'Delete everything');
      expect(find.text('Delete everything?'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Keep my data'), findsOneWidget, reason: 'the one filled button');
      expect(find.widgetWithText(FilledButton, 'Delete everything'), findsNothing);

      await tester.tap(find.text('Keep my data'));
      await tester.pumpAndSettle();
      expect(find.text('Delete everything?'), findsNothing);
      expect(await _rows(db, 'followed_activity'), 1);
      expect(await _rows(db, 'consent'), 1);
    });

    testWidgets('confirming removes every user row and shows the consent screen', (tester) async {
      final db = await _open(tester);
      await _openSettings(tester);
      await _tap(tester, 'Delete everything');
      await tester.tap(find.widgetWithText(OutlinedButton, 'Delete everything'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      for (final table in db.userTables) {
        expect(await _rows(db, table.actualTableName), 0, reason: table.actualTableName);
      }
      expect(await _rows(db, 'action'), greaterThan(0), reason: 'the library is not personal data');
      expect(find.text('Settings'), findsNothing);
    });
  });

  group('demo build', () {
    testWidgets('lists the demo people, and a tap loads one and lands on Today with a label on every screen', (tester) async {
      final db = await _open(tester, demo: true);
      await _openSettings(tester);
      expect(find.text('Load demo data: Rana'), findsOneWidget);
      expect(find.text('Load demo data: Sam'), findsOneWidget);
      expect(find.text('Demo data · invented, not a real person'), findsNothing, reason: 'nothing is loaded yet');

      await _tap(tester, 'Load demo data: Rana');
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(await _rows(db, 'return_event'), 1);
      expect(find.text('Demo data · invented, not a real person'), findsOneWidget);
      expect(find.bySemanticsLabel('Settings'), findsOneWidget, reason: 'on Today');
    });

    testWidgets('loading Sam afterwards replaces Rana, and deleting everything takes the label away', (tester) async {
      final db = await _open(tester, demo: true);
      await _openSettings(tester);
      await _tap(tester, 'Load demo data: Rana');
      await tester.pumpAndSettle();
      await _openSettings(tester);
      expect(find.text('Demo data · invented, not a real person'), findsOneWidget, reason: 'on Settings too');
      await _tap(tester, 'Load demo data: Sam');
      await tester.pumpAndSettle();
      expect(await _rows(db, 'return_event'), 0);

      await _openSettings(tester);
      await _tap(tester, 'Delete everything');
      await tester.tap(find.widgetWithText(OutlinedButton, 'Delete everything'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(find.text('Demo data · invented, not a real person'), findsNothing);
      expect(await _rows(db, 'followed_activity'), 0);
    });

    testWidgets('the label is gone once everything is deleted, even if the app is used again', (tester) async {
      await _open(tester, demo: true);
      final container = ProviderScope.containerOf(tester.element(find.byType(LiltApp)));
      await container.read(loadDemoProvider)(DemoPersona.sam);
      expect(await container.read(demoDataLoadedProvider.future), isTrue);

      await container.read(deleteEverythingProvider)();
      await tester.pumpAndSettle();
      expect(await container.read(demoDataLoadedProvider.future), isFalse);
    });

    testWidgets('a release build does not load anything even if asked (BR-017)', (tester) async {
      final db = await _open(tester);
      final container = ProviderScope.containerOf(tester.element(find.byType(LiltApp)));
      await container.read(loadDemoProvider)(DemoPersona.rana);
      expect(await _rows(db, 'return_event'), 0);
      expect((await db.select(db.followedActivities).get()).single.activity, ActivityKind.gym);
    });
  });

  group('TC-044 and TC-045 on Settings', () {
    for (final scale in [1.0, 2.0]) {
      for (final size in [const Size(360, 800), const Size(320, 568)]) {
        testWidgets('${(scale * 100).round()}% text on ${size.width.toInt()}x${size.height.toInt()}', (tester) async {
          final handle = tester.ensureSemantics();
          await _open(tester, demo: true, textScale: scale, size: size);
          Future<void> check(String where) async {
            expect(tester.takeException(), isNull, reason: where);
            await expectLater(tester, meetsGuideline(androidTapTargetGuideline), reason: where);
            await expectLater(tester, meetsGuideline(labeledTapTargetGuideline), reason: where);
            await expectLater(tester, meetsGuideline(textContrastGuideline), reason: where);
          }

          await _openSettings(tester);
          await check('settings');
          await _tap(tester, 'Delete everything');
          await check('delete dialog');
          expect(find.text('Keep my data'), findsOneWidget);
          await tester.tap(find.text('Keep my data'));
          await tester.pumpAndSettle();
          handle.dispose();
        });
      }
    }
  });
}
