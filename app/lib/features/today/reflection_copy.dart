import '../../data/enums.dart';

/// The words of the Reflection sheet (S-101, docs/data-model.md §7, frame 3.11): the three answers, the barrier
/// chips and the enjoyment segments. Codes are what is stored.
class ReflectionChoice {
  const ReflectionChoice(this.status, this.label);

  final ReflectionStatus status;
  final String label;
}

const reflectionChoices = [
  ReflectionChoice(ReflectionStatus.completed, 'Done'),
  ReflectionChoice(ReflectionStatus.partly, 'Partly'),
  ReflectionChoice(ReflectionStatus.skipped, 'Didn’t get to it'),
];

/// "What got in the way? (optional)", asked only after Partly or Didn't get to it (BR-008). "Prefer not to say" is
/// one of the options.
const barrierChoices = [
  (Barrier.time, 'Time'),
  (Barrier.lowEnergy, 'Low energy'),
  (Barrier.schedule, 'Didn’t fit my schedule'),
  (Barrier.weather, 'Weather'),
  (Barrier.other, 'Other'),
  (Barrier.preferNotToSay, 'Prefer not to say'),
];

/// "How was it? (optional)": 1 Not for me, 2 Okay, 3 Enjoyed it.
const enjoymentChoices = [
  (1, 'Not for me'),
  (2, 'Okay'),
  (3, 'Enjoyed it'),
];

/// After saving, one sentence says what Lilt will change (docs/prd.md F-003). It says only what the ranking really
/// does (docs/methods.md EQ-003, EQ-012): a completed option, with no rating or a good one, goes up (fit rises
/// whatever the earlier history), one the person did not get to goes down (fit always falls), and everything else
/// is acknowledged without promising a change. A barrier gets no promise: observations are not shown yet
/// (F-004), and EQ-009 only counts barriers on options not done. Nothing is a verdict on the person (BR-007).
String whatChangesNext({required ReflectionStatus status, int? enjoyment, Barrier? barrier}) =>
    switch (status) {
      // "Not for me" and "Okay" add nothing to the score (EQ-003: the enjoyment term is 0 for a 1), so no change is promised.
      ReflectionStatus.completed when enjoyment == 1 || enjoyment == 2 => 'Thanks for telling us.',
      ReflectionStatus.completed => 'We’ll suggest this one a little more often.',
      ReflectionStatus.partly when enjoyment == 3 => 'Partly counts, and you enjoyed it.',
      ReflectionStatus.partly => 'Partly counts.',
      ReflectionStatus.skipped => 'We’ll suggest this one a little less often.',
      ReflectionStatus.unknown => 'Thanks for telling us.',
    };

/// What a planned card says once it has an answer.
String statusLabel(ReflectionStatus status) => switch (status) {
      ReflectionStatus.completed => 'Done',
      ReflectionStatus.partly => 'Partly done',
      ReflectionStatus.skipped => 'Not this time',
      ReflectionStatus.unknown => 'Planned',
    };

/// The line under an answered card, from the wording list in docs/DESIGN.md (frame 2.6).
String affirmation(ReflectionStatus status) =>
    status == ReflectionStatus.skipped ? 'Rest counts too.' : 'Any amount counts.';
