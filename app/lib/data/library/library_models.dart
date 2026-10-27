import 'dart:convert';

import '../enums.dart';

/// Where the bundled library files live (docs/methods.md DS-001 to DS-003).
abstract final class LibraryAssets {
  static const actions = 'assets/library/actions.json';
  static const redFlags = 'assets/library/red_flags.json';
  static const blockedClaims = 'assets/library/blocked_claims.json';
}

/// One curated activity (DS-001). Becomes a row in the `action` table.
class LibraryAction {
  const LibraryAction({
    required this.id,
    required this.activity,
    required this.title,
    required this.description,
    required this.durationMin,
    required this.intensity,
    required this.energyNeeded,
    required this.tags,
    required this.isStarter,
    required this.similarTo,
  });

  final String id;
  final ActivityKind activity;
  final String title;
  final String description;
  final int durationMin;
  final Intensity intensity;
  final Energy energyNeeded;
  final List<String> tags;
  final bool isStarter;
  final List<String> similarTo;

  /// Every string a person can read, for the content scans (TC-009, TC-015).
  List<String> get userVisibleText => [title, description];

  factory LibraryAction.fromJson(Map<String, Object?> json) {
    final id = json['id'];
    try {
      return LibraryAction(
        id: json['id']! as String,
        activity: _byCode(ActivityKind.values, json['activity']! as String),
        title: json['title']! as String,
        description: json['description']! as String,
        durationMin: json['duration_min']! as int,
        intensity: _byCode(Intensity.values, json['intensity']! as String),
        energyNeeded: _byCode(Energy.values, json['energy_needed']! as String),
        tags: List<String>.from(json['tags']! as List),
        isStarter: json['is_starter']! as bool,
        similarTo: List<String>.from(json['similar_to']! as List),
      );
    } on Object catch (e) {
      throw FormatException('Invalid library action "$id": $e');
    }
  }
}

class ActionLibrary {
  const ActionLibrary({required this.version, required this.tagCodes, required this.actions});

  final String version;
  final List<String> tagCodes;
  final List<LibraryAction> actions;
}

/// A phrase that routes the person to the support message instead of a suggestion (BR-003, DS-002).
class RedFlagPhrase {
  const RedFlagPhrase({required this.phrase, required this.category});

  final String phrase;
  final String category;
}

class RedFlagList {
  const RedFlagList({required this.version, required this.phrases});

  final String version;
  final List<RedFlagPhrase> phrases;
}

/// Terms that must never appear in anything shown (BR-001, DS-003).
class BlockedClaims {
  const BlockedClaims({required this.version, required this.terms});

  final String version;
  final List<String> terms;
}

T _byCode<T extends Enum>(List<T> values, String code) => values.firstWhere(
      (v) => (v as Coded).code == code,
      orElse: () => throw FormatException('Unknown ${T.toString()} code "$code"'),
    );

Map<String, Object?> _object(String source) {
  final decoded = jsonDecode(source);
  if (decoded is! Map<String, Object?>) throw const FormatException('Expected a JSON object');
  return decoded;
}

ActionLibrary parseActionLibrary(String source) {
  final json = _object(source);
  return ActionLibrary(
    version: json['library_version']! as String,
    tagCodes: List<String>.from(json['tag_codes']! as List),
    actions: (json['actions']! as List)
        .map((e) => LibraryAction.fromJson(e! as Map<String, Object?>))
        .toList(),
  );
}

RedFlagList parseRedFlags(String source) {
  final json = _object(source);
  return RedFlagList(
    version: json['version']! as String,
    phrases: (json['phrases']! as List).map((e) {
      final m = e! as Map<String, Object?>;
      return RedFlagPhrase(phrase: m['phrase']! as String, category: m['category']! as String);
    }).toList(),
  );
}

BlockedClaims parseBlockedClaims(String source) {
  final json = _object(source);
  return BlockedClaims(
    version: json['version']! as String,
    terms: List<String>.from(json['terms']! as List),
  );
}
