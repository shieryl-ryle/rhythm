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
/// does (docs/methods.md EQ-003): a completed option and an enjoyed one are suggested a little more often, one the
/// person did not get to a little less often, and a partly done one is counted as it is. A barrier is picked up
/// only if the same one keeps coming back (EQ-009 needs three). Nothing here claims a change the rules do not
/// make, and nothing is a verdict on the person (BR-007).
String whatChangesNext({required ReflectionStatus status, int? enjoyment, Barrier? barrier}) {
  final base = switch (status) {
    ReflectionStatus.completed when enjoyment == 1 => 'Noted. We’ll keep that in mind.',
    ReflectionStatus.completed => 'Noted. We’ll suggest this one a little more often.',
    ReflectionStatus.partly when enjoyment == 3 => 'Noted. We’ll suggest this one a little more often.',
    ReflectionStatus.partly => 'Noted. Partly counts.',
    ReflectionStatus.skipped => 'Noted. We’ll suggest this one a little less often.',
    ReflectionStatus.unknown => 'Noted.',
  };
  final named = barrier != null && barrier != Barrier.preferNotToSay;
  return named ? '$base If the same thing keeps getting in the way, we’ll point it out.' : base;
}

/// What a planned card says once it has an answer.
String statusLabel(ReflectionStatus status) => switch (status) {
      ReflectionStatus.completed => 'Done',
      ReflectionStatus.partly => 'Partly',
      ReflectionStatus.skipped => 'Not this time',
      ReflectionStatus.unknown => 'Planned',
    };
