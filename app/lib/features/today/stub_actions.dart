/// Hard-coded library actions for the walking skeleton (TASK-001).
///
/// The reasons and times are deliberately neutral: they claim nothing about the person, who has
/// only just consented (BR-004). TASK-004 replaces these with the real activity library and
/// TASK-003 with the ranking and the per-person reasons.
class StubAction {
  const StubAction({
    required this.category,
    required this.title,
    required this.detail,
    required this.reason,
  });

  final String category;
  final String title;
  final String detail;
  final String reason;
}

const stubActions = <StubAction>[
  StubAction(
    category: 'Running',
    title: 'Run-walk around the park',
    detail: '20 min',
    reason: 'A gentle way to get moving.',
  ),
  StubAction(
    category: 'Gym',
    title: 'Quick 30-minute gym session',
    detail: '30 min',
    reason: 'A short session that fits most days.',
  ),
  StubAction(
    category: 'Pickleball',
    title: 'Beginner pickleball social',
    detail: '45–60 min · with others',
    reason: 'Social and easy to learn.',
  ),
];
