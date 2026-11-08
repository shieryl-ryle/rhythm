import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lilt/app/app.dart';
import 'package:lilt/data/consent_repository.dart';
import 'package:lilt/data/database.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/data/library/library_loader.dart';
import 'package:lilt/data/providers.dart';
import 'package:lilt/domain/lapse.dart';
import 'package:lilt/features/today/today_repository.dart';
import 'package:lilt/domain/models.dart';
import 'package:lilt/features/starting_point/setup_model.dart';
import 'package:lilt/features/starting_point/setup_repository.dart';
import 'package:lilt/features/support/support_providers.dart';
import 'package:lilt/features/way_back/way_back_logic.dart';

import '../support/test_support.dart';

/// S-005 My Way Back (F-005, UF-004), the banner on Today and the return it leads to (EQ-011). "Today" is Friday
/// 23 October 2026, 09:00; the person walked on 15 and 16 October and not since, so a lapse began on the 17th.
class _Agreed implements ConsentRepository {
  @override
  Future<bool> hasAgreed() async => true;

  @override
  Future<void> agree() async {}
}

const _walker = SetupAnswers(
  paths: {SetupPath.keepGoing, SetupPath.addNew},
  keepActivity: ActivityKind.gym,
  progress: Progress.goingWell,
  addNewActivity: ActivityKind.walking,
  freeTimes: {'lunch'},
  access: {'gym_membership'},
);

ActionInfo _action(String id, ActivityKind activity, {bool starter = false}) => ActionInfo(
  id: id,
  activity: activity,
  title: id,
  durationMin: 10,
  energyNeeded: Energy.low,
  tags: const {},
  isStarter: starter,
  similarTo: const [],
  libraryVersion: '1',
);

ReflectionRecord _done(String day, ActivityKind activity) =>
    ReflectionRecord(day: day, activity: activity, status: ReflectionStatus.completed);

Future<void> _walked(LiltDatabase db, String day, ReflectionStatus status) async {
  final item = await db
      .into(db.planItems)
      .insertReturning(
        PlanItemsCompanion.insert(
          source: PlanSource.offer,
          activity: ActivityKind.walking,
          title: 'A ten-minute easy walk',
          plannedDay: day,
          actionId: const Value('act_walk_10'),
        ),
      );
  await db.into(db.reflections).insert(ReflectionsCompanion.insert(planItemId: item.id, status: Value(status)));
}

