import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/app/app.dart';
import 'package:lilt/data/consent_repository.dart';
import 'package:lilt/data/database.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/data/library/library_loader.dart';
import 'package:lilt/data/my_data.dart';
import 'package:lilt/domain/day.dart';
import 'package:lilt/features/rhythm/rhythm_repository.dart';
import 'package:lilt/features/rhythm/rhythm_screen.dart';
import 'package:lilt/features/settings/demo_seed.dart';
import 'package:lilt/features/settings/settings_providers.dart';
import 'package:lilt/features/starting_point/setup_model.dart';
import 'package:lilt/features/starting_point/setup_repository.dart';
import 'package:lilt/features/support/support_providers.dart';
import 'package:lilt/ui/ui.dart';

import '../support/test_support.dart';

/// S-006 My rhythm, S-015 Full history and S-113 Day detail (frames 6.1, 6.3, 6.4, 6.5), with S-105's rules
/// (BR-010). "Today" is Friday 23 October 2026, 09:00.
const _runner = SetupAnswers(
  paths: {SetupPath.keepGoing},
  keepActivity: ActivityKind.gym,
  progress: Progress.goingWell,
  freeTimes: {'lunch'},
  access: {'gym_membership'},
);

Future<LiltDatabase> _rana(WidgetTester? tester, {Size size = const Size(360, 800), double textScale = 1}) async {
  final db = inMemoryDatabase();
  addTearDown(db.close);
  // The demo plan points at library actions, so the library is loaded first (as Settings does).
  await DriftLibraryLoader(db, readAssetFile).load();
  await DemoSeed(db, MyDataService(db)).load(DemoPersona.rana, now: fixedNow());
  if (tester != null) await _pump(tester, db, size: size, textScale: textScale);
  return db;
}

