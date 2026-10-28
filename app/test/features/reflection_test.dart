import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/app/app.dart';
import 'package:lilt/data/consent_repository.dart';
import 'package:lilt/data/database.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/data/library/library_loader.dart';
import 'package:lilt/data/library/library_models.dart';
import 'package:lilt/data/providers.dart';
import 'package:lilt/features/starting_point/setup_model.dart';
import 'package:lilt/features/starting_point/setup_repository.dart';
import 'package:lilt/features/support/support_providers.dart';
import 'package:lilt/features/today/reflection_copy.dart';
import 'package:lilt/features/today/today_repository.dart';

import '../content/guilt_words_test.dart' show neverUse;
import '../support/test_support.dart';

/// S-101 Reflection (frame 3.11, F-003, UF-003, BR-008, BR-009): how it went, saved in two taps, with the
/// follow-ups only where they are asked, and one sentence about what will change. "Today" is Friday 23 October
/// 2026, 09:00.
class _Agreed implements ConsentRepository {
  @override
  Future<bool> hasAgreed() async => true;

  @override
  Future<void> agree() async {}
}

// Two followed activities, so a second option sits under the hero as a compact card ("Still open").
const _twoActivities = SetupAnswers(
  paths: {SetupPath.keepGoing, SetupPath.addNew},
  keepActivity: ActivityKind.gym,
  progress: Progress.goingWell,
  addNewActivity: ActivityKind.walking,
  freeTimes: {'lunch'},
  access: {'gym_membership'},
);

const _runner = SetupAnswers(
  paths: {SetupPath.keepGoing},
  keepActivity: ActivityKind.gym,
  progress: Progress.goingWell,
  freeTimes: {'lunch'},
  access: {'gym_membership'},
);

