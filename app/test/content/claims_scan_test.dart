import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/data/library/library_models.dart';

import '../support/test_support.dart';

/// TC-009 (BR-001): no library text contains a blocked claim (DS-003). Case-insensitive, on word boundaries.
/// As more user-visible copy is added (suggestion templates, notifications, observations), add it to
/// [_allVisibleText] so it is scanned too.
RegExp _term(String term) => RegExp('\\b${RegExp.escape(term)}\\b', caseSensitive: false);

void main() {
  late BlockedClaims claims;
  late ActionLibrary library;

  setUpAll(() async {
    claims = parseBlockedClaims(await readAssetFile(LibraryAssets.blockedClaims));
    library = parseActionLibrary(await readAssetFile(LibraryAssets.actions));
  });

  List<MapEntry<String, String>> allVisibleText() => [
        for (final a in library.actions)
          for (final text in a.userVisibleText) MapEntry(a.id, text),
      ];

  test('the blocked-claims list has about 40 terms', () {
    expect(claims.terms.length, inInclusiveRange(35, 100));
    expect(claims.terms.map((t) => t.toLowerCase()).toSet(), hasLength(claims.terms.length));
  });

  test('no library text contains a blocked claim', () {
    final hits = <String>[];
    for (final entry in allVisibleText()) {
      for (final term in claims.terms) {
        if (_term(term).hasMatch(entry.value)) hits.add('${entry.key}: "${entry.value}" contains "$term"');
      }
    }
    expect(hits, isEmpty, reason: hits.join('\n'));
  });

  test('the scan itself works: it flags a blocked term in any case and ignores a near miss', () {
    expect(_term('cure').hasMatch('This will CURE you'), isTrue);
    expect(_term('lose weight').hasMatch('Lose Weight fast'), isTrue);
    expect(_term('cure').hasMatch('secure the door'), isFalse);
    expect(_term('treat').hasMatch('treatment'), isFalse); // "treatment" is its own term
    expect(claims.terms, containsAll(['cure', 'treatment', 'diagnose', 'guaranteed', 'lose weight']));
    // Word boundaries mean inflections need their own entry.
    expect(_term('calorie').hasMatch('a calorie count'), isTrue);
    expect(claims.terms, containsAll(['losing weight', 'lost weight', 'burning calories', 'calorie']));
  });

  test('no text states a body number target (BR-002)', () {
    final numeric = RegExp(
      r'\b\d+\s*(kg|kilos?|lbs?|pounds?|stone|kcal|calories|bpm|mg|steps|%)|\b(bmi|heart rate|zone \d)\b',
      caseSensitive: false,
    );
    final hits = [
      for (final e in allVisibleText())
        if (numeric.hasMatch(e.value)) '${e.key}: ${e.value}',
    ];
    expect(hits, isEmpty, reason: hits.join('\n'));
  });
}
