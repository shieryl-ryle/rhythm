/// Hard-coded library actions for the walking skeleton (TASK-001).
/// TASK-004 replaces these with the real activity library and TASK-003 with the ranking.
class StubAction {
  const StubAction({
    required this.category,
    required this.title,
    required this.when,
    required this.reason,
  });

  final String category;
  final String title;
  final String when;
  final String reason;
}

const stubActions = <StubAction>[
  StubAction(
    category: 'Running',
    title: 'Run-walk around the park',
    when: 'Suggested 12:30 · lunch',
    reason: 'Lunch runs have worked well for you.',
  ),
  StubAction(
    category: 'Gym',
    title: 'Quick 30-minute gym session',
    when: 'Suggested Sat 10:00 · weekends',
    reason: 'Short sessions fit a busy week.',
  ),
  StubAction(
    category: 'Pickleball',
    title: 'Beginner pickleball social',
    when: '45–60 min · with others',
    reason: 'You like company. Social and easy to learn.',
  ),
];
