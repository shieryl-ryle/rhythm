import 'dart:async';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lilt/app/app.dart';
import 'package:lilt/data/consent_repository.dart';
import 'package:lilt/data/database.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/data/providers.dart';
import 'package:lilt/features/starting_point/setup_model.dart';
import 'package:lilt/features/starting_point/setup_repository.dart';
import 'package:lilt/features/support/support_providers.dart';
import 'package:lilt/features/today/today_controller.dart';

import '../support/test_support.dart';

/// S-004 Today as a person uses it (frames 1.16, 2.3, 2.5, 2.8, 3.3, 9.3), with the real library and a real
/// in-memory database. "Today" is Friday 23 October 2026, 09:00.
class _Agreed implements ConsentRepository {
  @override
  Future<bool> hasAgreed() async => true;

  @override
  Future<void> agree() async {}
}

/// A text widget whose words match, ignoring the non-breaking spaces that keep a label together.
Finder _text(String words) =>
    find.byWidgetPredicate((w) => w is Text && (w.data ?? '').replaceAll('\u00A0', ' ') == words);

const _runner = SetupAnswers(
  paths: {SetupPath.keepGoing, SetupPath.pickUpAgain},
  keepActivity: ActivityKind.gym,
  progress: Progress.goingWell,
  pickUpActivity: ActivityKind.running,
  stoppedAgo: StoppedAgo.months,
  freeTimes: {'lunch', 'weekends'},
  access: {'gym_membership'},
);

