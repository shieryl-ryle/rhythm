import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/domain/models.dart';
import 'package:lilt/domain/ranking.dart';
import 'package:lilt/domain/reasons.dart';

import '../support/domain_support.dart';

/// TC-032 (EQ-004, BR-004): each dominant term yields its template, and a reason never cites something the
/// person did not do or say.
void main() {
  whyThisTests();
  late List<ActionInfo> actions;
  late Map<String, ActionInfo> byId;

  setUpAll(() async {
    actions = await loadFixtureActions();
    byId = {for (final a in actions) a.id: a};
  });

  Reason reasonFor(String actionId, PersonContext person, {RankingRequest request = const RankingRequest()}) {
    // The ranker keeps one action per activity, so drop its rivals to see this action's reason.
    final target = byId[actionId]!;
    final ranked = rankOptions(
      actions: [for (final a in actions) if (a.id == actionId || a.activity != target.activity) a],
      person: person,
      request: request,
      libraryVersion: fixtureLibraryVersion,
      limit: 20,
    );
    return ranked.firstWhere((r) => r.action.id == actionId).reason;
  }

  ReflectionRecord someHistory() => reflect('2026-10-01', ReflectionStatus.completed, action: byId['dance_class']);

  test('fit: "You managed this before"', () {
    final person = PersonContext(
      access: const {'none'},
      reflections: [reflect('2026-10-01', ReflectionStatus.completed, action: byId['run_walk'])],
    );
    expect(reasonFor('run_walk', person), isA<Reason>().having((r) => r.text, 'text', 'You managed this before'));
  });

  test('enjoy: "You said this felt good" when enjoyment outweighs fit', () {
    final person = PersonContext(
      access: const {'none'},
      reflections: [
        reflect('2026-10-01', ReflectionStatus.partly, action: byId['walk_friend'], enjoyment: 3),
        reflect('2026-10-02', ReflectionStatus.partly, action: byId['walk_friend'], enjoyment: 3),
        reflect('2026-10-03', ReflectionStatus.partly, action: byId['walk_friend'], enjoyment: 3),
        reflect('2026-10-04', ReflectionStatus.partly, action: byId['walk_friend'], enjoyment: 3),
      ],
    );
    final r = reasonFor('walk_friend', person);
    // fit = (2 + 1) / (4 + 2) = 0.5 -> 0.25 ; enjoy = 8 / 9 -> 0.267: enjoy wins.
    expect(r.code, 'enjoy');
    expect(r.text, 'You said this felt good');
  });

  test('observation: the confirmed observation text', () {
    final person = PersonContext(
      access: const {'none'},
      reflections: [someHistory()],
      observations: const [
        ObservationInfo(
          patternKey: 'tag:solo:enjoyed',
          text: 'You said doing things on your own felt good',
          status: ObsStatus.confirmed,
        ),
      ],
    );
    final r = reasonFor('yoga_stretch', person);
    expect(r.code, 'observation');
    expect(r.text, 'You said doing things on your own felt good');
  });

  test('saved: "You saved this"', () {
    final person = PersonContext(access: const {'none'}, savedActionIds: const {'yoga_stretch'}, reflections: [someHistory()]);
    expect(reasonFor('yoga_stretch', person).text, 'You saved this');
  });

  test('help: shorter sessions and company', () {
    final shorter = PersonContext(access: const {'none'}, wouldHelp: const {'shorter_sessions'}, reflections: [someHistory()]);
    expect(reasonFor('yoga_stretch', shorter).text, 'You said shorter sessions would help');

    final company = PersonContext(access: const {'none'}, wouldHelp: const {'someone_to_go_with'}, reflections: [someHistory()]);
    expect(reasonFor('dance_class', company).code, isNot('help_company')); // it has its own history
    expect(reasonFor('walk_friend', company).text, 'You said company would help');
  });

  test('similar: a new action names the liked action it resembles (BR-004)', () {
    final person = PersonContext(
      access: const {'none'},
      reflections: [reflect('2026-10-01', ReflectionStatus.completed, action: byId['yoga_stretch'], enjoyment: 3)],
    );
    // dance_class is new to them and similar_to yoga_stretch, which they enjoyed.
    expect(reasonFor('dance_class', person).text, 'Similar to Ten minutes of gentle stretching, which you enjoyed');
  });

  test('similar wins for a new action even when it is also saved or short (BR-004, F-002)', () {
    final person = PersonContext(
      access: const {'none'},
      savedActionIds: const {'dance_class'},
      wouldHelp: const {'shorter_sessions'},
      reflections: [reflect('2026-10-01', ReflectionStatus.completed, action: byId['yoga_stretch'], enjoyment: 3)],
    );
    expect(reasonFor('dance_class', person).code, 'similar');
  });

  test('similar is not claimed for something they did not enjoy', () {
    final person = PersonContext(
      access: const {'none'},
      reflections: [reflect('2026-10-01', ReflectionStatus.completed, action: byId['yoga_stretch'], enjoyment: 2)],
    );
    expect(reasonFor('dance_class', person).code, isNot('similar'));
  });

  test('lighter mode: "Short and gentle for today"', () {
    final person = PersonContext(access: const {'none'}, reflections: [someHistory()]);
    expect(
      reasonFor('walk_10', person, request: const RankingRequest(lighter: true)).text,
      'Short and gentle for today',
    );
  });

  test('company: "You like company" needs the motivation they chose', () {
    final liked = PersonContext(access: const {'none'}, motivations: const {'time_with_people'}, reflections: [someHistory()]);
    expect(reasonFor('walk_friend', liked).text, 'You like company');

    final other = PersonContext(access: const {'none'}, motivations: const {'more_energy'}, reflections: [someHistory()]);
    expect(reasonFor('walk_friend', other).text, 'Social and easy to learn');
  });

  test('starter: "A small way to begin"', () {
    final person = const PersonContext(access: {'none'});
    expect(reasonFor('walk_10', person).text, 'A small way to begin');
  });

  test('neutral lines claim nothing about the person', () {
    final person = PersonContext(access: const {'none'}, reflections: [someHistory()]);
    expect(reasonFor('run_walk', person).text, 'A gentle way to get moving');
    expect(reasonFor('walk_friend', person).text, 'Social and easy to learn');
  });

  test('"gentle" is not said of an action that needs high energy', () {
    final person = PersonContext(access: const {'courts_or_park'}, reflections: [someHistory()]);
    final r = reasonFor('basket_game', person);
    expect(r.code, 'neutral');
    expect(r.text, isNot(contains('gentle')));
  });

  test('a skipped action never gets "You managed this before"', () {
    final person = PersonContext(
      access: const {'none'},
      reflections: [reflect('2026-10-01', ReflectionStatus.skipped, action: byId['run_walk'])],
    );
    expect(reasonFor('run_walk', person).code, isNot('fit'));
  });

  test('the largest term wins: fit over a save', () {
    final person = PersonContext(
      access: const {'none'},
      savedActionIds: const {'run_walk'},
      reflections: [
        reflect('2026-10-01', ReflectionStatus.completed, action: byId['run_walk']),
        reflect('2026-10-02', ReflectionStatus.completed, action: byId['run_walk']),
      ],
    );
    expect(reasonFor('run_walk', person).code, 'fit'); // 0.5 * 0.75 = 0.375 against 0.2 for the save
  });
}

