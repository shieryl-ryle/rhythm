import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/data/library/library_models.dart';

import '../support/test_support.dart';

/// Content rules for the activity library (docs/methods.md DS-001, ADR-005, BR-002). The library is a
/// draft until the owner and Dzelle have reviewed it for safety and culture (PRD Q1, Q7).
void main() {
  late ActionLibrary library;

  setUpAll(() async {
    library = parseActionLibrary(await readAssetFile(LibraryAssets.actions));
  });

  test('has about 40 to 60 actions with unique ids and titles', () {
    expect(library.actions.length, inInclusiveRange(40, 60));
    expect(library.actions.map((a) => a.id).toSet(), hasLength(library.actions.length));
    expect(library.actions.map((a) => a.title).toSet(), hasLength(library.actions.length));
  });

  test('covers every activity a person can follow (setup lists in docs/data-model.md section 7)', () {
    const followable = {
      ActivityKind.walking,
      ActivityKind.running,
      ActivityKind.gym,
      ActivityKind.cycling,
      ActivityKind.swimming,
      ActivityKind.basketball,
      ActivityKind.racketSports,
      ActivityKind.teamSports,
      ActivityKind.pickleball,
      ActivityKind.yoga,
      ActivityKind.dance,
      ActivityKind.hiking,
      ActivityKind.bouldering,
      ActivityKind.pilates,
      ActivityKind.other,
    };
    final covered = library.actions.map((a) => a.activity).toSet();
    expect(followable.difference(covered), isEmpty);
    expect(covered, isNot(contains(ActivityKind.notSure)));
  });

  test('no activity is intense and every duration is short enough to start (BR-002)', () {
    for (final a in library.actions) {
      expect(Intensity.values, contains(a.intensity));
      expect(a.durationMin, inInclusiveRange(5, 90), reason: a.id);
    }
  });

  test('every action has exactly one cost, one setting and one company tag', () {
    for (final a in library.actions) {
      expect(a.tags.where((t) => t == 'free' || t == 'paid'), hasLength(1), reason: '${a.id} cost');
      expect(a.tags.where((t) => t == 'indoors' || t == 'outdoors'), hasLength(1), reason: '${a.id} setting');
      expect(a.tags.where((t) => t == 'solo' || t == 'with_company'), hasLength(1), reason: '${a.id} company');
      expect(a.tags.toSet(), hasLength(a.tags.length), reason: '${a.id} duplicate tag');
    }
  });

  test('gym and swimming actions say what access they need', () {
    for (final a in library.actions.where((a) => a.activity == ActivityKind.gym)) {
      expect(a.tags, contains('needs_gym'), reason: a.id);
    }
    for (final a in library.actions.where((a) => a.activity == ActivityKind.swimming)) {
      expect(a.tags, contains('needs_pool'), reason: a.id);
    }
  });

  test('the leave-out choices on setup (frame 1.14) each remove something', () {
    int withTag(String tag) => library.actions.where((a) => a.tags.contains(tag)).length;
    expect(withTag('after_dark'), greaterThanOrEqualTo(2));
    expect(withTag('team_sport'), greaterThanOrEqualTo(2));
    expect(withTag('high_impact'), greaterThanOrEqualTo(2));
    expect(library.actions.where((a) => a.activity == ActivityKind.swimming), isNotEmpty);
  });

  test('there are enough starters and lighter options for a person with no history (EQ-003, EV-005)', () {
    expect(library.actions.where((a) => a.isStarter).length, greaterThanOrEqualTo(10));
    // Lighter mode (UJ-004): at most 10 minutes and low energy.
    final lighter = library.actions.where((a) => a.durationMin <= 10 && a.energyNeeded == Energy.low);
    expect(lighter.length, greaterThanOrEqualTo(5));
    // Starters are gentle.
    for (final a in library.actions.where((a) => a.isStarter)) {
      expect(a.intensity, isNot(Intensity.moderate), reason: a.id);
      expect(a.durationMin, lessThanOrEqualTo(15), reason: a.id);
    }
  });

  test('similar links point at real, different actions', () {
    final ids = library.actions.map((a) => a.id).toSet();
    for (final a in library.actions) {
      expect(a.similarTo, isNotEmpty, reason: a.id);
      expect(a.similarTo.length, lessThanOrEqualTo(3), reason: a.id);
      for (final other in a.similarTo) {
        expect(ids, contains(other), reason: '${a.id} -> $other');
        expect(other, isNot(a.id), reason: a.id);
      }
    }
  });

  test('titles and descriptions are short, plain sentences', () {
    for (final a in library.actions) {
      expect(a.title.trim(), isNotEmpty, reason: a.id);
      expect(a.title.length, lessThanOrEqualTo(60), reason: a.id);
      expect(a.description.length, inInclusiveRange(15, 100), reason: a.id);
      expect(a.description, endsWith('.'), reason: a.id);
      expect(a.description, isNot(contains('!')), reason: '${a.id} keep it calm');
    }
  });
}