Future<void> _pump(
  WidgetTester tester,
  LiltDatabase db, {
  Size size = const Size(360, 800),
  double textScale = 1,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        ...todayTestOverrides(db),
        assetReaderProvider.overrideWithValue(readAssetFile),
        demoBuildProvider.overrideWithValue(false),
      ],
      child: MediaQuery(
        data: MediaQueryData(size: size, textScaler: TextScaler.linear(textScale)),
        child: const LiltApp(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _openRhythm(WidgetTester tester) async {
  await tester.tap(find.text('My rhythm').last);
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, String text) async {
  // A long list builds only what is near the screen, so scroll to it first.
  if (find.text(text).evaluate().isEmpty) {
    await tester.scrollUntilVisible(find.text(text), 200, scrollable: find.byType(Scrollable).first);
  }
  final finder = find.text(text).first;
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<List<Observation>> _observations(LiltDatabase db) => db.select(db.observations).get();

void main() {
  group('the rules for observations (BR-010)', () {
    test('Yes, it fits confirms a proposed observation and only that', () async {
      final db = await _rana(null);
      final repo = RhythmRepository(db);
      final proposed = (await _observations(db)).singleWhere((o) => o.status == ObsStatus.proposed);
      await repo.confirm(proposed.id, now: fixedNow());
      final after = (await _observations(db)).singleWhere((o) => o.id == proposed.id);
      expect(after.status, ObsStatus.confirmed);
      expect(after.confirmedAt, isNotNull);

      // A deleted one cannot be confirmed back by a stray tap.
      await repo.delete(proposed.id);
      await repo.confirm(proposed.id, now: fixedNow());
      expect((await _observations(db)).singleWhere((o) => o.id == proposed.id).status, ObsStatus.deleted);
    });

    test('Not really keeps the row marked deleted, so the pattern is never proposed again', () async {
      final db = await _rana(null);
      final repo = RhythmRepository(db);
      final proposed = (await _observations(db)).singleWhere((o) => o.status == ObsStatus.proposed);
      await repo.delete(proposed.id);
      await repo.proposeIfDue(today: '2026-10-23', now: fixedNow());
      final rows = await _observations(db);
      expect(rows.where((o) => o.patternKey == proposed.patternKey).single.status, ObsStatus.deleted);
      expect(rows.where((o) => o.status == ObsStatus.proposed && o.patternKey == proposed.patternKey), isEmpty);
    });

    test('rewording trims, confirms, keeps the pattern, and refuses empty or too long text', () async {
      final db = await _rana(null);
      final repo = RhythmRepository(db);
      final proposed = (await _observations(db)).singleWhere((o) => o.status == ObsStatus.proposed);

      expect(await repo.edit(proposed.id, '   ', now: fixedNow()), isFalse);
      expect(await repo.edit(proposed.id, 'x' * (maxObservationLength + 1), now: fixedNow()), isFalse);
      expect((await _observations(db)).singleWhere((o) => o.id == proposed.id).text_, proposed.text_);

      expect(await repo.edit(proposed.id, '  Lunch walks are my thing  ', now: fixedNow()), isTrue);
      final after = (await _observations(db)).singleWhere((o) => o.id == proposed.id);
      expect(after.text_, 'Lunch walks are my thing');
      expect(after.source, ObsSource.user);
      expect(after.status, ObsStatus.confirmed);
      expect(after.patternKey, proposed.patternKey);

      await repo.delete(proposed.id);
      expect(await repo.edit(proposed.id, 'Back again', now: fixedNow()), isFalse);
    });

    test('at most one pattern is noticed a day, and none while one is waiting', () async {
      final db = inMemoryDatabase();
      addTearDown(db.close);
      await DriftConsentRepository(db).agree();
      await DriftSetupRepository(db).save(_runner);
      // Four enjoyed walks: a pattern for "walking" and one for "free" and the like.
      for (var i = 0; i < 4; i++) {
        final day = addDays('2026-10-19', i);
        final item = await db
            .into(db.planItems)
            .insertReturning(
              PlanItemsCompanion.insert(
                title: 'Walk',
                activity: ActivityKind.walking,
                plannedDay: day,
                source: PlanSource.custom,
              ),
            );
        await db
            .into(db.reflections)
            .insert(
              ReflectionsCompanion.insert(
                planItemId: item.id,
                status: const Value(ReflectionStatus.completed),
                enjoyment: const Value(3),
              ),
            );
      }
      final repo = RhythmRepository(db);
      await repo.proposeIfDue(today: '2026-10-23', now: fixedNow());
      expect((await _observations(db)).length, 1);
      await repo.proposeIfDue(today: '2026-10-23', now: fixedNow());
      expect((await _observations(db)).length, 1, reason: 'one is already waiting');

      await repo.confirm((await _observations(db)).single.id, now: fixedNow());
      await repo.proposeIfDue(today: '2026-10-23', now: fixedNow());
      expect((await _observations(db)).length, 1, reason: 'one was proposed today already');
    });

    test('active days and returns come from what happened and never from a skip', () async {
      final db = await _rana(null);
      final repo = RhythmRepository(db);
      final before = await repo.read(today: '2026-10-23', now: fixedNow());
      expect(before.totals.returns, 1);
      expect(before.totals.activeDays, greaterThan(10));
      // A skipped day adds nothing and takes nothing away.
      final item = await db
          .into(db.planItems)
          .insertReturning(
            PlanItemsCompanion.insert(
              title: 'Walk',
              activity: ActivityKind.walking,
              plannedDay: '2026-10-23',
              source: PlanSource.custom,
            ),
          );
      await db
          .into(db.reflections)
          .insert(ReflectionsCompanion.insert(planItemId: item.id, status: const Value(ReflectionStatus.skipped)));
      final after = await repo.read(today: '2026-10-23', now: fixedNow());
      expect(after.totals.activeDays, before.totals.activeDays);
      expect(after.totals.returns, before.totals.returns);
    });
  });

  group('wording', () {
    test('totals read as the frame does and never use loss words (BR-007)', () {
      expect(totalsLine(31, 2), 'Active on 31 days. Came back 2 times after a break.');
      expect(totalsLine(1, 1), 'Active on 1 day. Came back 1 time after a break.');
      expect(totalsLine(5, 0), 'Active on 5 days.');
    });
  });

  group('My rhythm', () {
    testWidgets('shows the totals, the legend and the confirmed and proposed observations', (tester) async {
      final db = await _rana(tester);
      await _openRhythm(tester);

      final repo = RhythmRepository(db);
      final data = await repo.read(today: '2026-10-23', now: fixedNow());
      expect(find.text(totalsLine(data.totals.activeDays, data.totals.returns)), findsOneWidget);
      for (final l in ['Done', 'Partly', 'Rest or not shared']) {
        expect(find.text(l), findsOneWidget);
      }
      expect(find.text('What works for me'), findsOneWidget);
      expect(find.text('Confirmed · used for suggestions', skipOffstage: false), findsOneWidget);
      expect(find.text('We noticed', skipOffstage: false), findsOneWidget);
      expect(find.text('Yes, it fits'), findsOneWidget);
      expect(find.text('Not really'), findsOneWidget);
    });

    testWidgets('Yes, it fits moves the pattern to confirmed', (tester) async {
      final db = await _rana(tester);
      await _openRhythm(tester);
      await _tap(tester, 'Yes, it fits');
      expect(find.text('We noticed', skipOffstage: false), findsNothing);
      expect(find.text('Confirmed · used for suggestions', skipOffstage: false), findsNWidgets(2));
      expect((await _observations(db)).where((o) => o.status == ObsStatus.confirmed), hasLength(2));
    });

    testWidgets('Not really removes it and it does not come back', (tester) async {
      final db = await _rana(tester);
      await _openRhythm(tester);
      await _tap(tester, 'Not really');
      expect(find.text('We noticed', skipOffstage: false), findsNothing);
      expect((await _observations(db)).where((o) => o.status == ObsStatus.deleted), hasLength(1));
    });

    testWidgets('Edit opens the sheet; Say it differently saves their words', (tester) async {
      final db = await _rana(tester);
      await _openRhythm(tester);
      await _tap(tester, 'Edit');
      expect(find.text('Does this still fit you?'), findsOneWidget);
      await tester.tap(find.text('Say it differently'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Walking with a friend is the best part');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('Walking with a friend is the best part'), findsOneWidget);
      expect((await _observations(db)).any((o) => o.text_ == 'Walking with a friend is the best part'), isTrue);
    });

    testWidgets('Save is off while the words are empty, and Remove it deletes', (tester) async {
      final db = await _rana(tester);
      await _openRhythm(tester);
      await _tap(tester, 'Edit');
      await tester.tap(find.text('Say it differently'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();
      final save = tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Save'));
      expect(save.onPressed, isNull);
      await tester.tap(find.text('Remove it'));
      await tester.pumpAndSettle();
      expect(find.text('Confirmed · used for suggestions', skipOffstage: false), findsNothing);
      expect((await _observations(db)).where((o) => o.status == ObsStatus.deleted), hasLength(1));
    });

    testWidgets('reworded text that matches the red-flag list stores nothing and shows support (BR-003, EQ-008)', (
      tester,
    ) async {
      final db = await _rana(tester);
      await _openRhythm(tester);
      final before = (await _observations(db)).map((o) => '${o.id}${o.status.code}${o.text_}').toList();
      await _tap(tester, 'Edit');
      await tester.tap(find.text('Say it differently'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'I want to die');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('You don’t have to handle this alone'), findsOneWidget);
      final after = (await _observations(db)).map((o) => '${o.id}${o.status.code}${o.text_}').toList();
      expect(after, before, reason: 'the words are not stored');
    });

    testWidgets('when the red-flag check cannot run the words are not kept, and the sheet says so (BR-003)', (
      tester,
    ) async {
      final db = inMemoryDatabase();
      addTearDown(db.close);
      await DriftLibraryLoader(db, readAssetFile).load();
      await DemoSeed(db, MyDataService(db)).load(DemoPersona.rana, now: fixedNow());
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            ...todayTestOverrides(db),
            assetReaderProvider.overrideWithValue(readAssetFile),
            demoBuildProvider.overrideWithValue(false),
            redFlagDetectorProvider.overrideWith((ref) => throw StateError('list did not load')),
          ],
          child: const LiltApp(),
        ),
      );
      await tester.pumpAndSettle();
      await _openRhythm(tester);
      await _tap(tester, 'Edit');
      await tester.tap(find.text('Say it differently'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Walking with a friend');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.text('That did not work. Please try again.'), findsOneWidget);
      expect((await _observations(db)).any((o) => o.text_ == 'Walking with a friend'), isFalse);
    });

    testWidgets('closing the sheet changes nothing', (tester) async {
      final db = await _rana(tester);
      await _openRhythm(tester);
      final before = (await _observations(db)).map((o) => '${o.id}${o.status.code}${o.text_}').toList();
      await _tap(tester, 'Edit');
      await tester.tapAt(const Offset(20, 40));
      await tester.pumpAndSettle();
      final after = (await _observations(db)).map((o) => '${o.id}${o.status.code}${o.text_}').toList();
      expect(after, before);
    });

    testWidgets('day one: no history link, a plain line, and nothing is invented', (tester) async {
      final db = inMemoryDatabase();
      addTearDown(db.close);
      await DriftConsentRepository(db).agree();
      await DriftSetupRepository(db).save(_runner);
      await _pump(tester, db);
      await _openRhythm(tester);
      expect(find.text('Your days will show up here as you answer “How did it go?”.'), findsOneWidget);
      expect(find.text('See every day'), findsNothing);
      expect(find.text('We noticed', skipOffstage: false), findsNothing);
      expect(find.textContaining('Active on'), findsNothing);
    });
  });

  group('full history and the day detail', () {
    testWidgets('See every day shows the months, newest first, and a day opens its detail', (tester) async {
      await _rana(tester);
      await _openRhythm(tester);
      await _tap(tester, 'See every day');
      expect(find.text('Your rhythm'), findsOneWidget);
      expect(find.text('October 2026'), findsOneWidget);
      final october = tester.getTopLeft(find.text('October 2026')).dy;
      final september = tester.getTopLeft(find.text('September 2026')).dy;
      expect(october, lessThan(september));

      // Wednesday 21 October: a done day in the seed.
      await tester.tap(find.bySemanticsLabel(RegExp('^Wednesday 21 October')));
      await tester.pumpAndSettle();
      expect(find.text('Wednesday 21 October'), findsWidgets);
      expect(find.textContaining('counts toward your rhythm'), findsOneWidget);
      await tester.tap(find.byTooltip('Back').first);
    });

    testWidgets('Add answer on a day that was never answered saves it, and the day lights up (BR-009)', (tester) async {
      final db = await _rana(tester);
      final open = await (db.select(
        db.reflections,
      )..where((t) => t.status.equals(ReflectionStatus.unknown.code))).get();
      expect(open, isNotEmpty, reason: 'the seed leaves some days unanswered');
      final item = await (db.select(db.planItems)..where((t) => t.id.equals(open.first.planItemId))).getSingle();

      await _openRhythm(tester);
      await _tap(tester, 'See every day');
      await tester.tap(find.bySemanticsLabel(RegExp('^${RegExp.escape(_long(item.plannedDay))}')));
      await tester.pumpAndSettle();
      expect(find.text('Not shared'), findsWidgets);
      await tester.tap(find.text('Add answer').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Done').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      final saved = await (db.select(db.reflections)..where((t) => t.planItemId.equals(item.id))).getSingle();
      expect(saved.status, ReflectionStatus.completed);
      expect(find.text('Edit'), findsWidgets);
    });

    testWidgets('an answer can be raised from the day detail but never lowered (BR-007)', (tester) async {
      final db = await _rana(tester);
      final done = await (db.select(
        db.reflections,
      )..where((t) => t.status.equals(ReflectionStatus.completed.code))).get();
      final item = await (db.select(db.planItems)..where((t) => t.id.equals(done.first.planItemId))).getSingle();
      await _openRhythm(tester);
      await _tap(tester, 'See every day');
      await tester.tap(find.bySemanticsLabel(RegExp('^${RegExp.escape(_long(item.plannedDay))}')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit').first);
      await tester.pumpAndSettle();
      // Done is the only answer offered for a done day.
      final sheet = find.byType(LiltSheet).last;
      expect(find.descendant(of: sheet, matching: find.text('Done')), findsOneWidget);
      expect(find.descendant(of: sheet, matching: find.text('Partly')), findsNothing);
      expect(find.descendant(of: sheet, matching: find.text('Didn’t get to it')), findsNothing);
    });

    testWidgets('a day with nothing planned says so without blame', (tester) async {
      await _rana(tester);
      await _openRhythm(tester);
      await _tap(tester, 'See every day');
      // Oct 20 is in the lapse's aftermath in the seed: find any empty past tile.
      final tiles = find.bySemanticsLabel(RegExp(r'rest or not shared$'));
      expect(tiles, findsWidgets);
      await tester.tap(tiles.first);
      await tester.pumpAndSettle();
      expect(find.textContaining('Nothing was planned'), findsOneWidget);
    });
  });

  group('accessibility (TC-044, TC-045)', () {
    for (final (name, size) in [('360x800', const Size(360, 800)), ('320x568', const Size(320, 568))]) {
      for (final scale in [1.0, 2.0]) {
        testWidgets('My rhythm passes the text and label checks at $name and ${(scale * 100).round()}%', (
          tester,
        ) async {
          final handle = tester.ensureSemantics();
          await _rana(tester, size: size, textScale: scale);
          await _openRhythm(tester);
          await expectLater(tester, meetsGuideline(textContrastGuideline));
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          handle.dispose();
        });
      }
    }

    testWidgets('the history calendar and the day sheet pass at 360x800', (tester) async {
      final handle = tester.ensureSemantics();
      await _rana(tester);
      await _openRhythm(tester);
      await _tap(tester, 'See every day');
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await tester.tap(find.bySemanticsLabel(RegExp('^Wednesday 21 October')));
      await tester.pumpAndSettle();
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('the grid reads as one summary, not eighty tiles', (tester) async {
      final handle = tester.ensureSemantics();
      await _rana(tester);
      await _openRhythm(tester);
      expect(find.bySemanticsLabel(RegExp(r'^Your rhythm, last 17 weeks\. \d+ days with activity\.$')), findsOneWidget);
      handle.dispose();
    });
  });
}

String _long(String day) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  final d = parseDay(day);
  return '${weekdays[d.weekday - 1]} ${d.day} ${months[d.month - 1]}';
}
