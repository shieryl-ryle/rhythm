import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/features/starting_point/setup_copy.dart';
import 'package:lilt/features/starting_point/setup_model.dart';

/// The order and rules of the setup wizard (F-001, frames 1.3 to 1.14).
void main() {
  group('which questions come, in what order', () {
    test('keep going only', () {
      expect(stepsFor({SetupPath.keepGoing}), [
        SetupStep.brings,
        SetupStep.keepActivity,
        SetupStep.keepProgress,
        SetupStep.week,
        SetupStep.why,
        SetupStep.leaveOut,
      ]);
    });

    test('keep going and pick up again: the order of frames 1.5, 1.7, then 1.8 to 1.11', () {
      final steps = stepsFor({SetupPath.pickUpAgain, SetupPath.keepGoing});
      expect(steps.sublist(0, 7), [
        SetupStep.brings,
        SetupStep.keepActivity,
        SetupStep.keepProgress,
        SetupStep.pickUpWhich,
        SetupStep.pickUpStopped,
        SetupStep.pickUpGotInWay,
        SetupStep.pickUpHelp,
      ]);
      // Frame 1.13 is "step 9 of 10" in this combination: 7 + week + why + leave out = 10.
      expect(steps.length, 10);
      expect(steps.indexOf(SetupStep.why) + 1, 9);
    });

    test('all three ticked paths: "What do you do now?" is asked once', () {
      expect(stepsFor({SetupPath.keepGoing, SetupPath.addNew, SetupPath.pickUpAgain}), [
        SetupStep.brings,
        SetupStep.keepActivity,
        SetupStep.keepProgress,
        SetupStep.pickUpWhich,
        SetupStep.pickUpStopped,
        SetupStep.pickUpGotInWay,
        SetupStep.pickUpHelp,
        SetupStep.week,
        SetupStep.why,
        SetupStep.leaveOut,
      ]);
    });

    test('add something new alone asks what they do now; with keep going it does not ask again', () {
      expect(stepsFor({SetupPath.addNew}), contains(SetupStep.addNew));
      expect(stepsFor({SetupPath.addNew, SetupPath.keepGoing}), isNot(contains(SetupStep.addNew)));
    });

    test('start fresh has one question of its own', () {
      expect(stepsFor({SetupPath.startFresh}), [
        SetupStep.brings,
        SetupStep.startFresh,
        SetupStep.week,
        SetupStep.why,
        SetupStep.leaveOut,
      ]);
    });

    test('nothing ticked: only the first question, so no later one can be reached', () {
      expect(stepsFor({}).first, SetupStep.brings);
      expect(canContinue(SetupStep.brings, const SetupAnswers()), isFalse);
    });
  });

  group('the first question', () {
    test('several can be ticked, and unticking works', () {
      var a = const SetupAnswers().togglePath(SetupPath.keepGoing).togglePath(SetupPath.pickUpAgain);
      expect(a.paths, {SetupPath.keepGoing, SetupPath.pickUpAgain});
      a = a.togglePath(SetupPath.keepGoing);
      expect(a.paths, {SetupPath.pickUpAgain});
    });

    test('"start fresh" clears the others, and any other clears it', () {
      var a = const SetupAnswers().togglePath(SetupPath.keepGoing).togglePath(SetupPath.addNew);
      a = a.togglePath(SetupPath.startFresh);
      expect(a.paths, {SetupPath.startFresh});
      a = a.togglePath(SetupPath.keepGoing);
      expect(a.paths, {SetupPath.keepGoing});
    });
  });

  group('Next and Skip', () {
    final cases = <(SetupStep, SetupAnswers, bool)>[
      (SetupStep.keepActivity, const SetupAnswers(), false),
      (SetupStep.keepActivity, const SetupAnswers(keepActivity: ActivityKind.gym), true),
      (SetupStep.keepProgress, const SetupAnswers(), false),
      (SetupStep.keepProgress, const SetupAnswers(progress: Progress.upAndDown), true),
      (SetupStep.pickUpWhich, const SetupAnswers(), false),
      (SetupStep.pickUpStopped, const SetupAnswers(), false),
      (SetupStep.pickUpStopped, const SetupAnswers(stoppedAgo: StoppedAgo.months), true),
      (SetupStep.pickUpGotInWay, const SetupAnswers(), true),
      (SetupStep.pickUpHelp, const SetupAnswers(), true),
      (SetupStep.startFresh, const SetupAnswers(), false),
      (SetupStep.week, const SetupAnswers(), false),
      (SetupStep.week, const SetupAnswers(freeTimes: {'lunch'}), true),
      (SetupStep.why, const SetupAnswers(), true),
      (SetupStep.leaveOut, const SetupAnswers(), true),
    ];
    for (final (step, answers, ok) in cases) {
      test('${step.name} with ${ok ? 'an answer' : 'no answer'}: Next is ${ok ? 'on' : 'off'}', () {
        expect(canContinue(step, answers), ok);
      });
    }

    test('only the follow-ups to "why it stopped" can be skipped (BR-008)', () {
      expect({for (final s in SetupStep.values) if (canSkip(s)) s}, {SetupStep.pickUpGotInWay, SetupStep.pickUpHelp});
    });

    test('every required question has a hint for the grey Next, and optional ones do not', () {
      for (final s in SetupStep.values) {
        final required = !canContinue(s, const SetupAnswers());
        expect(requiredHint(s) != null, required, reason: s.name);
      }
    });
  });

  group('exclusive answers and limits', () {
    test('at most 3 motivations; a 4th tap does nothing', () {
      var a = const SetupAnswers();
      for (final code in ['more_energy', 'less_stress', 'sleep_better', 'time_with_people']) {
        a = a.toggleMotivation(code);
      }
      expect(a.motivations, {'more_energy', 'less_stress', 'sleep_better'});
      a = a.toggleMotivation('more_energy');
      expect(a.motivations, {'less_stress', 'sleep_better'});
    });

    test('"Prefer not to say" stands alone, and any other choice drops it', () {
      var a = const SetupAnswers().toggleMotivation('more_energy').toggleMotivation(motivationPreferNotToSay);
      expect(a.motivations, {motivationPreferNotToSay});
      a = a.toggleMotivation('less_stress');
      expect(a.motivations, {'less_stress'});
    });

    test('"None of these" clears the other access answers, and the reverse', () {
      var a = const SetupAnswers().toggleAccess('pool').toggleAccess('gym_membership').toggleAccess(accessNone);
      expect(a.access, {accessNone});
      a = a.toggleAccess('pool');
      expect(a.access, {'pool'});
    });

    test('"prefer not to say" in what got in the way stands alone', () {
      var a = const SetupAnswers().toggleGotInTheWay('busier').toggleGotInTheWay(gotInTheWayPreferNotToSay);
      expect(a.gotInTheWay, {gotInTheWayPreferNotToSay});
    });

    test('leave-outs are a plain toggle, and an empty set means nothing to leave out', () {
      var a = const SetupAnswers().toggleExcluded('after_dark').toggleExcluded('swimming');
      expect(a.excluded, {'after_dark', 'swimming'});
      a = a.toggleExcluded('after_dark').toggleExcluded('swimming');
      expect(a.excluded, isEmpty);
    });

    test('the harder question shows only for "up and down" and "getting harder"', () {
      expect(const SetupAnswers(progress: Progress.goingWell).asksWhatMakesItHarder, isFalse);
      expect(const SetupAnswers(progress: Progress.upAndDown).asksWhatMakesItHarder, isTrue);
      expect(const SetupAnswers(progress: Progress.gettingHarder).asksWhatMakesItHarder, isTrue);
      expect(const SetupAnswers().asksWhatMakesItHarder, isFalse);
    });
  });

  group('leave-outs that cover something they follow (BR-011)', () {
    test('swimming', () {
      const a = SetupAnswers(keepActivity: ActivityKind.swimming, excluded: {'swimming'});
      expect(leaveOutConflicts(a), [ActivityKind.swimming]);
    });

    test('team sports covers team sports and basketball', () {
      const a = SetupAnswers(
        keepActivity: ActivityKind.basketball,
        freshChoice: ActivityKind.teamSports,
        excluded: {'team_sport'},
      );
      expect(leaveOutConflicts(a), unorderedEquals([ActivityKind.teamSports, ActivityKind.basketball]));
    });

    test('no overlap, no conflict', () {
      const a = SetupAnswers(keepActivity: ActivityKind.walking, excluded: {'swimming', 'after_dark'});
      expect(leaveOutConflicts(a), isEmpty);
      expect(leaveOutConflicts(const SetupAnswers(keepActivity: ActivityKind.swimming)), isEmpty);
    });
  });

  group('words', () {
    test('titles use the person\'s own activity, as frame 1.7 does', () {
      const a = SetupAnswers(keepActivity: ActivityKind.gym);
      expect(titleFor(SetupStep.keepProgress, a), 'How’s the gym going?');
      const typed = SetupAnswers(keepActivity: ActivityKind.other, keepCustomName: 'Padel');
      expect(titleFor(SetupStep.keepProgress, typed), 'How’s the padel going?');
    });

    test('the summary folds earlier answers, as on frames 1.8 to 1.11', () {
      const a = SetupAnswers(
        pickUpActivity: ActivityKind.running,
        stoppedAgo: StoppedAgo.months,
        gotInTheWay: {'busier'},
      );
      expect(summaryFor(SetupStep.pickUpStopped, a), 'Running');
      expect(summaryFor(SetupStep.pickUpGotInWay, a), 'Running · a few months ago');
      // The summary shows what is certain, not one of several ticked answers.
      expect(summaryFor(SetupStep.pickUpHelp, a), 'Running · a few months ago');
      expect(summaryFor(SetupStep.keepProgress, const SetupAnswers(keepActivity: ActivityKind.gym)), 'Gym');
      expect(summaryFor(SetupStep.week, a), isNull);
    });

    test('with keep going ticked, "What would you like to pick up again?" folds it into a row (frame 1.8)', () {
      const a = SetupAnswers(
        paths: {SetupPath.keepGoing, SetupPath.pickUpAgain},
        keepActivity: ActivityKind.gym,
        progress: Progress.upAndDown,
      );
      expect(summaryFor(SetupStep.pickUpWhich, a), 'Gym · up and down');
      expect(summaryFor(SetupStep.pickUpWhich, const SetupAnswers(paths: {SetupPath.pickUpAgain})), isNull);
      expect(sectionStart(SetupStep.pickUpWhich, keepGoingTicked: true), SetupStep.keepActivity);
      expect(sectionStart(SetupStep.pickUpWhich), SetupStep.pickUpWhich);
    });

    test('the add-something-new and start-fresh titles are the ones on frames 9.12 and 9.13', () {
      expect(titleFor(SetupStep.addNew, const SetupAnswers()), 'What do you already do?');
      expect(titleFor(SetupStep.startFresh, const SetupAnswers()), 'What sounds fun to you?');
    });

    test('"Edit" goes back to the start of the section', () {
      expect(sectionStart(SetupStep.keepProgress), SetupStep.keepActivity);
      expect(sectionStart(SetupStep.pickUpHelp), SetupStep.pickUpWhich);
      expect(sectionStart(SetupStep.week), SetupStep.week);
    });

    test('the "why" counter counts picks, not "prefer not to say"', () {
      expect(helperFor(SetupStep.why, const SetupAnswers(motivations: {'more_energy', 'less_stress'})),
          'Pick up to 3 · 2 of 3 picked');
      expect(helperFor(SetupStep.why, const SetupAnswers(motivations: {motivationPreferNotToSay})),
          'Pick up to 3 · 0 of 3 picked');
    });
  });
}
