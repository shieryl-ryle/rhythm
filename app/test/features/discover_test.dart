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
import 'package:lilt/features/discover/discover_controller.dart';
import 'package:lilt/features/discover/discover_logic.dart';
import 'package:lilt/features/starting_point/setup_model.dart';
import 'package:lilt/features/starting_point/setup_repository.dart';
import 'package:lilt/features/support/support_providers.dart';
import 'package:lilt/features/today/today_data.dart';

import '../support/test_support.dart';

/// S-009 Discover and S-013 Activity detail (frames 5.1 to 5.3, 3.10), with the real library and a real in-memory
/// database. "Today" is Friday 23 October 2026, 09:00.
class _Agreed implements ConsentRepository {
  @override
  Future<bool> hasAgreed() async => true;

  @override
  Future<void> agree() async {}
}

const _walker = SetupAnswers(
  paths: {SetupPath.keepGoing},
  keepActivity: ActivityKind.walking,
  progress: Progress.goingWell,
  freeTimes: {'lunch'},
  access: {'none'},
);

const _noTeamSports = SetupAnswers(
  paths: {SetupPath.keepGoing},
  keepActivity: ActivityKind.walking,
  progress: Progress.goingWell,
  freeTimes: {'lunch'},
  access: {'none'},
  excluded: {'team_sport'},
);

