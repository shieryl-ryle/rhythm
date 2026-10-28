import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/data/library/library_models.dart';
import 'package:lilt/features/starting_point/setup_copy.dart';
import 'package:lilt/features/starting_point/setup_model.dart';

import '../content/guilt_words_test.dart' show neverUse;
import '../support/test_support.dart';

/// The setup words are held to the same lists as the library (BR-001, BR-007), and the codes match
/// docs/data-model.md §7.
void main() {
  late BlockedClaims claims;

  setUpAll(() async {
    claims = parseBlockedClaims(await readAssetFile(LibraryAssets.blockedClaims));
  });

  List<String> allText() => [
        for (final o in pathOptions) ...[o.label, ?o.subtitle],
        for (final e in activityCatalogue) ...[e.label, e.blurb],
        for (final o in freshOptions) o.label,
        for (final o in progressOptions) o.label,
        for (final o in hardBecauseOptions) o.label,
        for (final o in stoppedOptions) o.label,
        for (final o in gotInTheWayOptions) o.label,
        for (final o in wouldHelpOptions) o.label,
        for (final o in freeTimeOptions) o.label,
        for (final o in accessOptions) o.label,
        for (final o in barrierOptions) o.label,
        for (final o in motivationOptions) o.label,
        for (final o in leaveOutOptions) o.label,
        for (final s in SetupStep.values) ...[titleFor(s, const SetupAnswers(keepActivity: ActivityKind.gym)), ?helperFor(s, const SetupAnswers()), ?eyebrowFor(s)],
      ];

  test('no setup text contains a blocked claim or a never-use word', () {
    final hits = <String>[];
    for (final text in allText()) {
      for (final term in [...claims.terms, ...neverUse]) {
        if (RegExp('\\b${RegExp.escape(term)}\\b', caseSensitive: false).hasMatch(text)) {
          hits.add('"$text" has "$term"');
        }
      }
    }
    expect(hits, isEmpty, reason: hits.join('\n'));
  });

  test('the words written in the screens are held to the same lists (setup, search and S-090)', () {
    final literal = RegExp(r"'((?:[^'\\\n]|\\.)+)'");
    final hits = <String>[];
    for (final file in [
      'lib/features/starting_point/setup_screen.dart',
      'lib/features/starting_point/activity_search_screen.dart',
      'lib/features/support/support_screen.dart',
      'lib/features/starting_point/setup_model.dart',
      'lib/features/today/today_screen.dart',
      'lib/features/today/option_cards.dart',
      'lib/features/today/today_sheets.dart',
      'lib/features/today/today_logic.dart',
      'lib/app/app_shell.dart',
    ]) {
      for (final m in literal.allMatches(File(file).readAsStringSync())) {
        final text = m.group(1)!;
        if (!text.contains(' ')) continue; // codes and identifiers, not sentences
        for (final term in [...claims.terms, ...neverUse]) {
          if (RegExp('\\b${RegExp.escape(term)}\\b', caseSensitive: false).hasMatch(text)) {
            hits.add('$file: "$text" has "$term"');
          }
        }
      }
    }
    expect(hits, isEmpty, reason: hits.join('\n'));
  });

  test('the hints above a grey Next are held to the same lists too', () {
    for (final s in SetupStep.values) {
      final hint = requiredHint(s);
      if (hint == null) continue;
      for (final term in [...claims.terms, ...neverUse]) {
        expect(RegExp('\\b${RegExp.escape(term)}\\b', caseSensitive: false).hasMatch(hint), isFalse, reason: hint);
      }
    }
  });

  test('codes match docs/data-model.md §7', () {
    expect(hardBecauseOptions.map((o) => o.value), ['finding_time', 'energy', 'getting_bored', 'cost', 'motivation']);
    expect(gotInTheWayOptions.map((o) => o.value),
        ['busier', 'health_energy', 'moved', 'group_or_gym_changed', 'just_drifted', 'prefer_not_to_say']);
    expect(wouldHelpOptions.map((o) => o.value),
        ['shorter_sessions', 'someone_to_go_with', 'different_time', 'something_similar', 'not_sure']);
    expect(freeTimeOptions.map((o) => o.value), ['early_morning', 'lunch', 'after_work', 'weekends']);
    expect(accessOptions.map((o) => o.value), ['gym_membership', 'pool', 'courts_or_park', 'home_equipment', 'none']);
    expect(barrierOptions.map((o) => o.value), ['time', 'energy', 'money', 'weather', 'motivation']);
    expect(motivationOptions.map((o) => o.value), [
      'more_energy', 'less_stress', 'sleep_better', 'time_with_people', 'feel_stronger', 'be_there_for_family',
      'just_for_fun', 'prefer_not_to_say',
    ]);
    expect(leaveOutOptions.map((o) => o.value), ['after_dark', 'team_sport', 'high_impact', 'swimming']);
    // Frame 9.13: eight chips.
    expect(freshOptions.map((o) => o.value), [
      ActivityKind.walking,
      ActivityKind.dance,
      ActivityKind.cycling,
      ActivityKind.swimming,
      ActivityKind.teamSports,
      ActivityKind.racketSports,
      ActivityKind.yoga,
      ActivityKind.notSure,
    ]);
  });

  test('the activity chips are the ones on the frames', () {
    expect(keepGoingKinds.map((k) => k.code),
        ['walking', 'running', 'gym', 'cycling', 'swimming', 'basketball', 'racket_sports', 'yoga']);
    expect(addNewKinds.map((k) => k.code), ['walking', 'running', 'gym', 'cycling', 'swimming', 'yoga']);
    expect(pickUpKinds.map((k) => k.code), ['running', 'gym', 'swimming', 'cycling', 'basketball', 'yoga', 'dance']);
  });

  test('every chip activity is in the catalogue, so the search and the chips agree', () {
    for (final k in [...keepGoingKinds, ...addNewKinds, ...pickUpKinds]) {
      expect(catalogueEntry(k), isNotNull, reason: k.code);
    }
  });

  test('every leave-out that is an activity names a real activity kind', () {
    final kinds = {for (final k in ActivityKind.values) k.code};
    expect(kinds, contains('swimming'));
  });
}