Future<LiltDatabase> _open(
  WidgetTester tester, {
  Size size = const Size(360, 800),
  double textScale = 1,
  DateTime Function()? clock,
  Future<void> Function(LiltDatabase db)? seed,
  SetupAnswers answers = _runner,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final db = inMemoryDatabase();
  addTearDown(db.close);
  await DriftSetupRepository(db).save(answers);
  await seed?.call(db);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        consentRepositoryProvider.overrideWithValue(_Agreed()),
        ...todayTestOverrides(db, clock: clock),
        assetReaderProvider.overrideWithValue(readAssetFile),
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

Future<void> _tap(WidgetTester tester, String text, {int index = 0}) async {
  final finder = find.text(text).at(index);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<Reflection> _only(LiltDatabase db) async => (await db.select(db.reflections).get()).single;

/// Plans the hero option and opens the sheet.
Future<void> _planAndOpen(WidgetTester tester) async {
  await _tap(tester, 'I’ll try this');
  await tester.pump(const Duration(seconds: 5)); // let the "Added" snackbar go
  await tester.pumpAndSettle();
  await _tap(tester, 'How did it go?');
}

void main() {
  group('the sheet (frame 3.11)', () {
    testWidgets('the planned card has "How did it go?" as its one primary, and the sheet has the three answers',
        (tester) async {
      await _open(tester);
      await _tap(tester, 'I’ll try this');
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(FilledButton, 'How did it go?'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget, reason: 'one primary on the screen');

      await _tap(tester, 'How did it go?');
      expect(find.text('How did it go?'), findsWidgets);
      for (final label in ['Done', 'Partly', 'Didn’t get to it']) {
        expect(find.text(label), findsWidgets, reason: label);
      }
    });

    testWidgets('nothing chosen: Save is off, and closing the sheet leaves the reflection unknown (BR-009)', (tester) async {
      final db = await _open(tester);
      await _planAndOpen(tester);
      expect(tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Save')).onPressed, isNull);
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      expect((await _only(db)).status, ReflectionStatus.unknown);
      expect(find.text('Planned'), findsOneWidget);
    });

    testWidgets('Done is two taps: pick it, Save. The barrier is not asked after Done (BR-008)', (tester) async {
      final db = await _open(tester);
      await _planAndOpen(tester);
      await _tap(tester, 'Done');
      expect(find.text('What got in the way? (optional)'), findsNothing);
      expect(find.text('How was it? (optional)'), findsOneWidget);
      await _tap(tester, 'Save');

      final r = await _only(db);
      expect(r.status, ReflectionStatus.completed);
      expect(r.barrier, isNull);
      expect(find.text('Done'), findsOneWidget, reason: 'the card shows the answer');
      expect(find.text('Change my answer'), findsOneWidget);
    });

    testWidgets('Partly asks what got in the way, with "Prefer not to say", and how it was', (tester) async {
      final db = await _open(tester);
      await _planAndOpen(tester);
      await _tap(tester, 'Partly');
      expect(find.text('What got in the way? (optional)'), findsOneWidget);
      for (final label in ['Time', 'Low energy', 'Didn’t fit my schedule', 'Weather', 'Other', 'Prefer not to say']) {
        expect(find.text(label), findsWidgets, reason: label);
      }
      expect(find.byIcon(Icons.check), findsNothing, reason: 'one answer, so no ticks');
      await _tap(tester, 'Low energy');
      await _tap(tester, 'Enjoyed it');
      await _tap(tester, 'Save');

      final r = await _only(db);
      expect(r.status, ReflectionStatus.partly);
      expect(r.barrier, Barrier.lowEnergy);
      expect(r.enjoyment, 3);
    });

    testWidgets('Didn\'t get to it asks the barrier but not enjoyment', (tester) async {
      final db = await _open(tester);
      await _planAndOpen(tester);
      await _tap(tester, 'Didn’t get to it');
      expect(find.text('What got in the way? (optional)'), findsOneWidget);
      expect(find.text('How was it? (optional)'), findsNothing);
      await _tap(tester, 'Weather');
      await _tap(tester, 'Save');
      final r = await _only(db);
      expect(r.status, ReflectionStatus.skipped);
      expect(r.barrier, Barrier.weather);
      expect(r.enjoyment, isNull);
    });

    testWidgets('a barrier is optional, and tapping it again clears it', (tester) async {
      final db = await _open(tester);
      await _planAndOpen(tester);
      await _tap(tester, 'Partly');
      await _tap(tester, 'Time');
      await _tap(tester, 'Time');
      await _tap(tester, 'Save');
      expect((await _only(db)).barrier, isNull);
    });

    testWidgets('changing the answer to Done clears the barrier (data-model)', (tester) async {
      final db = await _open(tester);
      await _planAndOpen(tester);
      await _tap(tester, 'Partly');
      await _tap(tester, 'Time');
      await _tap(tester, 'Save');
      expect((await _only(db)).barrier, Barrier.time);

      await _tap(tester, 'Change my answer');
      // The sheet opens with the earlier answer and its barrier.
      await _tap(tester, 'Done');
      await _tap(tester, 'Save');
      final r = await _only(db);
      expect(r.status, ReflectionStatus.completed);
      expect(r.barrier, isNull);
    });
  });

  group('an answer is never lowered (BR-007, EQ-011)', () {
    test('which answers can follow which', () {
      expect(allowedAnswers(ReflectionStatus.unknown), {ReflectionStatus.completed, ReflectionStatus.partly, ReflectionStatus.skipped});
      expect(allowedAnswers(ReflectionStatus.skipped), {ReflectionStatus.completed, ReflectionStatus.partly, ReflectionStatus.skipped});
      expect(allowedAnswers(ReflectionStatus.partly), {ReflectionStatus.completed, ReflectionStatus.partly});
      expect(allowedAnswers(ReflectionStatus.completed), {ReflectionStatus.completed});
    });

    testWidgets('a Done answer offers only Done when changed, and its enjoyment can still be edited', (tester) async {
      final db = await _open(tester);
      await _planAndOpen(tester);
      await _tap(tester, 'Done');
      await _tap(tester, 'Save');

      await _tap(tester, 'Change my answer');
      expect(find.text('Done'), findsWidgets);
      expect(find.text('Partly'), findsNothing);
      expect(find.text('Didn’t get to it'), findsNothing);
      await _tap(tester, 'Enjoyed it');
      await _tap(tester, 'Save');
      final r = await _only(db);
      expect(r.status, ReflectionStatus.completed);
      expect(r.enjoyment, 3);
    });

    testWidgets('a Partly answer can become Done but not Didn\'t get to it', (tester) async {
      await _open(tester);
      await _planAndOpen(tester);
      await _tap(tester, 'Partly');
      await _tap(tester, 'Save');
      await _tap(tester, 'Change my answer');
      expect(find.text('Done'), findsWidgets);
      expect(find.text('Partly'), findsWidgets);
      expect(find.text('Didn’t get to it'), findsNothing);
    });

    testWidgets('a Didn\'t get to it answer can be raised to anything', (tester) async {
      final db = await _open(tester);
      await _planAndOpen(tester);
      await _tap(tester, 'Didn’t get to it');
      await _tap(tester, 'Save');
      await _tap(tester, 'Change my answer');
      for (final label in ['Done', 'Partly', 'Didn’t get to it']) {
        expect(find.text(label), findsWidgets, reason: label);
      }
      await _tap(tester, 'Done');
      await _tap(tester, 'Save');
      expect((await _only(db)).status, ReflectionStatus.completed);
    });

    testWidgets('totals and the grid do not fall when an answer is changed', (tester) async {
      final db = await _open(tester);
      await _planAndOpen(tester);
      await _tap(tester, 'Done');
      await _tap(tester, 'Save');
      final before = (await TodayRepository(db).inputs()).reflectedDays;
      expect(before, {'2026-10-23'});

      await _tap(tester, 'Change my answer');
      await _tap(tester, 'Save');
      expect((await TodayRepository(db).inputs()).reflectedDays, before);
    });
  });

  group('the sentence stays on the page, in the order of frame 2.5', () {
    testWidgets('it is still there after the app is opened again (it comes from the stored answer)', (tester) async {
      final db = await _open(tester);
      await _planAndOpen(tester);
      await _tap(tester, 'Didn’t get to it');
      await _tap(tester, 'Save');
      expect(find.text('We’ll suggest this one a little less often.'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            consentRepositoryProvider.overrideWithValue(_Agreed()),
            ...todayTestOverrides(db),
            assetReaderProvider.overrideWithValue(readAssetFile),
          ],
          child: const LiltApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('What changes next'), findsOneWidget);
      expect(find.text('We’ll suggest this one a little less often.'), findsOneWidget);
      expect(find.text('Rest counts too.'), findsWidgets);
    });

    testWidgets('Today, then Coming up, then From earlier, then Still open', (tester) async {
      final db = await _open(tester, answers: _twoActivities);
      await DriftLibraryLoader(db, readAssetFile).load();
      final action = await (db.select(db.actions)..where((t) => t.id.equals('act_walk_10'))).getSingle();
      Future<void> plan(String day, ReflectionStatus s) async {
        final item = await db.into(db.planItems).insertReturning(
              PlanItemsCompanion.insert(
                source: PlanSource.offer,
                activity: action.activity,
                title: 'Walk on $day',
                plannedDay: day,
                actionId: Value(action.id),
              ),
            );
        await db.into(db.reflections).insert(ReflectionsCompanion.insert(planItemId: item.id, status: Value(s)));
      }

      await plan('2026-10-24', ReflectionStatus.unknown);
      await plan('2026-10-22', ReflectionStatus.unknown);
      await _tap(tester, 'I’ll try this');
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      double y(String text) => tester.getTopLeft(find.text(text)).dy;
      final todayHeading = tester.getTopLeft(find.byWidgetPredicate((w) => w is Text && w.data == 'Today' && w.style?.fontSize == 16)).dy;
      expect(todayHeading, lessThan(y('Coming up')));
      expect(y('Coming up'), lessThan(y('From earlier')));
      expect(y('From earlier'), lessThan(y('Still open')));
    });
  });

  group('after saving', () {
    testWidgets('one sentence says what will change, and the rhythm card moves to the grid', (tester) async {
      await _open(tester);
      expect(find.text('This week · starts today'), findsOneWidget);
      await _planAndOpen(tester);
      await _tap(tester, 'Done');
      await _tap(tester, 'Enjoyed it');
      await _tap(tester, 'Save');
      // The sentence stays on the card (a block with a left rule), not in a snackbar that disappears.
      expect(find.text('What changes next'), findsOneWidget);
      expect(find.text('We’ll suggest this one a little more often.'), findsOneWidget);
      await tester.pump(const Duration(seconds: 10));
      expect(find.text('We’ll suggest this one a little more often.'), findsOneWidget);
      expect(find.text('Any amount counts.'), findsOneWidget, reason: 'the answered card affirms');
      expect(find.text('Your rhythm · last 12 weeks'), findsOneWidget, reason: 'the first reflected day: the grid');
    });

    testWidgets('a finished day shows today\'s plan with its answer and no pressure', (tester) async {
      await _open(tester);
      await _planAndOpen(tester);
      await _tap(tester, 'Partly');
      await _tap(tester, 'Save');
      expect(find.text('Today’s plan'), findsOneWidget);
      expect(find.text('Partly done'), findsOneWidget);
      // The tab bar also says Today, at 12 sp; the heading is the 16 sp one.
      expect(find.byWidgetPredicate((w) => w is Text && w.data == 'Today' && w.style?.fontSize == 16), findsOneWidget, reason: 'the Today heading above the card (frame 2.5)');
      expect(find.text('Partly counts.'), findsOneWidget);
      expect(find.textContaining('missed'), findsNothing);
      expect(find.textContaining('overdue'), findsNothing);
    });
  });

  group('the plan is read by the day it is planned for (UF-003)', () {
    Future<void> seedPlan(LiltDatabase db, {required String day, ReflectionStatus status = ReflectionStatus.unknown}) async {
      await DriftLibraryLoader(db, readAssetFile).load();
      final action = await (db.select(db.actions)..where((t) => t.id.equals('act_walk_10'))).getSingle();
      final item = await db.into(db.planItems).insertReturning(
            PlanItemsCompanion.insert(
              source: PlanSource.offer,
              activity: action.activity,
              title: action.title,
              plannedDay: day,
              actionId: Value(action.id),
              plannedTime: const Value('12:30'),
              durationMin: Value(action.durationMin),
            ),
          );
      await db.into(db.reflections).insert(ReflectionsCompanion.insert(planItemId: item.id, status: Value(status)));
    }

    testWidgets('something planned for tomorrow shows under "Coming up", with no button yet', (tester) async {
      await _open(tester, seed: (db) => seedPlan(db, day: '2026-10-24'));
      expect(find.text('Coming up'), findsOneWidget);
      expect(find.text('A ten-minute easy walk'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'How did it go?'), findsNothing);
      expect(find.widgetWithText(OutlinedButton, 'How did it go?'), findsNothing);
    });

    testWidgets('something from yesterday that was never answered can still be answered, quietly', (tester) async {
      final db = await _open(tester, seed: (db) => seedPlan(db, day: '2026-10-22'));
      expect(find.text('From earlier'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'How did it go?'), findsOneWidget, reason: 'a secondary, not the primary');
      expect(find.textContaining('missed'), findsNothing);
      await _tap(tester, 'How did it go?');
      await _tap(tester, 'Done');
      await _tap(tester, 'Save');
      expect((await _only(db)).status, ReflectionStatus.completed);
    });

    testWidgets('an unanswered item older than a week stops asking, and is not deleted or counted (BR-009)', (tester) async {
      final db = await _open(tester, seed: (db) => seedPlan(db, day: '2026-10-15'));
      expect(find.text('From earlier'), findsNothing);
      final inputs = await TodayRepository(db).inputs();
      expect(inputs.reflections.single.status, ReflectionStatus.unknown);
      expect(find.textContaining('missed'), findsNothing);
    });

    testWidgets('an item from 7 days ago still asks', (tester) async {
      await _open(tester, seed: (db) => seedPlan(db, day: '2026-10-16'));
      expect(find.text('From earlier'), findsOneWidget);
    });

    testWidgets('earlier items are reachable while paused, so a return from a pause can answer them', (tester) async {
      await _open(tester, seed: (db) => seedPlan(db, day: '2026-10-22'));
      await _tap(tester, 'Not today');
      await _tap(tester, 'Pause for 1 week');
      expect(find.text('Paused, resume anytime'), findsOneWidget);
      expect(find.text('From earlier'), findsOneWidget);
    });

    testWidgets('an answered item from an earlier day does not come back', (tester) async {
      await _open(tester, seed: (db) => seedPlan(db, day: '2026-10-22', status: ReflectionStatus.completed));
      expect(find.text('From earlier'), findsNothing);
    });

    testWidgets('a missing reflection is never a skip: it stays unknown and nothing changes the ranking (BR-009)',
        (tester) async {
      final db = await _open(tester, seed: (db) => seedPlan(db, day: '2026-10-20'));
      final inputs = await TodayRepository(db).inputs();
      expect(inputs.reflections.single.status, ReflectionStatus.unknown);
      expect(inputs.reflectedDays, isEmpty);
    });
  });

  group('the words (BR-001, BR-007)', () {
    test('the sentence says only what the ranking does', () {
      expect(whatChangesNext(status: ReflectionStatus.completed, enjoyment: 3), 'We’ll suggest this one a little more often.');
      expect(whatChangesNext(status: ReflectionStatus.completed), 'We’ll suggest this one a little more often.');
      // A rating of 1 or 2 adds nothing to the score (EQ-003), so no change is promised.
      expect(whatChangesNext(status: ReflectionStatus.completed, enjoyment: 1), 'Thanks for telling us.');
      expect(whatChangesNext(status: ReflectionStatus.completed, enjoyment: 2), 'Thanks for telling us.');
      expect(whatChangesNext(status: ReflectionStatus.partly), 'Partly counts.');
      expect(whatChangesNext(status: ReflectionStatus.partly, enjoyment: 3), 'Partly counts, and you enjoyed it.');
      expect(whatChangesNext(status: ReflectionStatus.skipped), 'We’ll suggest this one a little less often.');
      // A barrier promises nothing: observations are not shown yet, and EQ-009 counts barriers only on skipped.
      for (final b in Barrier.values) {
        expect(whatChangesNext(status: ReflectionStatus.partly, barrier: b), isNot(contains('point it out')));
        expect(whatChangesNext(status: ReflectionStatus.skipped, barrier: b), isNot(contains('point it out')));
      }
    });

    test('every sentence and label avoids the never-use list and the blocked claims', () async {
      final claims = parseBlockedClaims(await readAssetFile(LibraryAssets.blockedClaims));
      final texts = <String>[
        for (final c in reflectionChoices) c.label,
        for (final (_, label) in barrierChoices) label,
        for (final (_, label) in enjoymentChoices) label,
        for (final s in ReflectionStatus.values) statusLabel(s),
        for (final s in ReflectionStatus.values)
          for (final e in [null, 1, 2, 3])
            for (final b in [null, ...Barrier.values]) whatChangesNext(status: s, enjoyment: e, barrier: b),
      ];
      for (final text in texts) {
        for (final term in [...claims.terms, ...neverUse]) {
          expect(RegExp('\\b${RegExp.escape(term)}\\b', caseSensitive: false).hasMatch(text), isFalse,
              reason: '"$text" has "$term"');
        }
      }
    });

    test('the codes are the ones in docs/data-model.md §7', () {
      expect(barrierChoices.map((b) => b.$1.code), ['time', 'low_energy', 'schedule', 'weather', 'other', 'prefer_not_to_say']);
      expect(enjoymentChoices.map((e) => e.$1), [1, 2, 3]);
      expect(reflectionChoices.map((c) => c.status.code), ['completed', 'partly', 'skipped']);
    });
  });

  group('TC-044 and TC-045 on the sheet', () {
    for (final scale in [1.0, 2.0]) {
      for (final size in [const Size(360, 800), const Size(320, 568)]) {
        testWidgets('${(scale * 100).round()}% text on ${size.width.toInt()}x${size.height.toInt()}', (tester) async {
          final handle = tester.ensureSemantics();
          await _open(tester, size: size, textScale: scale);
          await _planAndOpen(tester);
          Future<void> check(String where) async {
            expect(tester.takeException(), isNull, reason: where);
            await expectLater(tester, meetsGuideline(androidTapTargetGuideline), reason: where);
            await expectLater(tester, meetsGuideline(labeledTapTargetGuideline), reason: where);
          }

          await expectLater(tester, meetsGuideline(textContrastGuideline));
          await check('three answers');
          await _tap(tester, 'Partly');
          await check('partly: barrier and enjoyment');
          // Save stays reachable (pinned footer) at any size.
          expect(tester.getRect(find.widgetWithText(FilledButton, 'Save')).bottom, lessThanOrEqualTo(size.height));
          handle.dispose();
        });
      }
    }
  });
}

