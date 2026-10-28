import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lilt/app/app.dart';
import 'package:lilt/data/consent_repository.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/data/providers.dart';
import 'package:lilt/features/starting_point/setup_controller.dart';
import 'package:lilt/features/starting_point/setup_model.dart';
import 'package:lilt/features/starting_point/setup_repository.dart';
import 'package:lilt/features/support/support_providers.dart';

import '../support/test_support.dart';

/// S-003 and S-090 as a person uses them: frames 1.3 to 1.15 and 9.2.
class _AgreedConsent implements ConsentRepository {
  @override
  Future<bool> hasAgreed() async => true;

  @override
  Future<void> agree() async {}
}

class _ThrowingSetupRepository implements SetupRepository {
  int attempts = 0;
  bool failOnce = true;

  @override
  Future<bool> isDone() async => false;

  @override
  Future<void> save(SetupAnswers answers) async {
    attempts++;
    if (failOnce && attempts == 1) throw StateError('disk full');
  }
}

Future<FakeSetupRepository> _open(
  WidgetTester tester, {
  FakeSetupRepository? repo,
  SetupRepository? override,
  Size size = const Size(360, 800),
  double textScale = 1,
  List<Override> more = const [],
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final setup = repo ?? FakeSetupRepository();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        consentRepositoryProvider.overrideWithValue(_AgreedConsent()),
        setupRepositoryProvider.overrideWithValue(override ?? setup),
        libraryLoaderProvider.overrideWithValue(NoopLibraryLoader()),
        ...setupTestOverrides(),
        ...more,
      ],
      child: MediaQuery(
        data: MediaQueryData(size: size, textScaler: TextScaler.linear(textScale)),
        child: const LiltApp(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return setup;
}

Future<void> _tap(WidgetTester tester, String text) async {
  await tester.ensureVisible(find.text(text).first);
  await tester.pumpAndSettle();
  await tester.tap(find.text(text).first);
  await tester.pumpAndSettle();
}

Finder get _next => find.widgetWithText(FilledButton, 'Next');

void main() {
  group('the first question (frames 1.3 and 1.4)', () {
    testWidgets('Next is off with a hint until one path is ticked', (tester) async {
      await _open(tester);
      expect(find.text('What brings you here?'), findsOneWidget);
      expect(find.text('Pick at least one to continue.'), findsOneWidget);
      expect(tester.widget<FilledButton>(_next).onPressed, isNull);
      expect(find.byTooltip('Back'), findsNothing, reason: 'there is nothing before the first question');

      await _tap(tester, 'Keep going with something I do now');
      expect(tester.widget<FilledButton>(_next).onPressed, isNotNull);
      expect(find.text('Pick at least one to continue.'), findsNothing);
    });

    testWidgets('several can be ticked; "start fresh" clears them', (tester) async {
      await _open(tester);
      await _tap(tester, 'Keep going with something I do now');
      await _tap(tester, 'Pick up something I stopped');
      await _tap(tester, 'Start being active for the first time');
      await _tap(tester, 'Next');
      expect(find.text('What sounds good to try?'), findsOneWidget);
    });
  });

  group('keep going', () {
    testWidgets('gym, up and down, what makes it harder, then the shared questions, saved once at the end',
        (tester) async {
      final repo = await _open(tester);
      await _tap(tester, 'Keep going with something I do now');
      await _tap(tester, 'Next');

      expect(find.text('Keep going'), findsOneWidget);
      expect(find.text('What do you do now?'), findsOneWidget);
      expect(find.text('Pick one to continue.'), findsOneWidget);
      await _tap(tester, 'Gym');
      await _tap(tester, 'Next');

      expect(find.text('How’s the gym going?'), findsOneWidget);
      expect(find.text('What’s making it harder? (optional)'), findsNothing);
      await _tap(tester, 'Up and down');
      expect(find.text('What’s making it harder? (optional)'), findsOneWidget);
      await _tap(tester, 'Finding time');
      await _tap(tester, 'Next');

      expect(find.text('When could you fit it in?'), findsOneWidget);
      expect(find.text('Pick at least one time you are usually free.'), findsOneWidget);
      await _tap(tester, 'Lunch');
      await _tap(tester, 'Pool');
      await _tap(tester, 'Time');
      await _tap(tester, 'Next');

      expect(find.text('Why does being active matter to you?'), findsOneWidget);
      await _tap(tester, 'More energy');
      await _tap(tester, 'Next');

      expect(find.text('Anything to leave out?'), findsOneWidget);
      expect(repo.saves, 0, reason: 'nothing is stored before "Show me today"');
      await _tap(tester, 'Swimming');
      await _tap(tester, 'Show me today');

      expect(repo.saves, 1);
      final a = repo.saved!;
      expect(a.paths, {SetupPath.keepGoing});
      expect(a.keepActivity, ActivityKind.gym);
      expect(a.progress, Progress.upAndDown);
      expect(a.hardBecause, {'finding_time'});
      expect(a.freeTimes, {'lunch'});
      expect(a.access, {'pool'});
      expect(a.barriers, {'time'});
      expect(a.motivations, {'more_energy'});
      expect(a.excluded, {'swimming'});
    });
  });

  group('pick up again (frames 1.8 to 1.11)', () {
    testWidgets('the summary folds earlier answers, Skip leaves the follow-ups, Edit goes back', (tester) async {
      final repo = await _open(tester);
      await _tap(tester, 'Pick up something I stopped');
      await _tap(tester, 'Next');

      expect(find.text('Pick up again'), findsOneWidget);
      expect(find.text('What would you like to pick up again?'), findsOneWidget);
      await _tap(tester, 'Running');
      await _tap(tester, 'Next');

      expect(find.text('When did you stop, roughly?'), findsOneWidget);
      expect(find.text('Running'), findsOneWidget, reason: 'the summary row');
      await _tap(tester, 'A few months ago');
      await _tap(tester, 'Next');

      expect(find.text('What got in the way?'), findsOneWidget);
      expect(find.text('Running · a few months ago'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
      await _tap(tester, 'Busier at work or study');
      await _tap(tester, 'Next');

      expect(find.text('What would make it easier now?'), findsOneWidget);
      await _tap(tester, 'Skip');

      // Edit on the summary row goes back to the start of the section, keeping the answers.
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      await _tap(tester, 'Edit');
      expect(find.text('What would you like to pick up again?'), findsOneWidget);
      await _tap(tester, 'Next');
      await _tap(tester, 'Next');
      await _tap(tester, 'Next');
      await _tap(tester, 'Skip');
      await _tap(tester, 'Lunch');
      await _tap(tester, 'Next');
      await _tap(tester, 'Next');
      await _tap(tester, 'Show me today');

      final a = repo.saved!;
      expect(a.pickUpActivity, ActivityKind.running);
      expect(a.stoppedAgo, StoppedAgo.months);
      expect(a.gotInTheWay, {'busier'});
      expect(a.wouldHelp, isEmpty, reason: 'skipped');
    });
  });

  group('back', () {
    testWidgets('the back arrow goes to the previous question and keeps the answers', (tester) async {
      await _open(tester);
      await _tap(tester, 'Keep going with something I do now');
      await _tap(tester, 'Next');
      await _tap(tester, 'Gym');
      await _tap(tester, 'Next');
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.text('What do you do now?'), findsOneWidget);
      // Gym is still picked: Next is on without picking again.
      expect(tester.widget<FilledButton>(_next).onPressed, isNotNull);
    });

    testWidgets('the system back gesture does the same, and the progress is named for screen readers', (tester) async {
      final handle = tester.ensureSemantics();
      await _open(tester);
      expect(find.bySemanticsLabel('Step 1 of 4'), findsOneWidget, reason: 'nothing ticked yet: the four shared questions');
      await _tap(tester, 'Keep going with something I do now');
      await _tap(tester, 'Next');
      expect(find.bySemanticsLabel('Step 2 of 6'), findsOneWidget);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('What brings you here?'), findsOneWidget);
      handle.dispose();
    });
  });

  group('why it matters (frame 1.13)', () {
    testWidgets('up to 3, the counter follows, and "Prefer not to say" stands alone', (tester) async {
      final repo = await _open(tester);
      await _tap(tester, 'Start being active for the first time');
      await _tap(tester, 'Next');
      await _tap(tester, 'Not sure yet');
      await _tap(tester, 'Next');
      await _tap(tester, 'Lunch');
      await _tap(tester, 'Next');

      expect(find.text('Pick up to 3 · 0 of 3 picked'), findsOneWidget);
      for (final label in ['More energy', 'Less stress', 'Sleep better', 'Feel stronger']) {
        await _tap(tester, label);
      }
      expect(find.text('Pick up to 3 · 3 of 3 picked'), findsOneWidget);
      await _tap(tester, 'Prefer not to say');
      expect(find.text('Pick up to 3 · 0 of 3 picked'), findsOneWidget);
      await _tap(tester, 'Next');
      await _tap(tester, 'Show me today');
      expect(repo.saved!.motivations, {'prefer_not_to_say'});
    });
  });

  group('"Other" and the search (frame 1.6)', () {
    Future<void> toKeepActivity(WidgetTester tester) async {
      await _tap(tester, 'Keep going with something I do now');
      await _tap(tester, 'Next');
      await _tap(tester, 'Other');
    }

    testWidgets('a library match comes back as a selected chip', (tester) async {
      final repo = await _open(tester);
      await toKeepActivity(tester);
      await tester.enterText(find.byType(TextField), 'pil');
      await tester.pumpAndSettle();
      expect(find.text('Matches'), findsOneWidget);
      expect(find.text('Pilates'), findsOneWidget);
      expect(find.text('Strength and flexibility'), findsOneWidget);
      expect(find.text('Gym'), findsNothing);
      await tester.tap(find.text('Pilates'));
      await tester.pumpAndSettle();

      expect(find.text('Pilates'), findsOneWidget, reason: 'its own chip');
      await _tap(tester, 'Next');
      await _tap(tester, 'Going well');
      await _tap(tester, 'Next');
      await _tap(tester, 'Lunch');
      await _tap(tester, 'Next');
      await _tap(tester, 'Next');
      await _tap(tester, 'Show me today');
      expect(repo.saved!.keepActivity, ActivityKind.pilates);
    });

    testWidgets('"Not listed? Add it yourself" keeps the typed name as other', (tester) async {
      final repo = await _open(tester);
      await toKeepActivity(tester);
      await tester.enterText(find.byType(TextField), 'Padel');
      await tester.pumpAndSettle();
      expect(find.text('Not listed?'), findsOneWidget);
      await tester.tap(find.text('Add “Padel” yourself'));
      await tester.pumpAndSettle();

      expect(find.text('Padel'), findsOneWidget);
      await _tap(tester, 'Next');
      expect(find.text('How’s the padel going?'), findsOneWidget);
      await _tap(tester, 'Going well');
      await _tap(tester, 'Next');
      await _tap(tester, 'Lunch');
      await _tap(tester, 'Next');
      await _tap(tester, 'Next');
      await _tap(tester, 'Show me today');
      expect(repo.saved!.keepActivity, ActivityKind.other);
      expect(repo.saved!.keepCustomName, 'Padel');
    });

    testWidgets('no matches still offers to add it', (tester) async {
      await _open(tester);
      await toKeepActivity(tester);
      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pumpAndSettle();
      expect(find.text('No matches'), findsOneWidget);
      expect(find.text('Add “zzz” yourself'), findsOneWidget);
    });

    testWidgets('BR-003: a red-flag phrase shows the support message, is cleared, and is never kept', (tester) async {
      final repo = await _open(tester);
      await toKeepActivity(tester);
      await tester.enterText(find.byType(TextField), 'I want to die');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add “I want to die” yourself'));
      await tester.pumpAndSettle();

      expect(find.text('You don’t have to handle this alone'), findsOneWidget);
      expect(find.text('Call emergency services'), findsOneWidget);
      expect(find.text('I want to die'), findsNothing);

      await _tap(tester, 'Back');
      // Back on the search: the field is empty, and nothing was chosen or stored.
      expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, isEmpty);
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(tester.widget<FilledButton>(_next).onPressed, isNull, reason: 'no activity was picked');
      expect(repo.saved, isNull);
      expect(find.textContaining('want to die'), findsNothing);
    });

    testWidgets('everyday words are not flagged', (tester) async {
      await _open(tester);
      await toKeepActivity(tester);
      await tester.enterText(find.byType(TextField), 'Backstroke');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add “Backstroke” yourself'));
      await tester.pumpAndSettle();
      expect(find.text('Backstroke'), findsOneWidget);
      expect(find.text('You don’t have to handle this alone'), findsNothing);
    });
  });

  group('saving', () {
    testWidgets('a failed save stores nothing, says so, and can be retried', (tester) async {
      final throwing = _ThrowingSetupRepository();
      await _open(tester, override: throwing);
      await _tap(tester, 'Start being active for the first time');
      await _tap(tester, 'Next');
      await _tap(tester, 'Not sure yet');
      await _tap(tester, 'Next');
      await _tap(tester, 'Lunch');
      await _tap(tester, 'Next');
      await _tap(tester, 'Next');
      await _tap(tester, 'Show me today');

      expect(find.text('That didn’t save'), findsOneWidget);
      expect(find.text('Nothing was stored. Your answers are still here.'), findsOneWidget);
      await _tap(tester, 'Try again');
      expect(throwing.attempts, 2);
    });

    testWidgets('a person who is already set up never sees setup', (tester) async {
      await _open(tester, repo: FakeSetupRepository(done: true));
      expect(find.text('What brings you here?'), findsNothing);
      expect(find.text('Here’s what fits today'), findsOneWidget);
    });
  });

  group('TC-044 and TC-045 on the setup questions', () {
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

          await check('first question');
          await _tap(tester, 'Keep going with something I do now');
          await _tap(tester, 'Pick up something I stopped');
          await _tap(tester, 'Next');
          await check('activity chips');
          await _tap(tester, 'Gym');
          await _tap(tester, 'Next');
          await check('how is it going');
          await _tap(tester, 'Up and down');
          await check('what makes it harder');
          handle.dispose();
        });
      }
    }

    testWidgets('the week question, with three chip groups, scrolls and keeps Next in place at 200%', (tester) async {
      await _open(tester, size: const Size(320, 568), textScale: 2);
      await _tap(tester, 'Start being active for the first time');
      await _tap(tester, 'Next');
      await _tap(tester, 'Not sure yet');
      await _tap(tester, 'Next');
      expect(find.text('When could you fit it in?'), findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(tester.getRect(find.widgetWithText(FilledButton, 'Next')).bottom, lessThanOrEqualTo(568));
    });
  });

  group('S-090 support message', () {
    testWidgets('with no numbers listed it says to call the local emergency number, and shows no number',
        (tester) async {
      await _open(tester, more: [deviceCountryProvider.overrideWithValue('ZA')]);
      final context = tester.element(find.byType(Scaffold).first);
      // Open it the way a red flag does.
      GoRouterHelper.go(context, '/support');
      await tester.pumpAndSettle();
      expect(find.textContaining('call your local emergency number'), findsOneWidget);
      await tester.tap(find.text('Call emergency services'));
      await tester.pumpAndSettle();
      expect(find.text('Call your local emergency number.'), findsOneWidget);
    });

    testWidgets('a listed region shows its numbers as text, never dials', (tester) async {
      const json = '''
{"version":"test","regions":[{"name":"Testland","countries":["ZZ"],
 "emergency":[{"label":"Emergency services","number":"000"}],
 "crisis":[{"label":"Crisis line","number":"111 222"}],
 "doctor_note":"Visit the clinic."}]}''';
      await _open(tester, more: [
        deviceCountryProvider.overrideWithValue('zz'),
        assetReaderProvider.overrideWithValue((path) async => path == helplinesAsset ? json : readAssetFile(path)),
      ]);
      GoRouterHelper.go(tester.element(find.byType(Scaffold).first), '/support');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Call emergency services'));
      await tester.pumpAndSettle();
      expect(find.text('000'), findsOneWidget);
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Call a crisis line'));
      await tester.pumpAndSettle();
      expect(find.text('111 222'), findsOneWidget);
    });

    testWidgets('the screen meets the tap target guideline at 200%', (tester) async {
      final handle = tester.ensureSemantics();
      await _open(tester, textScale: 2);
      GoRouterHelper.go(tester.element(find.byType(Scaffold).first), '/support');
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });
  });
}

/// `context.go` without importing go_router's extension into every call site above.
abstract final class GoRouterHelper {
  static void go(BuildContext context, String location) => GoRouter.of(context).go(location);
}
