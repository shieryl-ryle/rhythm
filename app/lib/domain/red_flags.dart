import '../data/library/library_models.dart';

// Letters with accents, grouped by the plain letter they fold to.
const _accents = {
  'a': 'àáâãäåāăą',
  'c': 'çćĉċč',
  'd': 'ďđ',
  'e': 'èéêëēĕėęě',
  'g': 'ĝğġģ',
  'h': 'ĥħ',
  'i': 'ìíîïĩīĭįı',
  'j': 'ĵ',
  'k': 'ķ',
  'l': 'ĺļľŀł',
  'n': 'ñńņň',
  'o': 'òóôõöøōŏő',
  'r': 'ŕŗř',
  's': 'śŝşš',
  't': 'ţťŧ',
  'u': 'ùúûüũūŭůűų',
  'w': 'ŵ',
  'y': 'ýÿŷ',
  'z': 'źżž',
};

final _fold = {
  for (final e in _accents.entries)
    for (final rune in e.value.runes) String.fromCharCode(rune): e.key,
  'ß': 'ss',
};

final _apostrophes = RegExp("['’‘ʼ`´]");
final _notPlain = RegExp(r'[^a-z0-9\- ]');
final _spaces = RegExp(r' +');

/// EQ-008 normalisation: lowercase, accents stripped, straight and curly apostrophes removed ("don't" becomes
/// "dont"), other punctuation except hyphens replaced by a space, runs of spaces collapsed.
String normaliseForMatch(String text) {
  final folded = StringBuffer();
  for (final rune in text.toLowerCase().runes) {
    final ch = String.fromCharCode(rune);
    folded.write(_fold[ch] ?? ch);
  }
  return folded
      .toString()
      .replaceAll(_apostrophes, '')
      .replaceAll(_notPlain, ' ')
      .replaceAll(_spaces, ' ')
      .trim();
}

/// A red-flag match: the phrase that hit and its group (`self_harm`, `disordered_eating`, `medical_emergency`).
class RedFlagHit {
  const RedFlagHit({required this.phrase, required this.category});

  final String phrase;
  final String category;
}

/// EQ-008, BR-003: free text that contains a red-flag phrase gets the support message and nothing else: no
/// suggestion, the text is not stored, and no AI call is made. This class only decides; the screens act on it.
class RedFlagDetector {
  RedFlagDetector(RedFlagList list)
      : _phrases = [
          for (final p in list.phrases) (phrase: normaliseForMatch(p.phrase), category: p.category),
        ];

  final List<({String phrase, String category})> _phrases;

  // If more than one group matches, the support message for the first group here is shown.
  static const _priority = ['self_harm', 'medical_emergency', 'disordered_eating'];

  /// Every phrase found in [text], most urgent group first.
  List<RedFlagHit> findAll(String? text) {
    if (text == null || text.trim().isEmpty) return const [];
    // Padding with spaces makes "contains" a whole-word match, so "stroke" does not match "backstroke".
    final padded = ' ${normaliseForMatch(text)} ';
    final hits = [
      for (final p in _phrases)
        if (p.phrase.isNotEmpty && padded.contains(' ${p.phrase} '))
          RedFlagHit(phrase: p.phrase, category: p.category),
    ];
    int rank(RedFlagHit h) {
      final i = _priority.indexOf(h.category);
      return i < 0 ? _priority.length : i;
    }

    hits.sort((a, b) => rank(a).compareTo(rank(b)));
    return hits;
  }

  /// The most urgent hit, or null when the text is fine.
  RedFlagHit? check(String? text) {
    final hits = findAll(text);
    return hits.isEmpty ? null : hits.first;
  }
}
