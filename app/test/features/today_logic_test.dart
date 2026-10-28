import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/domain/models.dart';
import 'package:lilt/domain/ranking.dart';
import 'package:lilt/features/today/today_logic.dart';

import '../support/domain_support.dart';

/// What Today shows: the suggested time, the options, and the two "nothing fits" states
/// (docs/sitemap.md "S-004 when few or no options fit", docs/methods.md EQ-003).
void main() {
  // Friday 23 October 2026.
  DateTime at(int h, int m, {int day = 23}) => DateTime(2026, 10, day, h, m);

  group('suggested time', () {
    test('the next free slot today', () {
      expect(upcomingSlots({'lunch', 'after_work'}, at(10, 0)).first.clock, '12:30');
      expect(upcomingSlots({'lunch', 'after_work'}, at(13, 0)).first.clock, '18:30');
      expect(upcomingSlots({'lunch', 'after_work'}, at(13, 0)).first.day, '2026-10-23');
    });

    test('a slot that has started is skipped, so Today never suggests the past', () {
      final slots = upcomingSlots({'lunch'}, at(12, 30));
      expect(slots.first.day, '2026-10-24');
    });

    test('after the last slot, the next morning', () {
      final slots = upcomingSlots({'early_morning', 'lunch'}, at(20, 0));
      expect(slots.first.day, '2026-10-24');
      expect(slots.first.clock, '07:00');
    });

    test('"weekends" is Saturday at 10:00, and only Saturday', () {
      final slots = upcomingSlots({'weekends'}, at(9, 0)); // a Friday
      expect(slots.first.day, '2026-10-24');
      expect(slots.first.clock, '10:00');
      // Two weeks ahead, so a weekends-only person always has a second Saturday for the next card.
      expect(slots.map((s) => s.day).toSet(), {'2026-10-24', '2026-10-31'});
    });

    test('no free time given: no slot', () {
      expect(upcomingSlots({}, at(9, 0)), isEmpty);
    });

    test('labels read like the frames', () {
      final lunch = upcomingSlots({'lunch', 'weekends'}, at(9, 0));
      String plain(String s) => s.replaceAll('\u00A0', ' '); // non-breaking spaces keep the label together
      expect(plain(suggestedLabel(lunch.first, '2026-10-23')), 'Suggested 12:30 · lunch');
      expect(plain(suggestedLabel(lunch[1], '2026-10-23')), 'Suggested Sat 10:00 · weekends');
    });

    test('18:30 is dark and 07:00 is not, for the after-dark leave-out [assumption]', () {
      expect(upcomingSlots({'after_work'}, at(9, 0)).first.isDark, isTrue);
      expect(upcomingSlots({'early_morning'}, at(1, 0)).first.isDark, isFalse);
    });
  });

  group('the plan', () {
    late List<ActionInfo> actions;

    setUpAll(() async => actions = await loadFixtureActions());

    ActionInfo only(String id, {int? minutes, Energy? energy}) {
      final a = actions.firstWhere((a) => a.id == id);
      return ActionInfo(
        id: a.id,
        activity: a.activity,
        title: a.title,
        durationMin: minutes ?? a.durationMin,
        energyNeeded: energy ?? a.energyNeeded,
        tags: a.tags,
        isStarter: true,
        similarTo: a.similarTo,
        libraryVersion: a.libraryVersion,
      );
    }

    TodayPlan plan(
      List<ActionInfo> pool, {
      PersonContext person = const PersonContext(access: {'none'}),
      TodayChips chips = const TodayChips(),
      List<ActivityKind> followed = const [],
      bool lighter = false,
    }) =>
        buildTodayPlan(
          actions: pool,
          person: person,
          libraryVersion: fixtureLibraryVersion,
          followedOrder: followed,
          freeTimes: const {'lunch', 'weekends'},
          chips: chips,
          now: at(9, 0),
          lighter: lighter,
        );

    test('the chips default to 20 minutes and medium energy (frame 2.3)', () {
      expect(const TodayChips(), const TodayChips(timeMin: 20, energy: Energy.medium));
    });

    test('options: the hero cycles the ranker\'s options, one per activity, with the next free slot', () {
      final p = plan(actions, followed: [ActivityKind.walking, ActivityKind.yoga]);
      expect(p.kind, TodayKind.options);
      expect(p.hero, isNotEmpty);
      expect({for (final h in p.hero) h.ranked.action.activity}.length, p.hero.length);
      expect(p.hero.first.slot!.clock, '12:30');
    });

    test('compact cards are the other followed activities, never the one the hero shows', () {
      final p = plan(
        actions,
        followed: [ActivityKind.walking, ActivityKind.yoga, ActivityKind.running],
        person: PersonContext(
          access: const {'none'},
          followed: const {ActivityKind.walking, ActivityKind.yoga, ActivityKind.running},
          reflections: [reflect('2026-10-01', ReflectionStatus.completed, action: actions.firstWhere((a) => a.id == 'run_walk'), enjoyment: 3)],
        ),
      );
      final shown = p.hero.first.ranked.action.activity;
      final compact = p.compactCards(shown);
      expect(compact.length, lessThanOrEqualTo(maxCompactCards));
      expect(compact.map((c) => c.ranked.action.activity), isNot(contains(shown)));
      for (final other in [ActivityKind.walking, ActivityKind.yoga, ActivityKind.running]) {
        expect(p.compactCards(other).map((c) => c.ranked.action.activity), isNot(contains(other)));
      }
    });

    test('lighter mode: at most 10 minutes and low energy', () {
      final p = plan(actions, lighter: true);
      expect(p.kind, TodayKind.options);
      for (final h in p.hero) {
        expect(h.ranked.action.durationMin, lessThanOrEqualTo(10));
        expect(h.ranked.action.energyNeeded, Energy.low);
      }
    });

    group('state N2: the chips are the cause', () {
      test('time is the cause: raise it first', () {
        final p = plan([only('run_walk', minutes: 20, energy: Energy.medium)], chips: const TodayChips(timeMin: 10));
        expect(p.kind, TodayKind.nothingFitsChips);
        expect(p.relaxation!.label, 'Show options up to 20 min');
        expect(p.relaxation!.chips, const TodayChips(timeMin: 20, energy: Energy.medium));
      });

      test('energy is the cause: raise it', () {
        final p = plan(
          [only('basket_game', minutes: 15, energy: Energy.high)],
          chips: const TodayChips(timeMin: 20, energy: Energy.low),
          person: const PersonContext(access: {'courts_or_park'}),
        );
        expect(p.kind, TodayKind.nothingFitsChips);
        expect(p.relaxation!.label, 'Show medium-energy options');
        expect(p.relaxation!.chips.energy, Energy.medium);
      });

      test('both are the cause: any time and energy', () {
        final p = plan(
          [only('basket_game', minutes: 40, energy: Energy.high)],
          chips: const TodayChips(timeMin: 10, energy: Energy.low),
          person: const PersonContext(access: {'courts_or_park'}),
        );
        expect(p.kind, TodayKind.nothingFitsChips);
        expect(p.relaxation!.label, 'Show options for any time and energy');
      });

      test('if even 45 minutes and high energy bring nothing back, it is not a chips problem (N3)', () {
        final p = plan(
          [only('run_walk', minutes: 60, energy: Energy.medium)],
          chips: const TodayChips(timeMin: 10),
        );
        expect(p.kind, TodayKind.nothingFitsChoices, reason: 'a button that changes nothing would be a trap');
      });

      test('the relaxation really brings an option back', () {
        final pool = [only('run_walk', minutes: 20, energy: Energy.medium)];
        final p = plan(pool, chips: const TodayChips(timeMin: 10));
        final again = plan(pool, chips: p.relaxation!.chips);
        expect(again.kind, TodayKind.options);
      });
    });

    test('a compact card can say "Similar to ..." about an action of another activity', () {
      // yoga_stretch is similar to walk_10, and the person enjoyed walk_10; dance_class is similar to yoga_stretch.
      final walk = actions.firstWhere((a) => a.id == 'walk_10');
      final p = plan(
        actions,
        person: PersonContext(
          access: const {'none'},
          followed: const {ActivityKind.walking, ActivityKind.yoga},
          reflections: [reflect('2026-10-01', ReflectionStatus.completed, action: walk, enjoyment: 3)],
        ),
        followed: [ActivityKind.walking, ActivityKind.yoga],
      );
      final yoga = p.others.firstWhere((o) => o.ranked.action.activity == ActivityKind.yoga);
      expect(yoga.ranked.reason.code, 'similar');
      expect(yoga.ranked.reason.text, 'Similar to ${walk.title}, which you enjoyed');
    });

    test('slots for the compact cards skip the hero\'s own activity, so each card has a distinct time', () {
      final p = plan(actions, followed: [ActivityKind.walking, ActivityKind.yoga, ActivityKind.dance]);
      final times = [for (final o in p.others) o.slot?.clock];
      expect(times.toSet().length, greaterThanOrEqualTo(2));
    });

    group('state N3: nothing fits even without the chips', () {
      test('everything left out', () {
        final p = plan(
          actions,
          person: const PersonContext(access: {'none'}, excluded: {'walking', 'yoga', 'running', 'dance', 'gym', 'swimming', 'basketball'}),
        );
        expect(p.kind, TodayKind.nothingFitsChoices);
        expect(p.relaxation, isNull);
        expect(p.hero, isEmpty);
      });

      test('an empty library', () {
        expect(plan(const []).kind, TodayKind.nothingFitsChoices);
      });

      test('leave-outs are never relaxed: the chips do not change them', () {
        final p = plan(
          [only('basket_game')],
          person: const PersonContext(access: {'courts_or_park'}, excluded: {'team_sport'}),
          chips: const TodayChips(timeMin: 45, energy: Energy.high),
        );
        expect(p.kind, TodayKind.nothingFitsChoices);
      });
    });
  });
}
