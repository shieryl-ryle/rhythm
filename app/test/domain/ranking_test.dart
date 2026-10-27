import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/domain/models.dart';
import 'package:lilt/domain/ranking.dart';

import '../support/domain_support.dart';
import '../support/test_support.dart';

/// TC-017 (BR-009), TC-018 (BR-010), TC-019 (BR-011), TC-031 (EQ-003). The actions are in
/// `test/fixtures/ranking_actions.json`; expected orders are in `test/fixtures/expected/ranking_basic.json`.
void main() {
  late List<ActionInfo> actions;
  late Map<String, List<String>> expected;
  late Map<String, ActionInfo> byId;

  setUpAll(() async {
    actions = await loadFixtureActions();
    byId = {for (final a in actions) a.id: a};
    final json = jsonDecode(await readAssetFile('test/fixtures/expected/ranking_basic.json')) as Map<String, Object?>;
    expected = {for (final e in json.entries) e.key: List<String>.from(e.value! as List)};
  });

  List<String> ids(List<RankedAction> ranked) => [for (final r in ranked) r.action.id];

  List<RankedAction> rank(PersonContext person, {RankingRequest request = const RankingRequest()}) =>
      rankOptions(actions: actions, person: person, request: request, libraryVersion: fixtureLibraryVersion);

  // Two completed run-walks they enjoyed, a walk with a friend that was "Okay", and a skipped short walk.
  List<ReflectionRecord> history() => [
        reflect('2026-10-01', ReflectionStatus.completed, action: byId['run_walk'], enjoyment: 3),
        reflect('2026-10-03', ReflectionStatus.completed, action: byId['run_walk'], enjoyment: 3),
        reflect('2026-10-05', ReflectionStatus.completed, action: byId['walk_friend'], enjoyment: 2),
        reflect('2026-10-06', ReflectionStatus.skipped, action: byId['walk_10']),
      ];

  PersonContext withHistory({
    Set<String> excluded = const {},
    Set<String> access = const {'none'},
    Set<String> wouldHelp = const {},
    Set<String> saved = const {},
    List<ObservationInfo> observations = const [],
  }) =>
      PersonContext(
        excluded: excluded,
        access: access,
        wouldHelp: wouldHelp,
        followed: const {ActivityKind.running, ActivityKind.walking},
        savedActionIds: saved,
        observations: observations,
        reflections: history(),
      );

  group('EQ-003 order (TC-031)', () {
    test('no history: starters, followed activity first, nothing that needs access they lack', () {
      final person = const PersonContext(access: {'none'}, followed: {ActivityKind.walking});
      expect(ids(rank(person)), expected['new_person_no_access']);
    });

    test('no history, with a gym membership: the gym starter appears', () {
      final person = const PersonContext(access: {'gym_membership'}, followed: {ActivityKind.walking});
      expect(ids(rank(person)), expected['new_person_with_gym']);
    });

    test('with history: best score first, one per activity, ties by what they follow then id', () {
      expect(ids(rank(withHistory())), expected['history']);
    });

    test('scores follow the formula: 0.5 fit + 0.3 enjoy + help + bonus', () {
      final top = rank(withHistory()).first;
      expect(top.parts.fit, closeTo(0.75, 1e-9)); // (2 + 1) / (2 + 2)
      expect(top.parts.enjoy, closeTo(0.8, 1e-9)); // (6 - 2) / (2 * 2 + 1)
      expect(top.score, closeTo(0.5 * 0.75 + 0.3 * 0.8, 1e-9));
    });

    test('a time chip filters options for today only', () {
      expect(
        ids(rank(withHistory(), request: const RankingRequest(timeMin: 15))),
        expected['history_time_15'],
      );
      expect(
        ids(rank(withHistory(), request: const RankingRequest(forToday: false, timeMin: 15))),
        expected['history'],
      );
    });

    test('low energy drops high-energy actions', () {
      final person = withHistory(access: const {'courts_or_park'});
      List<RankedAction> all(Energy energy) => rankOptions(
            actions: actions,
            person: person,
            request: RankingRequest(energy: energy),
            libraryVersion: fixtureLibraryVersion,
            limit: 20,
          );
      expect(all(Energy.medium).any((r) => r.action.energyNeeded == Energy.high), isTrue);
      expect(all(Energy.low).where((r) => r.action.energyNeeded == Energy.high), isEmpty);
    });

    test('lighter mode: at most 10 minutes and low energy', () {
      expect(
        ids(rank(withHistory(), request: const RankingRequest(lighter: true))),
        expected['history_lighter'],
      );
    });

    test('"shorter sessions would help" adds 0.1 to actions of 20 minutes or less', () {
      final person = withHistory(wouldHelp: const {'shorter_sessions'});
      expect(ids(rank(person)), expected['history_help_shorter']);
    });

    test('saving an action adds 0.2', () {
      final person = withHistory(saved: const {'dance_class'});
      expect(ids(rank(person)), expected['history_saved_dance']);
    });

    test('the same input always gives the same answer', () {
      final a = ids(rank(withHistory()));
      for (var i = 0; i < 50; i++) {
        expect(ids(rank(withHistory())), a);
      }
    });
  });

  group('filters', () {
    test('a retired action (older library version) is never offered', () {
      final all = rankOptions(
        actions: actions,
        person: const PersonContext(access: {'none'}),
        request: const RankingRequest(),
        libraryVersion: fixtureLibraryVersion,
        limit: 20,
      );
      expect(ids(all), isNot(contains('old_retired')));
    });

    test('access: no answer or "none" drops every needs_* action; a matching answer allows it', () {
      List<String> offered(Set<String> access) => ids(rankOptions(
            actions: actions,
            person: PersonContext(access: access, reflections: history()),
            request: const RankingRequest(),
            libraryVersion: fixtureLibraryVersion,
            limit: 20,
          ));
      expect(offered({}), isNot(anyOf(contains('gym_machine'), contains('swim_easy'), contains('basket_game'))));
      expect(offered({'none'}), isNot(contains('gym_machine')));
      expect(offered({'gym_membership'}), contains('gym_machine'));
      expect(offered({'pool'}), contains('swim_easy'));
      expect(offered({'courts_or_park'}), contains('basket_game'));
    });

    test('"outdoors after dark" left out: no outdoor action when the suggestion is in dark hours', () {
      final person = withHistory(excluded: const {'after_dark'});
      final dark = rankOptions(
        actions: actions,
        person: person,
        request: const RankingRequest(suggestionIsDark: true),
        libraryVersion: fixtureLibraryVersion,
        limit: 20,
      );
      expect(dark.where((r) => r.action.tags.contains('outdoors')), isEmpty);
      expect(dark.where((r) => r.action.tags.contains('after_dark')), isEmpty);

      // In daylight an ordinary outdoor action is still fine; only the after_dark one is gone.
      final day = rankOptions(
        actions: actions,
        person: person,
        request: const RankingRequest(),
        libraryVersion: fixtureLibraryVersion,
        limit: 20,
      );
      expect(ids(day), contains('run_walk'));
      expect(ids(day), isNot(contains('walk_dusk')));
    });

    test('following an activity and leaving it out: the left-out one is never offered, others still are', () {
      final person = PersonContext(
        excluded: const {'swimming'},
        access: const {'pool'},
        followed: const {ActivityKind.swimming},
        reflections: history(),
      );
      final ranked = rank(person);
      expect(ranked, isNotEmpty);
      expect(ranked.where((r) => r.action.activity == ActivityKind.swimming), isEmpty);
    });
  });

  group('BR-009 (TC-017): a missing reflection does not lower a ranking', () {
    test('an accepted option with no reflection (unknown) leaves the ranking unchanged', () {
      final plain = rank(withHistory());
      final person = PersonContext(
        access: const {'none'},
        followed: const {ActivityKind.running, ActivityKind.walking},
        reflections: [
          ...history(),
          reflect('2026-10-07', ReflectionStatus.unknown, action: byId['dance_class']),
          reflect('2026-10-08', ReflectionStatus.unknown, action: byId['run_walk'], enjoyment: 1),
          reflect('2026-10-09', ReflectionStatus.unknown, action: byId['run_walk']),
        ],
      );
      final withUnknown = rank(person);
      expect(ids(withUnknown), ids(plain));
      expect([for (final r in withUnknown) r.score], [for (final r in plain) r.score]);
    });

    test('a skipped reflection, unlike an unknown one, does count', () {
      final skipped = PersonContext(
        access: const {'none'},
        followed: const {ActivityKind.running, ActivityKind.walking},
        reflections: [...history(), reflect('2026-10-07', ReflectionStatus.skipped, action: byId['run_walk'])],
      );
      expect(rank(skipped).first.parts.fit, lessThan(0.75));
    });
  });

  group('BR-010 (TC-018): only confirmed observations affect ranking', () {
    ObservationInfo obs(ObsStatus status) =>
        ObservationInfo(patternKey: 'activity:dance:enjoyed', text: 'You said dancing felt good', status: status);

    test('proposed: no change. confirmed: changes it. deleted: stops', () {
      final base = ids(rank(withHistory()));
      expect(base, expected['history']);

      expect(ids(rank(withHistory(observations: [obs(ObsStatus.proposed)]))), base);
      expect(ids(rank(withHistory(observations: [obs(ObsStatus.confirmed)]))), expected['history_observation_confirmed']);
      expect(ids(rank(withHistory(observations: [obs(ObsStatus.deleted)]))), base);
    });

    test('a confirmed "gets in the way" observation does not raise a score', () {
      const barrier = ObservationInfo(
        patternKey: 'activity:dance:barrier_time',
        text: 'Time often gets in the way of dancing',
        status: ObsStatus.confirmed,
      );
      expect(ids(rank(withHistory(observations: [barrier]))), expected['history']);
    });
  });

  test('BR-011 (TC-019): 100 runs with an excluded category never return it', () {
    final random = Random(19);
    const excludes = ['high_impact', 'team_sport', 'after_dark', 'swimming', 'running', 'walking', 'dance', 'outdoors'];
    const accessCodes = ['gym_membership', 'pool', 'courts_or_park', 'home_equipment', 'none'];
    final statuses = [ReflectionStatus.completed, ReflectionStatus.partly, ReflectionStatus.skipped, ReflectionStatus.unknown];

    for (var run = 0; run < 100; run++) {
      final excluded = {excludes[random.nextInt(excludes.length)], excludes[random.nextInt(excludes.length)]};
      final reflections = [
        for (var i = 0; i < random.nextInt(12); i++)
          reflect(
            '2026-10-${(i + 1).toString().padLeft(2, '0')}',
            statuses[random.nextInt(statuses.length)],
            action: actions[random.nextInt(actions.length)],
            enjoyment: random.nextBool() ? 1 + random.nextInt(3) : null,
          ),
      ];
      final person = PersonContext(
        excluded: excluded,
        access: {accessCodes[random.nextInt(accessCodes.length)], accessCodes[random.nextInt(accessCodes.length)]},
        savedActionIds: {actions[random.nextInt(actions.length)].id},
        reflections: reflections,
      );
      final request = RankingRequest(
        forToday: random.nextBool(),
        timeMin: random.nextBool() ? 10 + random.nextInt(50) : null,
        energy: random.nextBool() ? Energy.values[random.nextInt(3)] : null,
        lighter: random.nextInt(5) == 0,
        suggestionIsDark: random.nextBool(),
      );

      for (final r in rank(person, request: request)) {
        expect(excluded, isNot(contains(r.action.activity.code)), reason: 'run $run ${r.action.id}');
        expect(r.action.tags.any(excluded.contains), isFalse, reason: 'run $run ${r.action.id} $excluded');
      }
    }
  });
}
