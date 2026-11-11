import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/app/app.dart';
import 'package:lilt/data/consent_repository.dart';
import 'package:lilt/data/database.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/data/providers.dart';
import 'package:lilt/features/starting_point/setup_model.dart';
import 'package:lilt/features/starting_point/setup_repository.dart';
import 'package:lilt/features/support/support_providers.dart';
import 'package:lilt/domain/models.dart';
import 'package:lilt/features/today/today_controller.dart';
import 'package:lilt/features/today/today_logic.dart';
import 'package:lilt/ui/ui.dart';

import '../support/test_support.dart';

/// S-102 Edit ("Adjust this", frame 3.3) and S-107 "Why this suggestion?" (frame 3.2) on Today, with the real
/// library and a real in-memory database. "Today" is Friday 23 October 2026, 09:00.
class _Agreed implements ConsentRepository {
  @override
  Future<bool> hasAgreed() async => true;

  @override
  Future<void> agree() async {}
}

/// Walks only, lunch and after work, with "Outdoors after dark" left out (BR-011).
const _walkerNoDark = SetupAnswers(
  paths: {SetupPath.keepGoing},
  keepActivity: ActivityKind.walking,
  progress: Progress.goingWell,
  freeTimes: {'lunch', 'after_work'},
  access: {'none'},
  excluded: {'after_dark'},
);

const _walker = SetupAnswers(
  paths: {SetupPath.keepGoing},
  keepActivity: ActivityKind.walking,
  progress: Progress.goingWell,
  freeTimes: {'lunch', 'after_work'},
  access: {'none'},
);

const _runner = SetupAnswers(
  paths: {SetupPath.keepGoing, SetupPath.pickUpAgain},
  keepActivity: ActivityKind.gym,
  progress: Progress.goingWell,
  pickUpActivity: ActivityKind.running,
  stoppedAgo: StoppedAgo.months,
  freeTimes: {'lunch', 'weekends'},
  access: {'gym_membership'},
);

