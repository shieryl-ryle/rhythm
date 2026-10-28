import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/enums.dart';
import '../../data/providers.dart';
import 'setup_model.dart';
import 'setup_repository.dart';

final setupRepositoryProvider = Provider<SetupRepository>(
  (ref) => DriftSetupRepository(ref.watch(databaseProvider)),
);

/// Whether the person has finished setup. False before consent. The router sends them to `/setup` until it is
/// true.
final setupDoneProvider = FutureProvider<bool>((ref) async {
  final agreed = ref.watch(consentProvider).valueOrNull ?? false;
  if (!agreed) return false;
  return ref.watch(setupRepositoryProvider).isDone();
});

/// How long the "Finding ideas that fit you…" screen stays up at least (frame 1.15). Tests set it to zero.
final setupTransitionProvider = Provider<Duration>((ref) => const Duration(milliseconds: 1400));

class SetupState {
  const SetupState({this.answers = const SetupAnswers(), this.index = 0, this.saving = false, this.failed = false});

  final SetupAnswers answers;

  /// Position in [steps], starting at 0.
  final int index;

  /// "Finding ideas that fit you…" is showing while the answers are saved.
  final bool saving;

  /// Saving failed: nothing was stored, and the person can try again.
  final bool failed;

  List<SetupStep> get steps => stepsFor(answers.paths);
  SetupStep get step => steps[index.clamp(0, steps.length - 1)];
  bool get isLast => index >= steps.length - 1;

  SetupState copyWith({SetupAnswers? answers, int? index, bool? saving, bool? failed}) => SetupState(
        answers: answers ?? this.answers,
        index: index ?? this.index,
        saving: saving ?? this.saving,
        failed: failed ?? this.failed,
      );
}

/// The wizard's state. Answers live here, in memory, until "Show me today": leaving halfway stores nothing
/// (BR-014).
class SetupController extends AutoDisposeNotifier<SetupState> {
  @override
  SetupState build() => const SetupState();

  void _set(SetupAnswers answers) => state = state.copyWith(answers: answers);

  SetupAnswers get _a => state.answers;

  // The first question.
  void togglePath(SetupPath path) {
    final next = _a.togglePath(path);
    // The list of questions can change under the current position, so keep it inside the new list.
    final steps = stepsFor(next.paths);
    state = state.copyWith(answers: next, index: state.index.clamp(0, steps.length - 1));
  }

  // Keep going.
  void setKeepActivity(ActivityKind kind, {String? customName}) =>
      _set(_a.copyWith(keepActivity: kind, keepCustomName: customName));
  void setProgress(Progress progress) => _set(_a.copyWith(progress: progress));
  void toggleHardBecause(String code) => _set(_a.copyWith(hardBecause: SetupAnswers.toggle(_a.hardBecause, code)));

  // Add something new.
  void setAddNew(ActivityKind kind, {String? customName}) =>
      _set(_a.copyWith(addNewActivity: kind, addNewCustomName: customName));

  // Pick up again.
  void setPickUp(ActivityKind kind, {String? customName}) =>
      _set(_a.copyWith(pickUpActivity: kind, pickUpCustomName: customName));
  void setStopped(StoppedAgo ago) => _set(_a.copyWith(stoppedAgo: ago));
  void toggleGotInTheWay(String code) => _set(_a.toggleGotInTheWay(code));
  void toggleWouldHelp(String code) => _set(_a.copyWith(wouldHelp: SetupAnswers.toggle(_a.wouldHelp, code)));

  // Start fresh.
  void setFresh(ActivityKind kind) => _set(_a.copyWith(freshChoice: kind));

  // Your week, why it matters, what to leave out.
  void toggleFreeTime(String code) => _set(_a.copyWith(freeTimes: SetupAnswers.toggle(_a.freeTimes, code)));
  void toggleAccess(String code) => _set(_a.toggleAccess(code));
  void toggleBarrier(String code) => _set(_a.copyWith(barriers: SetupAnswers.toggle(_a.barriers, code)));
  void toggleMotivation(String code) => _set(_a.toggleMotivation(code));
  void toggleExcluded(String code) => _set(_a.toggleExcluded(code));
  void clearExcluded() => _set(_a.copyWith(excluded: <String>{}));

  /// Next (or Skip: the question is simply left as it is). Does nothing when the answer is required and missing.
  void next() {
    if (state.isLast || !canContinue(state.step, _a)) return;
    state = state.copyWith(index: state.index + 1);
  }

  /// Skip leaves the question unanswered: anything ticked on it is cleared, so Skip and Next are not the same.
  void skip() {
    if (state.isLast || !canSkip(state.step)) return;
    final cleared = switch (state.step) {
      SetupStep.pickUpGotInWay => _a.copyWith(gotInTheWay: <String>{}),
      SetupStep.pickUpHelp => _a.copyWith(wouldHelp: <String>{}),
      _ => _a,
    };
    state = state.copyWith(answers: cleared, index: state.index + 1);
  }

  /// Back one question. Returns false at the first one.
  bool back() {
    if (state.index == 0) return false;
    state = state.copyWith(index: state.index - 1);
    return true;
  }

  /// "Edit" on the summary row: back to the start of the section (answers are kept).
  void editSection() {
    final target = sectionStart(state.step, keepGoingTicked: _a.paths.contains(SetupPath.keepGoing));
    final at = state.steps.indexOf(target);
    if (at >= 0) state = state.copyWith(index: at);
  }

  /// After a failed save: back to the answers (nothing was stored).
  void dismissFailure() => state = state.copyWith(saving: false, failed: false);

  /// "Show me today": saves everything in one go, shows the transition for at least [setupTransitionProvider],
  /// then lets the router move on. A failure stores nothing and offers a retry.
  Future<void> finish() async {
    if (state.saving || !canContinue(state.step, _a)) return;
    state = state.copyWith(saving: true, failed: false);
    try {
      await Future.wait([
        ref.read(setupRepositoryProvider).save(_a),
        Future<void>.delayed(ref.read(setupTransitionProvider)),
      ]);
      ref.invalidate(setupDoneProvider);
    } on Object {
      state = state.copyWith(saving: false, failed: true);
    }
  }
}

final setupControllerProvider = NotifierProvider.autoDispose<SetupController, SetupState>(SetupController.new);
