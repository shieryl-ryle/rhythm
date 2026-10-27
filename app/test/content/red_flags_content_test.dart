import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/data/library/library_models.dart';

import '../support/test_support.dart';

/// The red-flag list (DS-002) is data for the detector in TASK-003 (EQ-008, TC-036). These tests check the
/// list is usable, and that nothing the library says would trigger the support message by itself.
void main() {
  late RedFlagList flags;
  late ActionLibrary library;

  setUpAll(() async {
    flags = parseRedFlags(await readAssetFile(LibraryAssets.redFlags));
    library = parseActionLibrary(await readAssetFile(LibraryAssets.actions));
  });

  test('has the three groups BR-003 names', () {
    expect(flags.phrases.length, inInclusiveRange(40, 140));
    expect(flags.phrases.map((p) => p.category).toSet(), {'self_harm', 'disordered_eating', 'medical_emergency'});
  });

  test('phrases are unique, lowercase and free of accents, as EQ-008 matches them', () {
    final seen = <String>{};
    for (final p in flags.phrases) {
      expect(p.phrase, p.phrase.toLowerCase());
      expect(p.phrase, matches(RegExp(r'^[a-z0-9 \-]+$')), reason: 'only plain lowercase letters: "${p.phrase}"');
      expect(p.phrase.trim(), p.phrase);
      expect(seen.add(p.phrase), isTrue, reason: 'duplicate "${p.phrase}"');
    }
  });

  test('phrases that would fire on ordinary exercise talk are not on the list', () {
    const everyday = [
      'stroke', 'hurt myself', 'cut myself', 'short of breath', 'tight chest', 'purge', 'purging',
      'stopped eating', 'passed out', 'passing out', 'kms',
    ];
    final listed = flags.phrases.map((p) => p.phrase).toSet();
    expect(listed.intersection(everyday.toSet()), isEmpty);
  });

  test('phrases are written the way EQ-008 normalises text, so apostrophes are already gone', () {
    for (final p in flags.phrases) {
      expect(p.phrase, isNot(contains("'")), reason: p.phrase);
      expect(p.phrase, isNot(contains('’')), reason: p.phrase);
    }
    final listed = flags.phrases.map((p) => p.phrase).toSet();
    expect(listed, containsAll(['cant breathe', 'dont want to live']));
  });

  test('nothing in the library text would trigger the support message', () {
    final hits = <String>[];
    for (final a in library.actions) {
      for (final text in a.userVisibleText) {
        final normalised = text.toLowerCase();
        for (final p in flags.phrases) {
          if (RegExp('\\b${RegExp.escape(p.phrase)}\\b').hasMatch(normalised)) hits.add('${a.id}: "$text" has "${p.phrase}"');
        }
      }
    }
    expect(hits, isEmpty, reason: hits.join('\n'));
  });
}