Future<LiltDatabase> _open(
  WidgetTester tester, {
  Future<void> Function(LiltDatabase db)? seed,
  double textScale = 1,
}) async {
  tester.view.physicalSize = const Size(360, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final db = inMemoryDatabase();
  addTearDown(db.close);
  await DriftSetupRepository(db).save(_walker);
  await DriftLibraryLoader(db, readAssetFile).load();
  await seed?.call(db);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        consentRepositoryProvider.overrideWithValue(_Agreed()),
        ...todayTestOverrides(db),
        assetReaderProvider.overrideWithValue(readAssetFile),
      ],
      child: MediaQuery(
        data: MediaQueryData(size: const Size(360, 800), textScaler: TextScaler.linear(textScale)),
        child: const LiltApp(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return db;
}

Future<void> _lapsed(LiltDatabase db) async {
  await _walked(db, '2026-10-15', ReflectionStatus.completed);
  await _walked(db, '2026-10-16', ReflectionStatus.completed);
}

Future<void> _tap(WidgetTester tester, String text) async {
  final finder = find.text(text).first;
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  group('what changed (frame 4.1)', () {
    test('"Prefer not to say" is exclusive in both directions', () {
      var picked = toggleWhatChanged({}, 'moved');
      picked = toggleWhatChanged(picked, 'busier');
      expect(picked, {'moved', 'busier'});
      picked = toggleWhatChanged(picked, preferNotToSay);
      expect(picked, {preferNotToSay}, reason: 'picking it clears the others');
      picked = toggleWhatChanged(picked, 'moved');
      expect(picked, {'moved'}, reason: 'picking another clears it');
      expect(toggleWhatChanged(picked, 'moved'), isEmpty, reason: 'a second tap un-picks');
    });

    test('a skipped question stores nothing, and answers are stored as a sorted comma set', () {
      expect(const WayBackAnswers(whatChanged: {}, approach: ReturnApproach.previous).whatChangedCsv, isNull);
      expect(
        const WayBackAnswers(whatChanged: {'moved', 'busier'}, approach: ReturnApproach.different).whatChangedCsv,
        'busier,moved',
      );
    });
  });

  group('the pool a way back draws from (UF-004)', () {
    final actions = [
      _action('walk', ActivityKind.walking, starter: true),
      _action('swim', ActivityKind.swimming),
      _action('gym_starter', ActivityKind.gym, starter: true),
    ];

    test('"Go back to what helped" offers only activities the person has done', () {
      final pool = wayBackPool(
        actions: actions,
        reflections: [_done('2026-10-15', ActivityKind.walking)],
        wanted: ReturnApproach.previous,
      );
      expect(pool.approach, ReturnApproach.previous);
      expect([for (final a in pool.actions) a.id], ['walk']);
    });

    test('with nothing done before it falls back to the starters, and says so', () {
      final pool = wayBackPool(actions: actions, reflections: const [], wanted: ReturnApproach.previous);
      expect(pool.approach, ReturnApproach.starter);
      expect([for (final a in pool.actions) a.id], ['walk', 'gym_starter']);
    });

    test('"Try something different" leaves out the activity done most recently', () {
      final pool = wayBackPool(
        actions: actions,
        reflections: [_done('2026-10-10', ActivityKind.gym), _done('2026-10-15', ActivityKind.walking)],
        wanted: ReturnApproach.different,
      );
      expect(pool.approach, ReturnApproach.different);
      expect([for (final a in pool.actions) a.id], ['swim', 'gym_starter']);
    });

    test('a "partly" day counts as done before; an unanswered one does not', () {
      final previous = previousActivities([
        const ReflectionRecord(day: '2026-10-15', activity: ActivityKind.walking, status: ReflectionStatus.partly),
        const ReflectionRecord(day: '2026-10-16', activity: ActivityKind.gym, status: ReflectionStatus.unknown),
      ]);
      expect(previous, [ActivityKind.walking]);
    });
  });

  group('the welcome-back banner on Today (frame 2.9)', () {
    testWidgets('appears after a lapse, offers My Way Back, and shows no loss wording', (tester) async {
      await _open(tester, seed: _lapsed);
      expect(find.text('Welcome back. Want help picking a gentle first step?'), findsOneWidget);
      expect(find.text('Find my way back'), findsOneWidget);
      expect(find.text('Not now'), findsOneWidget);
      expect(find.textContaining(RegExp('streak|lost|broke|missed|failed', caseSensitive: false)), findsNothing);
    });

    testWidgets('is not shown to someone with no lapse, or on a first day', (tester) async {
      await _open(tester);
      expect(find.text('Find my way back'), findsNothing);
    });

    testWidgets('"Not now" costs nothing: the banner goes, nothing is planned or recorded', (tester) async {
      final db = await _open(tester, seed: _lapsed);
      await _tap(tester, 'Not now');
      expect(find.text('Find my way back'), findsNothing);
      expect(await db.select(db.planItems).get(), hasLength(2), reason: 'only the two seeded days');
      expect(await db.select(db.returnEvents).get(), isEmpty);
    });

    testWidgets('is not shown while paused', (tester) async {
      await _open(
        tester,
        seed: (db) async {
          await _lapsed(db);
          await db
              .into(db.pauses)
              .insert(
                PausesCompanion.insert(
                  kind: PauseKind.pause,
                  startDay: '2026-10-23',
                  endDay: const Value('2026-10-30'),
                ),
              );
        },
      );
      expect(find.text('Find my way back'), findsNothing);
    });
  });

  group('the three steps', () {
    testWidgets('what changed, what to try, then one small first step that waits on Today (BR-005)', (tester) async {
      final db = await _open(tester, seed: _lapsed);
      await _tap(tester, 'Find my way back');
      expect(find.text('What changed?'), findsOneWidget);
      expect(find.bySemanticsLabel('Step 1 of 3'), findsOneWidget);
      await _tap(tester, 'Moved or travelling');
      await _tap(tester, 'Next');
      expect(find.text('What would you like to try?'), findsOneWidget);
      expect(find.text('Walking'), findsOneWidget, reason: 'what helped before is named');
      await _tap(tester, 'Show me a small first step');
      expect(find.text('A small first step'), findsOneWidget);
      expect(find.textContaining('Nothing is planned until you choose it'), findsOneWidget);
      final planBefore = await db.select(db.planItems).get();
      await _tap(tester, 'Go to Today');
      expect(find.text('I’ll try this'), findsWidgets, reason: 'the step is on Today for the person to choose');
      expect(find.text('Find my way back'), findsNothing, reason: 'the banner has done its job for this lapse');
      expect(await db.select(db.planItems).get(), hasLength(planBefore.length), reason: 'nothing planned (BR-005)');
    });

    testWidgets('Skip answers nothing, and "Prefer not to say" is stored as its own answer', (tester) async {
      await _open(tester, seed: _lapsed);
      await _tap(tester, 'Find my way back');
      expect(
        tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Next')).onPressed,
        isNull,
        reason: 'Next waits for an answer; Skip is the way to say nothing',
      );
      await _tap(tester, 'Skip');
      expect(find.text('What would you like to try?'), findsOneWidget);
    });

    testWidgets('"Pause for a week instead" pauses and goes to the paused Today', (tester) async {
      final db = await _open(tester, seed: _lapsed);
      await _tap(tester, 'Find my way back');
      await _tap(tester, 'Skip');
      await _tap(tester, 'Pause for a week instead');
      expect(find.text('Paused, resume anytime'), findsOneWidget);
      expect((await db.select(db.pauses).get()).single.kind, PauseKind.pause);
    });

    testWidgets('My rhythm has the same way in: "Returning after a break?"', (tester) async {
      await _open(tester, seed: _lapsed);
      await _tap(tester, 'My rhythm');
      await _tap(tester, 'Returning after a break?');
      expect(find.text('What changed?'), findsOneWidget);
    });
  });

  group('the return (EQ-011)', () {
    testWidgets('the first reflected day after the lapse records one return, with the answers given', (tester) async {
      final db = await _open(tester, seed: _lapsed);
      await _tap(tester, 'Find my way back');
      await _tap(tester, 'Moved or travelling');
      await _tap(tester, 'Busier at work or study');
      await _tap(tester, 'Next');
      await _tap(tester, 'Show me a small first step');
      await _tap(tester, 'Go to Today');
      expect(await db.select(db.returnEvents).get(), isEmpty, reason: 'a return needs a reflected day');

      await _tap(tester, 'I’ll try this');
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      await _tap(tester, 'How did it go?');
      await _tap(tester, 'Done');
      await _tap(tester, 'Save');

      final returns = await db.select(db.returnEvents).get();
      expect(returns, hasLength(1));
      expect(returns.single.lapseStartDay, '2026-10-17');
      expect(returns.single.returnDay, '2026-10-23');
      expect(returns.single.whatChanged, 'busier,moved');
      expect(returns.single.approach, ReturnApproach.previous);
    });

    testWidgets('a return without My Way Back is still recorded, with no answers (they are optional, BR-008)', (
      tester,
    ) async {
      final db = await _open(tester, seed: _lapsed);
      await _tap(tester, 'I’ll try this');
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      await _tap(tester, 'How did it go?');
      await _tap(tester, 'Partly');
      await _tap(tester, 'Time');
      await _tap(tester, 'Save');
      final returns = await db.select(db.returnEvents).get();
      expect(returns, hasLength(1));
      expect(returns.single.whatChanged, isNull);
      expect(returns.single.approach, isNull);
    });

    testWidgets('recording is idempotent: a second look at Today adds no second return, and totals only go up', (
      tester,
    ) async {
      final db = await _open(tester, seed: _lapsed);
      await _tap(tester, 'I’ll try this');
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      await _tap(tester, 'How did it go?');
      await _tap(tester, 'Done');
      await _tap(tester, 'Save');
      await _tap(tester, 'My rhythm');
      await _tap(tester, 'Today');
      expect(await db.select(db.returnEvents).get(), hasLength(1));
      await _tap(tester, 'My rhythm');
      expect(find.textContaining('Came back 1 time after a break.'), findsOneWidget);
    });
  });

  group('what the rules review found (BR-017, BR-011, BR-007)', () {
    test('delete-all clears the answers waiting for a return', () async {
      final container = ProviderContainer(overrides: [consentRepositoryProvider.overrideWithValue(_Agreed())]);
      addTearDown(container.dispose);
      await container.read(consentProvider.future);
      container.read(wayBackAnswersProvider.notifier).state = const WayBackAnswers(
        whatChanged: {'moved'},
        approach: ReturnApproach.previous,
        lapseStartDay: '2026-10-17',
      );
      container.invalidate(consentProvider); // what delete-all does
      expect(container.read(wayBackAnswersProvider), isNull);
    });

    test('an activity the person left out is never part of the pool', () {
      final pool = wayBackPool(
        actions: [_action('swim', ActivityKind.swimming), _action('walk', ActivityKind.walking, starter: true)],
        reflections: [_done('2026-10-15', ActivityKind.swimming)],
        wanted: ReturnApproach.previous,
        excluded: {ActivityKind.swimming.code},
      );
      expect(pool.approach, ReturnApproach.starter, reason: 'what helped was left out, so it falls back to starters');
      expect([for (final a in pool.actions) a.id], ['walk']);
    });

    test('recording the same return twice writes one row', () async {
      final db = inMemoryDatabase();
      addTearDown(db.close);
      final repo = TodayRepository(db);
      const span = LapseSpan(startDay: '2026-10-17', returnDay: '2026-10-23');
      await Future.wait([
        repo.recordReturns([span]),
        repo.recordReturns([span]),
      ]);
      expect(await db.select(db.returnEvents).get(), hasLength(1));
    });

    testWidgets('answers given when no lapse is open are not kept for a later one', (tester) async {
      await _open(tester, seed: (db) => _walked(db, '2026-10-22', ReflectionStatus.completed));
      await _tap(tester, 'My rhythm');
      await _tap(tester, 'Returning after a break?');
      await _tap(tester, 'Moved or travelling');
      await _tap(tester, 'Next');
      await _tap(tester, 'Show me a small first step');
      final container = ProviderScope.containerOf(tester.element(find.byType(LiltApp)));
      expect(container.read(wayBackAnswersProvider), isNull, reason: 'there is no return to put them on');
    });

    testWidgets('the first step shows its reason, and a leave-out is not named on step 2', (tester) async {
      await _open(
        tester,
        seed: (db) async {
          await _lapsed(db);
          await db
              .into(db.preferences)
              .insert(PreferencesCompanion.insert(kind: PrefKind.excluded, value: ActivityKind.walking.code));
        },
      );
      await _tap(tester, 'Find my way back');
      await _tap(tester, 'Skip');
      expect(find.text('Walking'), findsNothing, reason: 'walking was left out (BR-011)');
      await _tap(tester, 'Show me a small first step');
      expect(find.text('A small first step'), findsOneWidget);
      final reasons = await ProviderScope.containerOf(tester.element(find.byType(LiltApp)))
          .read(databaseProvider)
          .select(ProviderScope.containerOf(tester.element(find.byType(LiltApp))).read(databaseProvider).offerReasons)
          .get();
      expect(reasons, isNotEmpty);
      expect(find.text(reasons.first.reasonText), findsWidgets, reason: 'BR-004: the step says why');
    });
  });

  group('the other paths through S-005 (TC-005, TC-015, TC-044, TC-045)', () {
    final loss = RegExp('streak|lost|broke|missed|failed|behind|guilt', caseSensitive: false);

    testWidgets('"Try something different" is kept as the approach, and the first step is not the last activity', (
      tester,
    ) async {
      await _open(tester, seed: _lapsed);
      await _tap(tester, 'Find my way back');
      await _tap(tester, 'Skip');
      await _tap(tester, 'Try something different');
      await _tap(tester, 'Show me a small first step');
      final container = ProviderScope.containerOf(tester.element(find.byType(LiltApp)));
      expect(container.read(wayBackAnswersProvider)!.approach, ReturnApproach.different);
      expect(find.textContaining('walk', findRichText: true), findsNothing, reason: 'walking was the last activity');
      expect(find.textContaining('Walk'), findsNothing, reason: 'nor a capitalised walking title or label');
    });

    testWidgets('"Prefer not to say" is stored as its own answer, and clears the others', (tester) async {
      await _open(tester, seed: _lapsed);
      await _tap(tester, 'Find my way back');
      await _tap(tester, 'Moved or travelling');
      await _tap(tester, 'Prefer not to say');
      await _tap(tester, 'Next');
      await _tap(tester, 'Show me a small first step');
      final container = ProviderScope.containerOf(tester.element(find.byType(LiltApp)));
      expect(container.read(wayBackAnswersProvider)!.whatChangedCsv, preferNotToSay);
    });

    testWidgets('with nothing done before, step 2 says it will start with a gentle starter (EV-005)', (tester) async {
      await _open(tester);
      GoRouter.of(tester.element(find.byType(Scaffold).first)).push<void>('/way-back');
      await tester.pumpAndSettle();
      await _tap(tester, 'Skip');
      expect(find.text('Nothing logged yet, so we’ll start with a gentle starter.'), findsOneWidget);
    });

    testWidgets('no step or card uses loss wording (BR-007)', (tester) async {
      await _open(tester, seed: _lapsed);
      await _tap(tester, 'Find my way back');
      expect(find.textContaining(loss), findsNothing);
      await _tap(tester, 'Skip');
      expect(find.textContaining(loss), findsNothing);
      await _tap(tester, 'Show me a small first step');
      expect(find.textContaining(loss), findsNothing);
    });

    for (final scale in [1.0, 2.0]) {
      testWidgets('the banner and all three steps keep 48 dp targets and readable labels at ${scale * 100}% text', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        await _open(tester, seed: _lapsed, textScale: scale);
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await _tap(tester, 'Find my way back');
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await _tap(tester, 'Skip');
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await _tap(tester, 'Show me a small first step');
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        expect(tester.takeException(), isNull, reason: 'no overflow at this size');
        handle.dispose();
      });
    }
  });
}