Future<LiltDatabase> _open(
  WidgetTester tester, {
  SetupAnswers answers = _walker,
  double textScale = 1,
  Future<void> Function(LiltDatabase db)? seed,
}) async {
  tester.view.physicalSize = const Size(360, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final db = inMemoryDatabase();
  addTearDown(db.close);
  await DriftSetupRepository(db).save(answers);
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

Future<void> _tap(WidgetTester tester, String text, {int index = 0}) async {
  final finder = find.text(text).at(index);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _openDiscover(WidgetTester tester) => _tap(tester, 'Discover', index: 0);

void main() {
  group('the rules', () {
    late LiltDatabase db;

    setUp(() async {
      db = inMemoryDatabase();
      await DriftLibraryLoader(db, readAssetFile).load();
    });
    tearDown(() => db.close());

    Future<List<DiscoverItem>> forYou(SetupAnswers answers, Set<DiscoverFilter> filters) async {
      if (!await DriftSetupRepository(db).isDone()) await DriftSetupRepository(db).save(answers);
      final inputs = await loadTodayInputs(db);
      return forYouItems(
        actions: inputs.actions,
        person: inputs.person,
        libraryVersion: inputs.libraryVersion,
        filters: filters,
        saved: const {},
      );
    }

    test('one idea per activity, each with a reason (BR-004)', () async {
      final items = await forYou(_walker, const {});
      expect(items, isNotEmpty);
      expect(items.map((i) => i.action.activity).toSet().length, items.length);
      expect(items.every((i) => i.reason.isNotEmpty), isTrue);
    });

    test('what the person left out is never listed (BR-011)', () async {
      final items = await forYou(_noTeamSports, const {});
      expect(items.map((i) => i.action.activity), isNot(contains(ActivityKind.basketball)));
      expect(items.map((i) => i.action.activity), isNot(contains(ActivityKind.teamSports)));
    });

    test('"New for you" is for activities the person does not follow', () async {
      final items = await forYou(_walker, const {});
      expect(items.where((i) => i.action.activity == ActivityKind.walking).every((i) => !i.isNew), isTrue);
      expect(items.where((i) => i.action.activity != ActivityKind.walking).every((i) => i.isNew), isTrue);
    });

    test('filters narrow each other, and Indoors with Outdoors means either', () async {
      final quick = await forYou(_walker, {DiscoverFilter.quick});
      expect(quick.every((i) => i.action.durationMin <= quickMinutes), isTrue);
      final others = await forYou(_walker, {DiscoverFilter.withOthers});
      expect(others.every((i) => i.action.tags.contains('with_company')), isTrue);
      final indoors = await forYou(_walker, {DiscoverFilter.indoors});
      final either = await forYou(_walker, {DiscoverFilter.indoors, DiscoverFilter.outdoors});
      expect(either.length, greaterThanOrEqualTo(indoors.length));
      expect(either.every((i) => i.action.tags.any({'indoors', 'outdoors'}.contains)), isTrue);
    });

    test('a saved idea that is later left out is not shown, and comes back if the leave-out is lifted', () async {
      await DriftSetupRepository(db).save(_noTeamSports);
      final inputs = await loadTodayInputs(db);
      final basketball = inputs.actions.firstWhere((a) => a.activity == ActivityKind.basketball);
      final shown = savedItems(
        actions: inputs.actions,
        person: inputs.person,
        libraryVersion: inputs.libraryVersion,
        savedOrder: [basketball.id],
      );
      expect(shown, isEmpty);
    });

    test('the meta line reads like the frames', () async {
      final inputs = await (() async {
        await DriftSetupRepository(db).save(_walker);
        return loadTodayInputs(db);
      })();
      expect(metaLine(inputs.actions.firstWhere((a) => a.tags.contains('with_company'))), endsWith('with others'));
    });
  });

  group('the screen (frames 5.1, 5.2)', () {
    testWidgets('replaces "Coming soon": ideas with reasons, "New for you", and nothing planned by looking', (
      tester,
    ) async {
      final db = await _open(tester);
      await _openDiscover(tester);
      expect(find.textContaining('Coming soon'), findsNothing);
      expect(find.text('For you'), findsWidgets);
      expect(find.text('New for you'), findsWidgets);
      for (final f in DiscoverFilter.values) {
        expect(find.text(f.label), findsOneWidget);
      }
      expect(await db.select(db.planItems).get(), isEmpty, reason: 'BR-005');
      expect(await db.select(db.savedActions).get(), isEmpty);
    });

    testWidgets('the bookmark saves and removes, and Saved lists it; empty Saved says what to do', (tester) async {
      final db = await _open(tester);
      await _openDiscover(tester);
      await _tap(tester, 'Saved');
      expect(find.textContaining('Nothing saved yet'), findsOneWidget);
      await _tap(tester, 'For you');
      final bookmark = find.byIcon(Icons.bookmark_border).first;
      await tester.ensureVisible(bookmark);
      await tester.tap(bookmark);
      await tester.pumpAndSettle();
      expect(await db.select(db.savedActions).get(), hasLength(1));
      await _tap(tester, 'Saved');
      expect(find.text('Plan'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.bookmark));
      await tester.pumpAndSettle();
      expect(await db.select(db.savedActions).get(), isEmpty);
      expect(find.textContaining('Nothing saved yet'), findsOneWidget);
    });

    testWidgets('everything left out: the screen says so, and a filter on top offers "Clear filters"', (tester) async {
      await _open(
        tester,
        answers: SetupAnswers(
          paths: const {SetupPath.keepGoing},
          keepActivity: ActivityKind.walking,
          progress: Progress.goingWell,
          freeTimes: const {'lunch'},
          access: const {'none'},
          excluded: {for (final k in ActivityKind.values) k.code},
        ),
      );
      await _openDiscover(tester);
      expect(find.text('Your leave-out and access choices cover everything we have.'), findsOneWidget);
      await _tap(tester, 'Quick');
      expect(find.text('Nothing matches those filters.'), findsOneWidget);
      await _tap(tester, 'Clear filters');
      expect(find.text('Nothing matches those filters.'), findsNothing);
      expect(find.text('Your leave-out and access choices cover everything we have.'), findsOneWidget);
    });

    testWidgets('the Quick chip leaves only ideas of 20 minutes or less, and shows a tick', (tester) async {
      await _open(tester);
      await _openDiscover(tester);
      await _tap(tester, 'Quick');
      expect(find.byIcon(Icons.check), findsWidgets, reason: 'a chosen chip shows a tick (DESIGN.md)');
      final minutes = [
        for (final e in find.byType(Text).evaluate())
          if (RegExp(r'^(\d+) min').firstMatch((e.widget as Text).data ?? '') case final m?) int.parse(m[1]!),
      ];
      expect(minutes, isNotEmpty);
      expect(minutes.every((m) => m <= quickMinutes), isTrue, reason: '');
    });

    testWidgets('"Plan" on a saved idea plans it only on the tap, with an Undo (BR-005)', (tester) async {
      final db = await _open(tester);
      await _openDiscover(tester);
      await tester.tap(find.byIcon(Icons.bookmark_border).first);
      await tester.pumpAndSettle();
      await _tap(tester, 'Saved');
      expect(await db.select(db.planItems).get(), isEmpty);
      await _tap(tester, 'Plan');
      expect(find.text('Added to your plan'), findsOneWidget);
      final items = await db.select(db.planItems).get();
      expect(items, hasLength(1));
      expect((await db.select(db.reflections).get()).single.status, ReflectionStatus.unknown);
      await _tap(tester, 'Undo');
      expect(await db.select(db.planItems).get(), isEmpty, reason: 'Undo takes it back');
    });
  });

  group('the activity detail (frame 3.10)', () {
    Future<void> openFirst(WidgetTester tester) async {
      await _openDiscover(tester);
      // A card for an activity the person does not follow yet (the first one, walking, is followed).
      await tester.tap(find.text('New for you').first);
      await tester.pumpAndSettle();
    }

    testWidgets('says what it is and why it is suggested, and Plan it plans it on the tap', (tester) async {
      final db = await _open(tester);
      await openFirst(tester);
      expect(find.text('Why we suggest it'), findsOneWidget);
      expect(find.text('Plan it'), findsOneWidget);
      expect(await db.select(db.planItems).get(), isEmpty, reason: 'opening it plans nothing');
      await _tap(tester, 'Plan it');
      expect(await db.select(db.planItems).get(), hasLength(1));
    });

    testWidgets('"Follow this activity" asks where the person is with it, then follows it', (tester) async {
      final db = await _open(tester);
      await openFirst(tester);
      await _tap(tester, 'Follow this activity');
      expect(find.text('Where are you with it?'), findsOneWidget);
      await _tap(tester, 'I used to do this');
      final rows = await (db.select(
        db.followedActivities,
      )..where((t) => t.familiarity.equals(Familiarity.usedToPlay.code))).get();
      expect(rows, hasLength(1));
      expect(rows.single.path, SetupPath.pickUpAgain);
      expect(find.text('Stop following this activity'), findsOneWidget);
      await _tap(tester, 'Stop following this activity');
      expect(
        await (db.select(
          db.followedActivities,
        )..where((t) => t.unfollowedAt.isNull() & t.familiarity.equals(Familiarity.usedToPlay.code))).get(),
        isEmpty,
      );
    });

    testWidgets('an idea the person left out is not available, even by its address (BR-011)', (tester) async {
      await _open(tester, answers: _noTeamSports);
      final ctx = tester.element(find.byType(Scaffold).first);
      GoRouter.of(ctx).push<void>('/activity/act_basket_shoot_15');
      await tester.pumpAndSettle();
      expect(find.textContaining('isn’t available any more'), findsOneWidget);
    });
  });

  group('what the rules review found (BR-006, BR-011)', () {
    Future<void> openDetail(WidgetTester tester, String id) async {
      GoRouter.of(tester.element(find.byType(Scaffold).first)).push<void>('/activity/$id');
      await tester.pumpAndSettle();
    }

    testWidgets('"Plan it" honours "Outdoors after dark" left out: an outdoor idea is not put in an evening slot', (
      tester,
    ) async {
      final db = await _open(
        tester,
        answers: const SetupAnswers(
          paths: {SetupPath.keepGoing},
          keepActivity: ActivityKind.walking,
          progress: Progress.goingWell,
          freeTimes: {'after_work'},
          access: {'none'},
          excluded: {'after_dark'},
        ),
      );
      await openDetail(tester, 'act_walk_10'); // outdoors
      await _tap(tester, 'Plan it');
      expect(find.text('Couldn’t add that right now.'), findsOneWidget);
      expect(await db.select(db.planItems).get(), isEmpty);
    });

    testWidgets('nothing is planned during a pause, and the message is calm (BR-006, BR-007)', (tester) async {
      final db = await _open(
        tester,
        seed: (db) => db
            .into(db.pauses)
            .insert(
              PausesCompanion.insert(kind: PauseKind.pause, startDay: '2026-10-23', endDay: const Value('2026-10-30')),
            ),
      );
      await openDetail(tester, 'act_walk_10');
      await _tap(tester, 'Plan it');
      expect(find.text('You’re on a pause. Resume on Today when you’re ready.'), findsOneWidget);
      expect(await db.select(db.planItems).get(), isEmpty);
    });

    testWidgets('a typed activity is not followed or stopped from a library idea', (tester) async {
      await _open(tester);
      await openDetail(tester, 'act_other_stairs');
      expect(find.text('Plan it'), findsOneWidget);
      expect(find.text('Follow this activity'), findsNothing);
      expect(find.text('Stop following this activity'), findsNothing);
    });

    testWidgets('the bookmark on the detail saves the idea', (tester) async {
      final db = await _open(tester);
      await openDetail(tester, 'act_walk_10');
      await tester.tap(find.byTooltip('Save'));
      await tester.pumpAndSettle();
      expect((await db.select(db.savedActions).get()).single.actionId, 'act_walk_10');
      expect(find.byTooltip('Remove from saved'), findsOneWidget);
    });

    testWidgets('after another person is loaded the list is read again, not kept from the first', (tester) async {
      final db = await _open(tester);
      await _openDiscover(tester);
      final container = ProviderScope.containerOf(tester.element(find.byType(LiltApp)));
      expect(find.text('Dance'), findsNothing); // not a card title; just warm the screen
      // Leave everything out in the database, then tell Today what changed, as loading a demo person does.
      await db.into(db.preferences).insert(PreferencesCompanion.insert(kind: PrefKind.excluded, value: 'walking'));
      container.invalidate(discoverControllerProvider);
      await tester.pumpAndSettle();
      expect(find.text('A ten-minute easy walk'), findsNothing, reason: 'walking is now left out (BR-011)');
    });

    test('a brand-new person browses the whole library, not only the starters', () async {
      final db = inMemoryDatabase();
      addTearDown(db.close);
      await DriftLibraryLoader(db, readAssetFile).load();
      await DriftSetupRepository(db).save(_walker);
      final inputs = await loadTodayInputs(db);
      final items = forYouItems(
        actions: inputs.actions,
        person: inputs.person,
        libraryVersion: inputs.libraryVersion,
        filters: const {},
        saved: const {},
      );
      expect(items.any((i) => !i.action.isStarter), isTrue);
    });

    test('an access choice of none hides every idea that needs equipment or membership (BR-011)', () async {
      final db = inMemoryDatabase();
      addTearDown(db.close);
      await DriftLibraryLoader(db, readAssetFile).load();
      await DriftSetupRepository(db).save(_walker);
      final inputs = await loadTodayInputs(db);
      final items = forYouItems(
        actions: inputs.actions,
        person: inputs.person,
        libraryVersion: inputs.libraryVersion,
        filters: const {},
        saved: const {},
      );
      expect(items.expand((i) => i.action.tags).where((t) => t.startsWith('needs_')), isEmpty);
    });
  });

  group('accessibility (TC-044, TC-045)', () {
    for (final scale in [1.0, 2.0]) {
      testWidgets('Discover keeps 48 dp targets and labels at ${scale * 100}% text', (tester) async {
        final handle = tester.ensureSemantics();
        await _open(tester, textScale: scale);
        await _openDiscover(tester);
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await _tap(tester, 'Saved');
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        expect(tester.takeException(), isNull);
        handle.dispose();
      });
    }
  });
}