Future<LiltDatabase> _open(WidgetTester tester, {double textScale = 1, SetupAnswers answers = _runner}) async {
  tester.view.physicalSize = const Size(360, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final db = inMemoryDatabase();
  addTearDown(db.close);
  await DriftSetupRepository(db).save(answers);
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

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// A control inside the open sheet (the Today chips behind it have labels like "20 min" too).
Finder _inSheet(String text) => find.descendant(of: find.byType(LiltSheet), matching: find.text(text));

Future<List<PlanItem>> _plan(LiltDatabase db) => db.select(db.planItems).get();
Future<List<OptionOffer>> _offers(LiltDatabase db) => db.select(db.optionOffers).get();

void main() {
  group('the rules (S-102)', () {
    test('how long: the usual lengths and always the idea’s own, in order', () {
      expect(durationChoices(20), [10, 20, 30, 45]);
      expect(durationChoices(15), [10, 15, 20, 30, 45]);
      expect(durationChoices(60), [10, 20, 30, 45, 60]);
    });

    test('when: what was suggested first, then the next free times, three at most, no repeats', () {
      final now = fixedNow();
      final slot = upcomingSlots({'lunch', 'weekends'}, now).first;
      final choices = whenChoices(suggested: slot, freeTimes: const {'lunch', 'weekends'}, now: now);
      expect(choices.map((c) => c.label), ['Today 12:30', 'Tomorrow 10:00', 'Tomorrow 12:30']);
      expect(choices.toSet().length, choices.length);
    });

    test('when: with no free time the first choice is today with no set time', () {
      final choices = whenChoices(suggested: null, freeTimes: const {}, now: fixedNow());
      expect(choices, hasLength(1));
      expect(choices.single.label, 'Today');
      expect(choices.single.time, isNull);
    });

    test('a picked time is never in the past: later today stays today, an earlier one is tomorrow', () {
      final now = fixedNow(); // 09:00
      expect(pickedWhen(15 * 60, now).label, 'Today 15:00');
      expect(pickedWhen(7 * 60, now).label, 'Tomorrow 07:00');
      expect(pickedWhen(9 * 60, now).label, 'Tomorrow 09:00', reason: 'the same minute has already begun');
    });
  });

  group('Edit never relaxes a leave-out (BR-011)', () {
    ActionInfo idea(List<String> tags) => ActionInfo(
          id: 'a',
          activity: ActivityKind.walking,
          title: 'a',
          durationMin: 10,
          energyNeeded: Energy.low,
          tags: tags.toSet(),
          isStarter: false,
          similarTo: const [],
          libraryVersion: 'test',
        );

    test('dark hours are 18:00 to 06:00', () {
      expect(isDarkMinute(17 * 60 + 59), isFalse);
      expect(isDarkMinute(18 * 60), isTrue);
      expect(isDarkMinute(5 * 60 + 59), isTrue);
      expect(isDarkMinute(6 * 60), isFalse);
    });

    test('only an outdoor idea with "Outdoors after dark" left out may not be planned in the dark', () {
      expect(darkTimesAllowed({'after_dark'}, idea(['outdoors'])), isFalse);
      expect(darkTimesAllowed({'after_dark'}, idea(['indoors'])), isTrue);
      expect(darkTimesAllowed(const {}, idea(['outdoors'])), isTrue);
    });

    test('when: dark slots are not offered to an idea that may not go in the dark', () {
      final now = fixedNow();
      final slot = upcomingSlots({'lunch', 'after_work'}, now).first;
      final open = whenChoices(suggested: slot, freeTimes: const {'lunch', 'after_work'}, now: now);
      final closed = whenChoices(suggested: slot, freeTimes: const {'lunch', 'after_work'}, now: now, allowDark: false);
      expect(open.map((c) => c.label), contains('Today 18:30'));
      expect(closed.map((c) => c.time), isNot(contains('18:30')));
      expect(closed.first.label, 'Today 12:30');
    });

    test('an edit with a dark time is refused for such an idea, and a daytime or unset time is not', () {
      const dark = OfferEdit(durationMin: 10, day: '2026-10-23', time: '20:00');
      const day = OfferEdit(durationMin: 10, day: '2026-10-23', time: '15:00');
      const unset = OfferEdit(durationMin: 10, day: '2026-10-23');
      final outdoor = idea(['outdoors']);
      expect(editAllowed(excluded: {'after_dark'}, action: outdoor, edit: dark), isFalse);
      expect(editAllowed(excluded: {'after_dark'}, action: outdoor, edit: day), isTrue);
      expect(editAllowed(excluded: {'after_dark'}, action: outdoor, edit: unset), isTrue);
      expect(editAllowed(excluded: {'after_dark'}, action: outdoor, edit: null), isTrue);
      expect(editAllowed(excluded: const {}, action: outdoor, edit: dark), isTrue);
      expect(editAllowed(excluded: {'after_dark'}, action: idea(['indoors']), edit: dark), isTrue);
    });

    testWidgets('the sheet offers no after-dark time for an outdoor walk when that is left out', (tester) async {
      await _open(tester, answers: _walkerNoDark);
      expect(find.text('A ten-minute easy walk'), findsWidgets);
      await _tap(tester, find.text('Edit').first);
      expect(_inSheet('Today 12:30'), findsOneWidget);
      expect(find.descendant(of: find.byType(LiltSheet), matching: find.textContaining('18:30')), findsNothing);
    });

    testWidgets('with nothing left out the same walk can be moved to after work', (tester) async {
      await _open(tester, answers: _walker);
      await _tap(tester, find.text('Edit').first);
      expect(find.descendant(of: find.byType(LiltSheet), matching: find.textContaining('18:30')), findsOneWidget);
    });

    testWidgets('the save refuses a dark time even if something other than the sheet asks for it', (tester) async {
      final db = await _open(tester, answers: _walkerNoDark);
      final container = ProviderScope.containerOf(tester.element(find.byType(LiltApp)));
      final planned = await container
          .read(todayControllerProvider.notifier)
          .acceptShown(edit: const OfferEdit(durationMin: 10, day: '2026-10-23', time: '20:00'));
      await tester.pumpAndSettle();
      expect(planned, isFalse);
      expect(await _plan(db), isEmpty);
      expect((await _offers(db)).every((o) => o.status == OfferStatus.offered), isTrue);
    });
  });

  group('Why this suggestion? (frame 3.2)', () {
    testWidgets('opens from the card, lists the reasons and where ideas come from, and plans nothing', (tester) async {
      final db = await _open(tester);
      await _tap(tester, find.text('Why this?').first);
      expect(find.text('Why this suggestion?'), findsOneWidget);
      expect(find.textContaining('reviewed library of activities'), findsOneWidget);
      // The reason on the card is the first one in the sheet.
      final first = (await db.select(db.offerReasons).get()).where((r) => r.rank == 1).map((r) => r.reasonText).toSet();
      expect(first.any((text) => _inSheet(text).evaluate().isNotEmpty), isTrue);
      await _tap(tester, find.text('Got it'));
      expect(find.text('Why this suggestion?'), findsNothing);
      expect(await _plan(db), isEmpty, reason: 'only a tap on "I’ll try this" or "Save changes" plans (BR-005)');
      expect((await _offers(db)).every((o) => o.status == OfferStatus.offered), isTrue);
    });

    testWidgets('every reason stored for an offer is numbered from 1', (tester) async {
      final db = await _open(tester);
      final rows = await db.select(db.offerReasons).get();
      expect(rows, isNotEmpty);
      final byOffer = <String, List<int>>{};
      for (final r in rows) {
        (byOffer[r.offerId] ??= []).add(r.rank);
      }
      for (final ranks in byOffer.values) {
        ranks.sort();
        expect(ranks, [for (var i = 1; i <= ranks.length; i++) i]);
      }
    });
  });

  group('Edit (frame 3.3)', () {
    testWidgets('shows how long and when, with the suggestion first', (tester) async {
      await _open(tester);
      await _tap(tester, find.text('Edit').first);
      expect(find.text('Adjust this'), findsOneWidget);
      expect(find.text('How long'), findsOneWidget);
      expect(find.text('When'), findsOneWidget);
      expect(_inSheet('Today 12:30'), findsOneWidget);
      expect(_inSheet('Tomorrow 10:00'), findsOneWidget);
      expect(find.text('Pick a time ›'), findsOneWidget);
      expect(_inSheet('Save changes'), findsOneWidget);
    });

    testWidgets('Save changes plans it as chosen, as an edit, with the same Undo as I’ll try this', (tester) async {
      final db = await _open(tester);
      await _tap(tester, find.text('Edit').first);
      await _tap(tester, _inSheet('30 min'));
      await _tap(tester, _inSheet('Tomorrow 10:00'));
      await _tap(tester, _inSheet('Save changes'));

      final plan = await _plan(db);
      expect(plan, hasLength(1));
      expect(plan.single.durationMin, 30);
      expect(plan.single.plannedDay, '2026-10-24');
      expect(plan.single.plannedTime, '10:00');
      final edited = (await _offers(db)).where((o) => o.status == OfferStatus.edited).toList();
      expect(edited, hasLength(1));
      expect(edited.single.editedDurationMin, 30);
      expect(edited.single.editedDay, '2026-10-24');
      expect(edited.single.editedTime, '10:00');
      expect(find.text('Added to today’s plan'), findsOneWidget);

      await _tap(tester, find.text('Undo'));
      expect(await _plan(db), isEmpty);
      final back = (await _offers(db)).where((o) => o.id == edited.single.id).single;
      expect(back.status, OfferStatus.offered);
      expect(back.editedDurationMin, isNull);
      expect(back.editedDay, isNull);
      expect(back.editedTime, isNull);
    });

    testWidgets('Save changes with nothing changed plans the suggestion as it was, as accepted', (tester) async {
      final db = await _open(tester);
      await _tap(tester, find.text('Edit').first);
      await _tap(tester, _inSheet('Save changes'));
      final offers = await _offers(db);
      expect(offers.where((o) => o.status == OfferStatus.edited), isEmpty);
      final accepted = offers.where((o) => o.status == OfferStatus.accepted).toList();
      expect(accepted, hasLength(1));
      expect(accepted.single.editedDurationMin, isNull);
      expect(await _plan(db), hasLength(1));
    });

    testWidgets('closing the sheet plans nothing (BR-005)', (tester) async {
      final db = await _open(tester);
      await _tap(tester, find.text('Edit').first);
      await _tap(tester, _inSheet('45 min'));
      await tester.tapAt(const Offset(180, 40)); // the scrim
      await tester.pumpAndSettle();
      expect(find.text('Adjust this'), findsNothing);
      expect(await _plan(db), isEmpty);
      expect((await _offers(db)).every((o) => o.status == OfferStatus.offered), isTrue);
    });

    testWidgets('an edited plan steps the suggestion aside like an accepted one', (tester) async {
      await _open(tester);
      await _tap(tester, find.text('Edit').first);
      await _tap(tester, _inSheet('30 min'));
      await _tap(tester, _inSheet('Save changes'));
      expect(find.text('Today’s plan'), findsOneWidget);
    });

    testWidgets('a card that is not stored yet can be edited too', (tester) async {
      final db = await _open(tester);
      // The second "Edit" is on a compact card for the other followed activity.
      expect(find.text('Edit'), findsAtLeastNWidgets(2));
      await _tap(tester, find.text('Edit').at(1));
      await _tap(tester, _inSheet('30 min'));
      await _tap(tester, _inSheet('Save changes'));
      final edited = (await _offers(db)).where((o) => o.status == OfferStatus.edited).toList();
      expect(edited, hasLength(1));
      expect(edited.single.editedDurationMin, 30);
      expect((await _plan(db)).single.durationMin, 30);
    });
  });

  group('accessibility (TC-044, TC-045)', () {
    for (final scale in [1.0, 2.0]) {
      testWidgets('the links and both sheets keep 48 dp targets and labels at ${scale * 100}% text', (tester) async {
        final handle = tester.ensureSemantics();
        await _open(tester, textScale: scale);
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await _tap(tester, find.text('Why this?').first);
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await _tap(tester, find.text('Got it'));
        await _tap(tester, find.text('Edit').first);
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        handle.dispose();
      });
    }
  });
}