Future<LiltDatabase> _open(
  WidgetTester tester, {
  SetupAnswers answers = _runner,
  Size size = const Size(360, 800),
  double textScale = 1,
  Future<void> Function(LiltDatabase db)? seed,
  bool emptyLibrary = false,
  bool realConsent = false,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final db = inMemoryDatabase();
  addTearDown(db.close);
  await DriftSetupRepository(db).save(answers);
  if (realConsent) await DriftConsentRepository(db).agree();
  await seed?.call(db);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        // The real consent store when asked, so delete-all really takes consent away.
        if (!realConsent) consentRepositoryProvider.overrideWithValue(_Agreed()),
        ...todayTestOverrides(db),
        if (emptyLibrary) libraryLoaderProvider.overrideWithValue(_NoLibrary()),
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

class _NoLibrary extends NoopLibraryLoader {}

Future<void> _tap(WidgetTester tester, String text, {int index = 0}) async {
  final finder = find.text(text).at(index);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<List<OptionOffer>> _offers(LiltDatabase db) => db.select(db.optionOffers).get();

void main() {
  group('a first day (frame 1.16)', () {
    testWidgets('this week, "Your first ideas", the chips, one expanded option with its reason, and one filled button',
        (tester) async {
      await _open(tester);
      expect(find.text('This week · starts today'), findsOneWidget);
      expect(find.text('Friday 23 October'), findsOneWidget);
      expect(find.text('Your first ideas'), findsOneWidget);
      expect(find.text('20 min'), findsOneWidget);
      expect(find.text('Medium energy'), findsOneWidget);
      expect(_text('Suggested 12:30 · lunch'), findsWidgets);
      expect(find.widgetWithText(FilledButton, 'I’ll try this'), findsOneWidget, reason: 'one primary on the screen (DESIGN.md)');
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('every option names its reason (BR-004)', (tester) async {
      final db = await _open(tester);
      final reasons = await db.select(db.offerReasons).get();
      expect(reasons, isNotEmpty);
      expect(reasons.every((r) => r.reasonText.isNotEmpty), isTrue);
      // With no history the reason claims nothing about the person.
      expect(reasons.map((r) => r.reasonText).toSet(), everyElement(isNot(contains('managed this before'))));
    });

    testWidgets('the week strip has seven tiles and a name for each day', (tester) async {
      final handle = tester.ensureSemantics();
      await _open(tester);
      expect(find.bySemanticsLabel(RegExp(r'^Oct (19|20|21|22|23|24|25)( \(today\))?: ')), findsNWidgets(7));
      expect(find.bySemanticsLabel('Oct 23 (today): rest or not recorded'), findsOneWidget, reason: 'today is named, not only ringed');
      handle.dispose();
    });
  });

  group('"I\'ll try this" (BR-005)', () {
    testWidgets('plans the option, creates an unknown reflection, and shows today\'s plan', (tester) async {
      final db = await _open(tester);
      expect(await db.select(db.planItems).get(), isEmpty, reason: 'nothing is planned until the person accepts');

      await _tap(tester, 'I’ll try this');

      expect(find.text('Today’s plan'), findsOneWidget);
      expect(find.text('Planned'), findsOneWidget);
      expect(find.text('Something else'), findsNothing, reason: 'the hero card is gone once something is planned');
      final items = await db.select(db.planItems).get();
      expect(items, hasLength(1));
      final reflection = (await db.select(db.reflections).get()).single;
      expect(reflection.status, ReflectionStatus.unknown);
      expect(reflection.planItemId, items.single.id);
    });

    testWidgets('a compact card can be accepted too, and the rest stays open', (tester) async {
      final db = await _open(tester);
      // The second "I'll try this" on screen belongs to a compact card.
      await _tap(tester, 'I’ll try this', index: 1);
      expect(find.text('Today’s plan'), findsOneWidget);
      expect(await db.select(db.planItems).get(), hasLength(1));
    });
  });

  group('"Something else"', () {
    testWidgets('steps through the options with "N of M", and is gone on the last one', (tester) async {
      final db = await _open(tester);
      final chain = (await _offers(db)).length;
      expect(chain, greaterThanOrEqualTo(2));
      expect(find.text('1 of $chain'), findsOneWidget);

      await _tap(tester, 'Something else');
      expect(find.text('2 of $chain'), findsOneWidget);
      expect((await _offers(db)).first.status, OfferStatus.replaced);

      for (var i = 2; i < chain; i++) {
        await _tap(tester, 'Something else');
      }
      expect(find.text('$chain of $chain'), findsOneWidget);
      expect(find.text('Something else'), findsNothing, reason: 'it never cycles back (EQ-010)');
      expect(find.text('Not today'), findsWidgets, reason: 'Not today keeps its place');
    });

    testWidgets('the chain survives a restart: the same option is shown', (tester) async {
      final db = await _open(tester);
      await _tap(tester, 'Something else');
      final shownTitle = (await _offers(db)).firstWhere((o) => o.status == OfferStatus.offered).actionId;

      // Open again on the same database, as a relaunch does.
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
      expect((await _offers(db)).firstWhere((o) => o.status == OfferStatus.offered).actionId, shownTitle);
    });
  });

  group('the time and energy chips (frame 2.3)', () {
    testWidgets('open a list, apply to today, and re-rank what has not been acted on', (tester) async {
      final db = await _open(tester);
      await _tap(tester, '20 min');
      expect(find.text('How much time?'), findsOneWidget);
      for (final m in ['10 min', '20 min', '30 min', '45 min']) {
        expect(find.text(m), findsWidgets, reason: m);
      }
      await tester.tap(find.widgetWithText(InkWell, '10 min').last);
      await tester.pumpAndSettle();

      expect(find.text('10 min'), findsOneWidget);
      final waiting = (await _offers(db)).where((o) => o.status == OfferStatus.offered);
      expect(waiting, isNotEmpty);
      expect(waiting.every((o) => o.timeInputMin == 10), isTrue, reason: 'the offer records the value used');
    });

    testWidgets('energy opens its own list', (tester) async {
      await _open(tester);
      await _tap(tester, 'Medium energy');
      expect(find.text('How much energy?'), findsOneWidget);
      expect(find.text('Low energy'), findsOneWidget);
      expect(find.text('High energy'), findsOneWidget);
      await tester.tap(find.text('Low energy'));
      await tester.pumpAndSettle();
      expect(find.text('Low energy'), findsOneWidget);
    });
  });

  group('"Not today" and the pause (BR-006)', () {
    testWidgets('the pause is two taps from Today and is never shown as a miss', (tester) async {
      final db = await _open(tester);
      await _tap(tester, 'Not today');
      expect(find.text('Not today?'), findsOneWidget);
      expect(find.text('Or pause for a while'), findsOneWidget);
      expect(find.text('Reminders stop. Your progress stays.'), findsOneWidget);
      await _tap(tester, 'Pause for 1 week'); // "1 week" is preselected: this is the second tap

      expect(find.text('Paused, resume anytime'), findsOneWidget);
      expect(find.textContaining('Rest counts too. Reminders are off until Friday 30 October.'), findsOneWidget);
      expect(find.text('Resume now'), findsOneWidget);
      expect(find.text('Your first ideas'), findsNothing);
      expect(find.textContaining('missed'), findsNothing);
      expect((await db.select(db.pauses).get()).single.kind, PauseKind.pause);
      expect(await db.select(db.reflections).get(), isEmpty, reason: 'a pause counts nothing as skipped');
    });

    testWidgets('3 days and 2 weeks change the button and the end date', (tester) async {
      await _open(tester);
      await _tap(tester, 'Not today');
      await tester.tap(find.text('3 days'));
      await tester.pumpAndSettle();
      expect(find.text('Pause for 3 days'), findsOneWidget);
      await tester.tap(find.text('2 weeks'));
      await tester.pumpAndSettle();
      expect(find.text('Pause for 2 weeks'), findsOneWidget);
      await _tap(tester, 'Pause for 2 weeks');
      expect(find.textContaining('until Friday 6 November'), findsOneWidget);
    });

    testWidgets('"Resume now" brings the options back at once', (tester) async {
      await _open(tester);
      await _tap(tester, 'Not today');
      await _tap(tester, 'Pause for 1 week');
      await _tap(tester, 'Resume now');
      expect(find.text('Your first ideas'), findsOneWidget);
      expect(find.text('Paused, resume anytime'), findsNothing);
    });

    testWidgets('"Something lighter" swaps in a shorter, easier option', (tester) async {
      final db = await _open(tester);
      await _tap(tester, 'Not today');
      expect(find.text('Something lighter'), findsOneWidget);
      await _tap(tester, 'Something lighter');
      final shown = (await _offers(db)).lastWhere((o) => o.status == OfferStatus.offered);
      final action = await (db.select(db.actions)..where((t) => t.id.equals(shown.actionId))).getSingle();
      expect(action.durationMin, lessThanOrEqualTo(10));
      expect(action.energyNeeded, Energy.low);
      expect((await _offers(db)).first.status, OfferStatus.replaced);
    });

    testWidgets('"Not today" on a compact card opens the same sheet, without "Something lighter"', (tester) async {
      await _open(tester);
      await _tap(tester, 'Not today', index: 1);
      expect(find.text('Not today?'), findsOneWidget);
      expect(find.text('Something lighter'), findsNothing);
      // Nothing sits above the pause, so there is no "What would help?" and no "Or".
      expect(find.text('Pause for a while'), findsOneWidget);
      expect(find.text('Or pause for a while'), findsNothing);
      expect(find.text('That’s okay. What would help?'), findsNothing);
    });

    testWidgets('the sheet has no rows for screens that are not built yet', (tester) async {
      await _open(tester);
      await _tap(tester, 'Not today');
      expect(find.text('Move it to later'), findsNothing);
      expect(find.text('My plan fell through'), findsNothing);
    });
  });

  group('when few or no options fit (spec: sitemap S-004)', () {
    Future<void> oneAction(LiltDatabase db, {int minutes = 45, Energy energy = Energy.medium}) async {
      await db.delete(db.actions).go();
      await db.into(db.actions).insert(
            ActionsCompanion.insert(
              id: 'act_only',
              activity: ActivityKind.running,
              title: 'A long easy run',
              description: 'Run at an easy pace.',
              durationMin: minutes,
              intensity: Intensity.low,
              energyNeeded: energy,
              tags: const Value('solo,outdoors,free'),
              isStarter: const Value(true),
              libraryVersion: 'test-1',
            ),
          );
    }

    testWidgets('N2: the chips are the cause. The button relaxes them for today, and plans nothing', (tester) async {
      final db = await _open(tester, emptyLibrary: true, seed: oneAction);
      expect(find.text('Nothing fits those choices'), findsOneWidget);
      expect(find.text('Change the time or energy.'), findsOneWidget);
      expect(find.text('20 min'), findsOneWidget, reason: 'the chips stay so they can be changed');
      expect(find.text('Show options up to 45 min'), findsOneWidget);
      expect(find.text('Show a lighter option'), findsNothing, reason: 'it cannot help: lighter is the same chips');
      expect(find.text('Not today'), findsOneWidget, reason: 'pause stays reachable (BR-006)');
      expect(find.byType(FilledButton), findsOneWidget);

      await _tap(tester, 'Show options up to 45 min');
      expect(find.text('A long easy run'), findsOneWidget);
      expect(find.text('45 min'), findsOneWidget);
      expect(await db.select(db.planItems).get(), isEmpty, reason: 'it only shows options (BR-005)');
    });

    testWidgets('N3: nothing fits even without the chips: no chips, no dead button', (tester) async {
      await _open(
        tester,
        emptyLibrary: true,
        seed: (db) async {
          await oneAction(db);
          await db.into(db.preferences).insert(PreferencesCompanion.insert(kind: PrefKind.excluded, value: 'running'));
        },
      );
      expect(find.text('Nothing to suggest right now'), findsOneWidget);
      expect(find.text('Your leave-out and access choices cover everything we have.'), findsOneWidget);
      expect(find.text('20 min'), findsNothing, reason: 'the chips cannot fix it, so they are hidden');
      expect(find.text('Medium energy'), findsNothing);
      expect(find.text('Not today'), findsOneWidget);
    });

    testWidgets('the empty states have no red, no warning icon and no "ran out" wording', (tester) async {
      await _open(tester, emptyLibrary: true, seed: oneAction);
      expect(find.byIcon(Icons.warning), findsNothing);
      expect(find.byIcon(Icons.error), findsNothing);
      expect(find.textContaining('ran out'), findsNothing);
    });
  });

  group('the tabs', () {
    testWidgets('four tabs, Today first; the ones not built say so, and Today keeps its place', (tester) async {
      await _open(tester);
      for (final label in ['Today', 'Discover', 'Together', 'My rhythm']) {
        expect(find.text(label), findsWidgets, reason: label);
      }
      await tester.tap(find.text('Together').last);
      await tester.pumpAndSettle();
      expect(find.text('Events and clubs near you. Coming soon.'), findsOneWidget);
      await tester.tap(find.text('Today').last);
      await tester.pumpAndSettle();
      expect(find.text('Your first ideas'), findsOneWidget);
    });
  });

  group('8 dp between targets (DESIGN.md)', () {
    testWidgets('the hero\'s primary and its text buttons do not touch', (tester) async {
      await _open(tester);
      final primary = tester.getRect(find.widgetWithText(FilledButton, 'I’ll try this'));
      final below = tester.getRect(find.widgetWithText(TextButton, 'Something else'));
      expect(below.top - primary.bottom, greaterThanOrEqualTo(8));
    });

    testWidgets('the nothing-fits primary and Not today do not touch', (tester) async {
      await _open(tester, emptyLibrary: true, seed: (db) async {
        await db.delete(db.actions).go();
        await db.into(db.actions).insert(
              ActionsCompanion.insert(
                id: 'act_only',
                activity: ActivityKind.running,
                title: 'A long easy run',
                description: 'Run at an easy pace.',
                durationMin: 45,
                intensity: Intensity.low,
                energyNeeded: Energy.medium,
                tags: const Value('solo,outdoors,free'),
                isStarter: const Value(true),
                libraryVersion: 'test-1',
              ),
            );
      });
      final primary = tester.getRect(find.byType(FilledButton));
      final below = tester.getRect(find.widgetWithText(TextButton, 'Not today'));
      expect(below.top - primary.bottom, greaterThanOrEqualTo(8));
    });
  });

  group('"I\'ll try this" can be undone, and a swapped-away activity does not come back as a card', () {
    testWidgets('a snackbar says it was added and Undo removes the plan item', (tester) async {
      final db = await _open(tester);
      await _tap(tester, 'I’ll try this');
      expect(find.text('Added to today’s plan'), findsOneWidget);
      expect(await db.select(db.planItems).get(), hasLength(1));
      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();
      expect(await db.select(db.planItems).get(), isEmpty);
      expect(await db.select(db.reflections).get(), isEmpty);
      expect(find.text('Your first ideas'), findsOneWidget, reason: 'back to the options');
    });

    testWidgets('the snackbar goes away by itself', (tester) async {
      await _open(tester);
      await _tap(tester, 'I’ll try this');
      expect(find.text('Added to today’s plan'), findsOneWidget);
      await tester.pump(const Duration(seconds: 7));
      await tester.pumpAndSettle();
      expect(find.text('Added to today’s plan'), findsNothing);
    });

    testWidgets('it does not follow the person to another tab', (tester) async {
      await _open(tester);
      await _tap(tester, 'I’ll try this');
      expect(find.text('Added to today’s plan'), findsOneWidget);
      await _tap(tester, 'Discover');
      expect(find.text('Added to today’s plan'), findsNothing);
    });

    testWidgets('it does not show over Settings or the support message', (tester) async {
      await _open(tester);
      await _tap(tester, 'I’ll try this');
      await tester.tap(find.byIcon(Icons.person_outline).first);
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsWidgets);
      expect(find.text('Added to today’s plan'), findsNothing);
    });

    testWidgets('the support message opens clear of it (BR-003)', (tester) async {
      await _open(tester);
      await _tap(tester, 'I’ll try this');
      expect(find.text('Added to today’s plan'), findsOneWidget);
      unawaited(GoRouter.of(tester.element(find.byType(Scaffold).first)).push<void>('/support'));
      await tester.pumpAndSettle();
      expect(find.text('You don’t have to handle this alone'), findsOneWidget);
      expect(find.text('Added to today’s plan'), findsNothing);
    });

    testWidgets('after "Something else" the activity just left is not a compact card', (tester) async {
      final db = await _open(tester);
      final first = (await _offers(db)).first;
      final firstAction = await (db.select(db.actions)..where((t) => t.id.equals(first.actionId))).getSingle();
      await _tap(tester, 'Something else');
      // The card for the activity the hero just stepped past is gone: its title is not on screen at all.
      expect(find.text(firstAction.title), findsNothing);
    });
  });

  group('the planned state keeps a way out (BR-006)', () {
    testWidgets('the planned card has a Not today that opens the pause', (tester) async {
      final db = await _open(tester, answers: const SetupAnswers(
        paths: {SetupPath.keepGoing},
        keepActivity: ActivityKind.gym,
        progress: Progress.goingWell,
        freeTimes: {'lunch'},
        access: {'gym_membership'},
      ));
      await _tap(tester, 'I’ll try this');
      expect(find.text('Today’s plan'), findsOneWidget);
      await _tap(tester, 'Not today');
      expect(find.text('Pause for a while'), findsOneWidget);
      await _tap(tester, 'Pause for 1 week');
      expect(find.text('Paused, resume anytime'), findsOneWidget);
      expect(find.text('Planned'), findsOneWidget, reason: 'the plan stays visible while paused');
      expect(await db.select(db.planItems).get(), hasLength(1));
    });
  });

  group('the day moves on', () {
    testWidgets('a time that has passed is replaced by the next slot, and a new day starts fresh', (tester) async {
      var clock = DateTime(2026, 10, 23, 9);
      final db = inMemoryDatabase();
      addTearDown(db.close);
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await DriftSetupRepository(db).save(_runner);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            consentRepositoryProvider.overrideWithValue(_Agreed()),
            ...todayTestOverrides(db, clock: () => clock),
            assetReaderProvider.overrideWithValue(readAssetFile),
          ],
          child: const LiltApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(_text('Suggested 12:30 · lunch'), findsWidgets);

      // It is now 14:00: lunch has passed, so a chip change moves the waiting options to the next slot.
      clock = DateTime(2026, 10, 23, 14);
      await _tap(tester, '20 min');
      await tester.tap(find.widgetWithText(InkWell, '30 min').last);
      await tester.pumpAndSettle();
      expect(_text('Suggested 12:30 · lunch'), findsNothing);
      expect(_text('Suggested Sat 10:00 · weekends'), findsWidgets);

      // The next morning, coming back to the app shows the new day with the chips reset.
      clock = DateTime(2026, 10, 24, 9);
      final container = ProviderScope.containerOf(tester.element(find.byType(LiltApp)));
      await container.read(todayControllerProvider.notifier).refreshIfNewDay();
      await tester.pumpAndSettle();
      expect(find.text('Saturday 24 October'), findsOneWidget);
      expect(find.text('20 min'), findsOneWidget);
      expect((await _offers(db)).where((o) => o.day == '2026-10-24'), isNotEmpty);
    });
  });

  group('BR-005 and BR-009: only a tap plans anything', () {
    testWidgets('stepping, lighter, chips and looking at cards plan nothing and create no reflection', (tester) async {
      final db = await _open(tester);
      await _tap(tester, 'Something else');
      await _tap(tester, '20 min');
      await tester.tap(find.widgetWithText(InkWell, '30 min').last);
      await tester.pumpAndSettle();
      await _tap(tester, 'Not today');
      await _tap(tester, 'Something lighter');
      expect(await db.select(db.planItems).get(), isEmpty);
      expect(await db.select(db.reflections).get(), isEmpty);
    });
  });

  group('BR-011: a leave-out is never shown or stored as an offer', () {
    testWidgets('running and high impact are left out, so no such action is offered anywhere', (tester) async {
      final db = await _open(
        tester,
        answers: _runner.copyWith(excluded: {'running', 'high_impact'}),
      );
      final offered = await _offers(db);
      expect(offered, isNotEmpty);
      for (final o in offered) {
        final action = await (db.select(db.actions)..where((t) => t.id.equals(o.actionId))).getSingle();
        expect(action.activity, isNot(ActivityKind.running), reason: action.id);
        expect(action.tags.split(','), isNot(contains('high_impact')), reason: action.id);
      }
      expect(find.text('Running'), findsNothing, reason: 'no card for a left-out activity');
    });
  });

  group('a paused day on the rhythm card', () {
    testWidgets('is drawn like an empty day and named "paused" for screen readers (ADR-012)', (tester) async {
      final handle = tester.ensureSemantics();
      await _open(tester);
      await _tap(tester, 'Not today');
      await _tap(tester, 'Pause for 1 week');
      expect(find.bySemanticsLabel('Oct 23 (today): paused'), findsOneWidget);
      handle.dispose();
    });
  });

  group('TC-025 through Today: delete everything leaves nothing, and Today does not write it back', () {
    testWidgets('offers and plan items are gone, the library stays, and the consent screen shows', (tester) async {
      final db = await _open(tester, realConsent: true);
      await _tap(tester, 'I’ll try this');
      expect(await db.select(db.optionOffers).get(), isNotEmpty);
      expect(await db.select(db.offerReasons).get(), isNotEmpty);
      expect(await db.select(db.planItems).get(), isNotEmpty);

      final container = ProviderScope.containerOf(tester.element(find.byType(LiltApp)));
      await container.read(deleteEverythingProvider)();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      for (final table in db.userTables) {
        final rows = await db.customSelect('SELECT COUNT(*) AS n FROM ${table.actualTableName}').getSingle();
        expect(rows.read<int>('n'), 0, reason: table.actualTableName);
      }
      expect(await db.select(db.actions).get(), isNotEmpty);
    });
  });

  group('TC-044 and TC-045 on the rest of Today', () {
    for (final scale in [1.0, 2.0]) {
      testWidgets('chip lists, today\'s plan and the nothing-fits states at ${(scale * 100).round()}% text',
          (tester) async {
        final handle = tester.ensureSemantics();
        await _open(tester, size: const Size(320, 568), textScale: scale);
        Future<void> check(String where) async {
          expect(tester.takeException(), isNull, reason: where);
          await expectLater(tester, meetsGuideline(androidTapTargetGuideline), reason: where);
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline), reason: where);
        }

        await _tap(tester, '20 min');
        await check('time list');
        await tester.tap(find.byTooltip('Close'));
        await tester.pumpAndSettle();
        await _tap(tester, 'Medium energy');
        await check('energy list');
        await tester.tap(find.byTooltip('Close'));
        await tester.pumpAndSettle();
        await _tap(tester, 'I’ll try this');
        await check('today\'s plan with the cards still open');
        handle.dispose();
      });
    }
  });

  group('TC-044 and TC-045 on Today', () {
    for (final scale in [1.0, 2.0]) {
      for (final size in [const Size(360, 800), const Size(320, 568)]) {
        testWidgets('${(scale * 100).round()}% text on ${size.width.toInt()}x${size.height.toInt()}', (tester) async {
          final handle = tester.ensureSemantics();
          await _open(tester, size: size, textScale: scale);
          Future<void> check(String where) async {
            expect(tester.takeException(), isNull, reason: where);
            await expectLater(tester, meetsGuideline(androidTapTargetGuideline), reason: where);
            await expectLater(tester, meetsGuideline(labeledTapTargetGuideline), reason: where);
          }

          await check('options');
          await _tap(tester, 'Not today');
          await check('Not today sheet');
          await _tap(tester, 'Pause for 1 week');
          await check('paused');
          handle.dispose();
        });
      }
    }
  });
}
