import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/data/library/library_models.dart';
import 'package:lilt/domain/red_flags.dart';

import '../support/test_support.dart';

/// TC-036 (EQ-008, BR-003): phrase hits including uppercase, accented and apostrophe variants, and near
/// misses that must not flag.
void main() {
  late RedFlagDetector detector;

  setUpAll(() async {
    detector = RedFlagDetector(parseRedFlags(await readAssetFile(LibraryAssets.redFlags)));
  });

  group('flags', () {
    final hits = <String, String>{
      'I want to die': 'self_harm',
      'I WANT TO DIE': 'self_harm',
      "I don't want to live anymore": 'self_harm',
      'I don’t want to live anymore': 'self_harm', // curly apostrophe
      "I can't breathe": 'medical_emergency',
      'I CAN’T BREATHE': 'medical_emergency',
      'I thought I was having a stroke': 'medical_emergency',
      'chest pains when I run': 'medical_emergency',
      'I got dizzy and fainted': 'medical_emergency',
      'Pain in my chest after the hill': 'medical_emergency',
      'I keep wanting to hurt myself on purpose': 'self_harm',
      'I make myself throw up after meals': 'disordered_eating',
      'I need to earn my food today': 'disordered_eating',
      'thinking about self-harm': 'self_harm',
      'thinking about self harm': 'self_harm',
      'so much hate my body, so much': 'disordered_eating',
      'I would like to díe, I want to die': 'self_harm', // accents are folded
      'I wanted to die!': 'self_harm', // punctuation is ignored
    };
    hits.forEach((text, category) {
      test('"$text" is $category', () {
        expect(detector.check(text)?.category, category);
      });
    });
  });

  group('does not flag everyday talk', () {
    const fine = [
      'I love swimming strokes',
      'that backstroke felt good',
      'my tennis stroke is improving',
      'I hurt my knee running',
      'I hurt myself on a rock but I am ok', // injury, not self-harm: needs "on purpose"
      'cutting myself some slack today',
      'I cut myself on a climbing hold',
      'short of breath after the hill',
      'I purged my inbox',
      'I stopped eating sugar',
      'I passed out on the sofa watching a film',
      'my legs want to dive in the pool',
      'I ran 5 kms',
      'too busy this week',
      '',
    ];
    for (final text in fine) {
      test('"$text"', () {
        expect(detector.check(text), isNull);
      });
    }
    test('null text', () => expect(detector.check(null), isNull));
  });

  test('whole words only: "strokes" and "backstroke" do not match the phrase "heat stroke"', () {
    expect(detector.check('a heat stroke warning'), isNotNull);
    expect(detector.check('three heat strokes'), isNull);
  });

  test('the most urgent group comes first when several match', () {
    final hits = detector.findAll('I want to die and I make myself throw up');
    expect(hits.map((h) => h.category).toSet(), {'self_harm', 'disordered_eating'});
    expect(hits.first.category, 'self_harm');
    expect(detector.check('I want to die and I make myself throw up')!.category, 'self_harm');
  });

  test('normalisation: case, accents, apostrophes, punctuation and spaces', () {
    expect(normaliseForMatch("  Don’t   WANT, to — live!  "), 'dont want to live');
    expect(normaliseForMatch('Ça va très bien'), 'ca va tres bien');
    expect(normaliseForMatch('self-harm'), 'self-harm');
  });

  test('every listed phrase flags itself, so none is dead', () async {
    final list = parseRedFlags(await readAssetFile(LibraryAssets.redFlags));
    for (final p in list.phrases) {
      expect(detector.check('I think ${p.phrase} today'), isNotNull, reason: p.phrase);
    }
  });
}
