import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/domain/day.dart';
import 'package:lilt/domain/scheduler.dart';

/// TC-033 (EQ-005, BR-012, BR-013): at most 1 reminder a day and 5 in any 7 days, quiet hours and paused days
/// honoured, and only the weekly check-in while lapsed.
void main() {
  const settings = ReminderSettings(enabled: true);
  const start = '2026-11-01';

  ReminderDecision decide(
    ReminderSlot slot,
    List<ReminderSlot> existing, {
    ReminderSettings s = settings,
    bool paused = false,
    bool lapsed = false,
  }) =>
      decideReminder(slot: slot, existing: existing, settings: s, dayIsPaused: paused, lapsed: lapsed);

  test('simulated 14 days: never more than 1 a day or 5 in any 7 days, nothing in quiet hours', () {
    final scheduled = <ReminderSlot>[];
    for (var i = 0; i < 14; i++) {
      final day = addDays(start, i);
      // Try three times a day: at 08:00, 12:00 and 22:00 (quiet hours).
      for (final minute in [8 * 60, 12 * 60, 22 * 60]) {
        final slot = ReminderSlot(day: day, minute: minute);
        if (decide(slot, scheduled) == ReminderDecision.allowed) scheduled.add(slot);
      }
    }
    for (var i = 0; i < 14; i++) {
      final day = addDays(start, i);
      expect(scheduled.where((r) => r.day == day).length, lessThanOrEqualTo(1), reason: day);
    }
    for (var i = 0; i < 14 - 6; i++) {
      final from = addDays(start, i);
      final to = addDays(from, 6);
      final count = scheduled.where((r) => r.day.compareTo(from) >= 0 && r.day.compareTo(to) <= 0).length;
      expect(count, lessThanOrEqualTo(5), reason: '$from to $to');
    }
    expect(scheduled.any((r) => r.minute >= 21 * 60 || r.minute < 7 * 60), isFalse);
    expect(scheduled, isNotEmpty);
    // 5 in the first 7 days, then the window slides: the 8th day is allowed again.
    expect(scheduled.where((r) => r.day.compareTo(addDays(start, 6)) <= 0), hasLength(5));
  });

  test('the second reminder on a day is refused', () {
    final first = ReminderSlot(day: start, minute: 8 * 60);
    expect(decide(first, []), ReminderDecision.allowed);
    expect(decide(const ReminderSlot(day: start, minute: 12 * 60), [first]), ReminderDecision.dailyCap);
  });

  test('the sixth in 7 days is refused, and the cap also protects reminders booked for later', () {
    final five = [for (var i = 0; i < 5; i++) ReminderSlot(day: addDays(start, i), minute: 8 * 60)];
    expect(decide(ReminderSlot(day: addDays(start, 5), minute: 8 * 60), five), ReminderDecision.weeklyCap);
    // Day 8 is a new window: allowed.
    expect(decide(ReminderSlot(day: addDays(start, 7), minute: 8 * 60), five), ReminderDecision.allowed);
    // Booking an earlier day that would push a later window over 5 is refused too.
    final later = [for (var i = 2; i < 7; i++) ReminderSlot(day: addDays(start, i), minute: 8 * 60)];
    expect(decide(const ReminderSlot(day: start, minute: 8 * 60), later), ReminderDecision.weeklyCap);
  });

  test('quiet hours run across midnight (21:00 to 07:00)', () {
    expect(isQuietMinute(21 * 60, '21:00', '07:00'), isTrue);
    expect(isQuietMinute(23 * 60 + 59, '21:00', '07:00'), isTrue);
    expect(isQuietMinute(0, '21:00', '07:00'), isTrue);
    expect(isQuietMinute(6 * 60 + 59, '21:00', '07:00'), isTrue);
    expect(isQuietMinute(7 * 60, '21:00', '07:00'), isFalse);
    expect(isQuietMinute(20 * 60 + 59, '21:00', '07:00'), isFalse);
    expect(isQuietMinute(13 * 60, '13:00', '14:00'), isTrue); // a same-day range works too
    expect(isQuietMinute(14 * 60, '13:00', '14:00'), isFalse);
    expect(decide(const ReminderSlot(day: start, minute: 22 * 60), []), ReminderDecision.quietHours);
  });

  test('a paused day gets no reminder', () {
    expect(decide(const ReminderSlot(day: start, minute: 8 * 60), [], paused: true), ReminderDecision.paused);
  });

  test('reminders are off by default (BR-012): a missing settings row means none', () {
    expect(const ReminderSettings().enabled, isFalse);
    expect(
      decide(const ReminderSlot(day: start, minute: 8 * 60), [], s: const ReminderSettings()),
      ReminderDecision.disabled,
    );
  });

  test('reminders switched off: none', () {
    expect(
      decide(const ReminderSlot(day: start, minute: 8 * 60), [], s: const ReminderSettings(enabled: false)),
      ReminderDecision.disabled,
    );
  });

  group('while lapsed (BR-013)', () {
    test('an ordinary reminder is refused', () {
      expect(
        decide(const ReminderSlot(day: start, minute: 8 * 60), [], lapsed: true),
        ReminderDecision.lapseOnlyCheckin,
      );
    });

    test('one weekly check-in is allowed, a second within 7 days is not', () {
      const checkin = ReminderSlot(day: start, minute: 10 * 60, kind: ReminderKind.lapseCheckin);
      expect(decide(checkin, [], lapsed: true), ReminderDecision.allowed);
      final next = ReminderSlot(day: addDays(start, 3), minute: 10 * 60, kind: ReminderKind.lapseCheckin);
      expect(decide(next, [checkin], lapsed: true), ReminderDecision.lapseCheckinCap);
      final week = ReminderSlot(day: addDays(start, 7), minute: 10 * 60, kind: ReminderKind.lapseCheckin);
      expect(decide(week, [checkin], lapsed: true), ReminderDecision.allowed);
    });

    test('a check-in booked for later counts too, so two never fall within 7 days', () {
      final booked = ReminderSlot(day: addDays(start, 3), minute: 10 * 60, kind: ReminderKind.lapseCheckin);
      const earlier = ReminderSlot(day: start, minute: 10 * 60, kind: ReminderKind.lapseCheckin);
      expect(decide(earlier, [booked], lapsed: true), ReminderDecision.lapseCheckinCap);
    });

    test('the check-in can be switched off', () {
      const checkin = ReminderSlot(day: start, minute: 10 * 60, kind: ReminderKind.lapseCheckin);
      expect(
        decide(checkin, [], lapsed: true, s: const ReminderSettings(enabled: true, lapseCheckinEnabled: false)),
        ReminderDecision.lapseCheckinOff,
      );
    });

    test('quiet hours and pauses still apply to the check-in', () {
      const night = ReminderSlot(day: start, minute: 22 * 60, kind: ReminderKind.lapseCheckin);
      expect(decide(night, [], lapsed: true), ReminderDecision.quietHours);
      const morning = ReminderSlot(day: start, minute: 9 * 60, kind: ReminderKind.lapseCheckin);
      expect(decide(morning, [], lapsed: true, paused: true), ReminderDecision.paused);
    });

    test('a check-in is not allowed when not lapsed', () {
      const checkin = ReminderSlot(day: start, minute: 10 * 60, kind: ReminderKind.lapseCheckin);
      expect(decide(checkin, []), ReminderDecision.lapseOnlyCheckin);
    });
  });
}
