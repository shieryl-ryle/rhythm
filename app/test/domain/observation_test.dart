import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/data/library/library_models.dart';
import 'package:lilt/domain/models.dart';
import 'package:lilt/domain/observation.dart';

import '../content/guilt_words_test.dart' show neverUse;
import '../support/domain_support.dart';
import '../support/test_support.dart';

/// TC-037 (EQ-009, BR-010): 2 matching reflections give no proposal; 3 with at least 2/3 agreement do; at most
/// one new proposal a day. The wording is held to the same lists as the library (BR-001, BR-007).
void main() {
  late List<ActionInfo> actions;
  late ActionInfo friendWalk;

  setUpAll(() async {
    actions = await loadFixtureActions();
    friendWalk = actions.firstWhere((a) => a.id == 'walk_friend');
  });

  ReflectionRecord enjoyed(String day, {int? minute}) => reflect(
        day,
        ReflectionStatus.completed,
        action: friendWalk,
        enjoyment: 3,
        plannedMinute: minute,
      );

  ObservationProposal? propose(
    List<ReflectionRecord> reflections, {
    Set<String> existing = const {},
    int today = 0,
  }) =>
      proposeObservation(reflections: reflections, existingKeys: existing, proposedToday: today);

  test('2 matching reflections: no proposal', () {
    expect(propose([enjoyed('2026-10-01'), enjoyed('2026-10-02')]), isNull);
  });

  test('3 that agree: a proposal, worded from a template', () {
    final p = propose([enjoyed('2026-10-01'), enjoyed('2026-10-02'), enjoyed('2026-10-03')]);
    expect(p, isNotNull);
    expect(p!.matches, 3);
    expect(p.agreeing, 3);
    expect(p.patternKey, 'activity:walking:enjoyed'); // equal evidence: the first key by name
    expect(p.text, 'You said walking felt good');
  });

  test('2 of 3 enjoyed counts, 1 of 3 does not; "Okay" and unanswered are neutral', () {
    final two = [
      enjoyed('2026-10-01'),
      enjoyed('2026-10-02'),
      reflect('2026-10-03', ReflectionStatus.completed, action: friendWalk, enjoyment: 2),
    ];
    expect(propose(two)?.agreeing, 2);

    final one = [
      enjoyed('2026-10-01'),
      reflect('2026-10-02', ReflectionStatus.completed, action: friendWalk, enjoyment: 2),
      reflect('2026-10-03', ReflectionStatus.completed, action: friendWalk),
    ];
    expect(propose(one), isNull);
  });

  test('unknown reflections are not evidence (BR-009)', () {
    final reflections = [
      enjoyed('2026-10-01'),
      enjoyed('2026-10-02'),
      reflect('2026-10-03', ReflectionStatus.unknown, action: friendWalk),
    ];
    expect(propose(reflections), isNull);
  });

  test('at most one new proposal a day', () {
    final reflections = [enjoyed('2026-10-01'), enjoyed('2026-10-02'), enjoyed('2026-10-03')];
    expect(propose(reflections, today: 0), isNotNull);
    expect(propose(reflections, today: 1), isNull);
  });

  test('a pattern already observed, confirmed or deleted, is not proposed again', () {
    final reflections = [enjoyed('2026-10-01'), enjoyed('2026-10-02'), enjoyed('2026-10-03')];
    final first = propose(reflections)!;
    final next = propose(reflections, existing: {first.patternKey});
    expect(next?.patternKey, isNot(first.patternKey));
    expect(next?.patternKey, 'tag:free:enjoyed');
  });

  test('3 skips for the same barrier: a "gets in the way" proposal', () {
    final run = actions.firstWhere((a) => a.id == 'run_walk');
    final reflections = [
      reflect('2026-10-01', ReflectionStatus.skipped, action: run, barrier: Barrier.weather),
      reflect('2026-10-02', ReflectionStatus.skipped, action: run, barrier: Barrier.weather),
      reflect('2026-10-03', ReflectionStatus.completed, action: run, enjoyment: 2),
    ];
    final p = propose(reflections);
    expect(p?.patternKey, 'activity:running:barrier_weather');
    expect(p?.text, 'Weather often gets in the way of running');
  });

  test('different barriers or "prefer not to say" are not a pattern', () {
    final run = actions.firstWhere((a) => a.id == 'run_walk');
    final reflections = [
      reflect('2026-10-01', ReflectionStatus.skipped, action: run, barrier: Barrier.weather),
      reflect('2026-10-02', ReflectionStatus.skipped, action: run, barrier: Barrier.time),
      reflect('2026-10-03', ReflectionStatus.skipped, action: run, barrier: Barrier.preferNotToSay),
    ];
    expect(propose(reflections), isNull);
  });

  test('time of day can be a pattern', () {
    final reflections = [
      enjoyed('2026-10-01', minute: 8 * 60),
      enjoyed('2026-10-02', minute: 9 * 60),
      enjoyed('2026-10-03', minute: 10 * 60),
    ];
    final p = propose(reflections, existing: {
      'activity:walking:enjoyed',
      'tag:with_company:enjoyed',
      'tag:outdoors:enjoyed',
      'tag:free:enjoyed',
    });
    expect(p?.patternKey, 'time:morning:enjoyed');
    expect(p?.text, 'You said morning activity felt good');
  });

  test('access and leave-out tags are never a pattern', () {
    final gym = actions.firstWhere((a) => a.id == 'gym_machine');
    final reflections = [
      for (var i = 1; i <= 3; i++) reflect('2026-10-0$i', ReflectionStatus.completed, action: gym, enjoyment: 3),
    ];
    final keys = <String>{};
    var existing = <String>{};
    for (var i = 0; i < 10; i++) {
      final p = propose(reflections, existing: existing);
      if (p == null) break;
      keys.add(p.patternKey);
      existing = {...existing, p.patternKey};
    }
    expect(keys.where((k) => k.contains('needs_')), isEmpty);
    expect(keys, contains('activity:gym:enjoyed'));
  });

  test('observation wording passes the blocked-claims and never-use lists', () async {
    final claims = parseBlockedClaims(await readAssetFile(LibraryAssets.blockedClaims));
    final tags = ['solo', 'with_company', 'indoors', 'outdoors', 'free', 'paid', 'team_sport'];
    final keys = <String>[
      for (final t in tags) 'tag:$t:enjoyed',
      for (final a in ActivityKind.values.where((a) => a != ActivityKind.notSure)) 'activity:${a.code}:enjoyed',
      for (final w in ['morning', 'afternoon', 'evening']) 'time:$w:enjoyed',
      for (final b in ['time', 'low_energy', 'schedule', 'weather', 'other'])
        for (final t in tags) 'tag:$t:barrier_$b',
    ];
    for (final key in keys) {
      final text = observationText(key);
      expect(text, isNotNull, reason: key);
      for (final term in [...claims.terms, ...neverUse]) {
        expect(RegExp('\\b${RegExp.escape(term)}\\b', caseSensitive: false).hasMatch(text!), isFalse,
            reason: '$key: "$text" has "$term"');
      }
    }
  });

  test('a key in another format has no template', () {
    expect(observationText('note:mine'), isNull);
    expect(observationText('tag:mystery:enjoyed'), isNull);
  });
}