/// "Why this?" lists every reason that applies; the first is the one on the card (BR-004).
void whyThisTests() {
  late List<ActionInfo> actions;
  late Map<String, ActionInfo> byId;

  setUpAll(() async {
    actions = await loadFixtureActions();
    byId = {for (final a in actions) a.id: a};
  });

  RankedAction rankedFor(String actionId, PersonContext person) {
    final target = byId[actionId]!;
    return rankOptions(
      actions: [for (final a in actions) if (a.id == actionId || a.activity != target.activity) a],
      person: person,
      request: const RankingRequest(),
      libraryVersion: fixtureLibraryVersion,
      limit: 20,
    ).firstWhere((r) => r.action.id == actionId);
  }

  test('the card shows the first of the list, and the list has no repeats', () {
    final person = PersonContext(
      access: const {'none'},
      wouldHelp: const {'shorter_sessions'},
      reflections: [reflect('2026-10-01', ReflectionStatus.completed, action: byId['yoga_stretch'])],
    );
    final r = rankedFor('yoga_stretch', person);
    expect(r.reasons.first.code, r.reason.code);
    expect(r.reasons.map((x) => x.code).toSet().length, r.reasons.length);
    // Each reason is one a rule allows (BR-004): the done term and the help term, both resting on something said.
    expect(r.reasons.map((x) => x.code), containsAll(['fit', 'help_shorter']));
  });

  test('strongest first: what they did outweighs what they said would help', () {
    final person = PersonContext(
      access: const {'none'},
      wouldHelp: const {'shorter_sessions'},
      reflections: [reflect('2026-10-01', ReflectionStatus.completed, action: byId['yoga_stretch'])],
    );
    final codes = rankedFor('yoga_stretch', person).reasons.map((x) => x.code).toList();
    expect(codes.indexOf('fit'), lessThan(codes.indexOf('help_shorter')));
  });

  test('the neutral line stands alone: it is only used when nothing else applies', () {
    final ranked = rankOptions(
      actions: actions,
      person: const PersonContext(access: {'none'}),
      request: const RankingRequest(),
      libraryVersion: fixtureLibraryVersion,
      limit: 100,
      startersFirst: false,
    );
    expect(ranked, isNotEmpty);
    for (final r in ranked) {
      if (r.reasons.any((x) => x.code == 'neutral')) expect(r.reasons, hasLength(1), reason: r.action.id);
    }
  });
}
