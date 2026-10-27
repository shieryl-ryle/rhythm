import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/domain/day.dart';
import 'package:lilt/domain/lapse.dart';
import 'package:lilt/domain/metrics.dart';
import 'package:lilt/domain/models.dart';

import '../support/domain_support.dart';

/// TC-038 (EQ-010): weekly acceptance and light-edit counts from fixture offers.
/// TC-039 (EQ-011): a return is recorded once, and totals never decrease across a 60-day history.
void main() {
  OfferRecord offer(String day, OfferStatus status, {int minutes = 20, int? edited}) =>
      OfferRecord(day: day, status: status, actionDurationMin: minutes, editedDurationMin: edited);

  group('EQ-010 acceptance', () {
    // Week of Mon 2026-11-02: 3 accepted, 2 edited (20 -> 25 is light, 20 -> 45 is not), 1 replaced,
    // 1 declined, and 2 still "offered" (left out). Week of Mon 2026-11-09: 4 accepted.
    final offers = [
      offer('2026-11-02', OfferStatus.accepted),
      offer('2026-11-03', OfferStatus.accepted),
      offer('2026-11-04', OfferStatus.accepted),
      offer('2026-11-05', OfferStatus.edited, edited: 25),
      offer('2026-11-06', OfferStatus.edited, edited: 45),
      offer('2026-11-07', OfferStatus.replaced),
      offer('2026-11-08', OfferStatus.declined), // a Sunday: still the week of the 2nd
      offer('2026-11-04', OfferStatus.offered),
      offer('2026-11-05', OfferStatus.offered),
      for (var d = 9; d <= 12; d++) offer('2026-11-${d.toString().padLeft(2, '0')}', OfferStatus.accepted),
    ];

    test('counts per week, oldest first', () {
      final weeks = weeklyAcceptance(offers);
      expect(weeks.map((w) => w.weekStart), ['2026-11-02', '2026-11-09']);

      final first = weeks.first;
      expect(
        (first.accepted, first.edited, first.lightEdits, first.replaced, first.declined),
        (3, 2, 1, 1, 1),
      );
      expect(first.denominator, 7);
      expect(first.rate, closeTo((3 + 1) / 7, 1e-9));

      expect(weeks.last.rate, 1.0);
    });

    test('week 1 against the last week', () {
      final weeks = weeklyAcceptance(offers);
      expect(weeks.last.rate! > weeks.first.rate!, isTrue);
    });

    test('a week with only unanswered offers is left out; no answers gives no rate', () {
      expect(weeklyAcceptance([offer('2026-11-02', OfferStatus.offered)]), isEmpty);
      const empty = WeekAcceptance(weekStart: 'w', accepted: 0, edited: 0, lightEdits: 0, replaced: 0, declined: 0);
      expect(empty.rate, isNull);
    });

    test('"Something else" counts as not accepted', () {
      final w = weeklyAcceptance([
        offer('2026-11-02', OfferStatus.accepted),
        offer('2026-11-02', OfferStatus.replaced),
      ]).single;
      expect(w.rate, 0.5);
    });

    test('a light edit changes the length by at most 50%', () {
      expect(isLightEdit(offer('2026-11-02', OfferStatus.edited, edited: 30)), isTrue); // +50%
      expect(isLightEdit(offer('2026-11-02', OfferStatus.edited, edited: 10)), isTrue); // -50%
      expect(isLightEdit(offer('2026-11-02', OfferStatus.edited, edited: 31)), isFalse);
      expect(isLightEdit(offer('2026-11-02', OfferStatus.edited, edited: 9)), isFalse);
      expect(isLightEdit(offer('2026-11-02', OfferStatus.edited)), isTrue); // only the day or time changed
    });
  });

  group('EQ-011 totals', () {
    /// 60 days from 2026-11-01. Active days 1-9, a lapse from day 10, a return on day 20, a pause on days
    /// 30-33, a second lapse from day 40 (only skips and unknowns), and a return on day 50.
    List<ReflectionRecord> history() {
      final out = <ReflectionRecord>[];
      for (var i = 0; i < 60; i++) {
        final day = addDays('2026-11-01', i);
        final n = i + 1;
        if (n <= 9 || (n >= 20 && n <= 27) || (n >= 50 && n <= 56)) {
          out.add(done(day));
        } else if (n >= 10 && n <= 19) {
          out.add(reflect(day, n.isEven ? ReflectionStatus.skipped : ReflectionStatus.unknown));
        } else if (n >= 40 && n <= 49) {
          out.add(reflect(day, ReflectionStatus.skipped));
        }
      }
      return out;
    }

    final pauses = [PauseSpan(startDay: addDays('2026-11-01', 29), endDay: addDays('2026-11-01', 32))];

    test('after a lapse a return is recorded once, and both totals never decrease over 60 days', () {
      final all = history();
      final recorded = <String>{};
      var lastActive = 0;
      var lastReturns = 0;

      for (var i = 0; i < 60; i++) {
        final today = addDays('2026-11-01', i);
        final sofar = all.where((r) => r.day.compareTo(today) <= 0).toList();
        final lapses = findLapses(
          reflectedDays: reflectedDaysOf(sofar),
          pausedDays: pausedDays(pauses, today),
          today: today,
        );
        for (final l in returnsToRecord(lapses, recorded)) {
          recorded.add(l.returnDay!);
        }

        final t = totals(reflections: sofar, returnEvents: recorded.length);
        expect(t.activeDays, greaterThanOrEqualTo(lastActive), reason: 'active days fell on $today');
        expect(t.returns, greaterThanOrEqualTo(lastReturns), reason: 'returns fell on $today');
        lastActive = t.activeDays;
        lastReturns = t.returns;
      }

      expect(recorded, {addDays('2026-11-01', 19), addDays('2026-11-01', 49)});
      expect(lastActive, 9 + 8 + 7);
      expect(lastReturns, 2);
    });

    test('active days count distinct reflected days, not reflections', () {
      final t = totals(
        reflections: [
          done('2026-11-01'),
          done('2026-11-01'),
          reflect('2026-11-02', ReflectionStatus.partly),
          reflect('2026-11-03', ReflectionStatus.skipped),
          reflect('2026-11-04', ReflectionStatus.unknown),
        ],
        returnEvents: 1,
      );
      expect(t.activeDays, 2);
      expect(t.returns, 1);
    });
  });
}
