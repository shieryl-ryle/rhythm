import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/data/library/library_models.dart';

import '../support/test_support.dart';

/// TC-015 (BR-007), the wording part: none of the words that make someone feel they failed appear in what
/// is shown. The list is the "Never use" list in docs/DESIGN.md (Wording list). The counting part of
/// TC-015 (`counting_test.dart`) belongs to TASK-003.
const neverUse = [
  'broke',
  'broken',
  'lost your streak',
  'streak lost',
  'failed',
  'failure',
  'missed',
  'behind',
  'lazy',
  'you should',
  "don't give up",
  'no excuses',
  'cheat day',
  'guilt',
];

RegExp _word(String term) => RegExp('\\b${RegExp.escape(term)}\\b', caseSensitive: false);

void main() {
  late ActionLibrary library;

  setUpAll(() async {
    library = parseActionLibrary(await readAssetFile(LibraryAssets.actions));
  });

  test('no library or stub text uses a never-use word', () {
    final texts = [
      for (final a in library.actions) ...a.userVisibleText.map((t) => MapEntry(a.id, t)),
    ];
    final hits = <String>[];
    for (final entry in texts) {
      for (final term in neverUse) {
        if (_word(term).hasMatch(entry.value)) hits.add('${entry.key}: "${entry.value}" contains "$term"');
      }
    }
    expect(hits, isEmpty, reason: hits.join('\n'));
  });

  test('the check works: it flags a guilt word and ignores a near miss', () {
    expect(_word('lazy').hasMatch('Feeling lazy today?'), isTrue);
    expect(_word('behind').hasMatch('You are behind'), isTrue);
    expect(_word('broke').hasMatch('A broken streak'), isFalse); // "broken" is its own term
    expect(_word('guilt').hasMatch('Guilt-free'), isTrue);
  });
}
