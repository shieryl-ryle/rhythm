import 'day.dart';

/// EQ-005 limits [assumption]: one reminder a day, five in any 7 days.
const maxRemindersPerDay = 1;
const maxRemindersPerWeek = 5;

enum ReminderKind { daily, lapseCheckin }

/// A reminder that is scheduled or was sent, at [minute] minutes past midnight on local [day].
class ReminderSlot {
  const ReminderSlot({required this.day, required this.minute, this.kind = ReminderKind.daily});

  final String day;
  final int minute;
  final ReminderKind kind;
}

/// Why a reminder may or may not be scheduled. Only [allowed] schedules it.
enum ReminderDecision {
  allowed,
  disabled,
  quietHours,
  paused,
  dailyCap,
  weeklyCap,
  lapseOnlyCheckin,
  lapseCheckinOff,
  lapseCheckinCap,
}

/// The person's reminder settings (`notification_setting`).
class ReminderSettings {
  const ReminderSettings({
    this.enabled = true,
    this.quietStart = '21:00',
    this.quietEnd = '07:00',
    this.lapseCheckinEnabled = true,
  });

  final bool enabled;
  final String quietStart;
  final String quietEnd;
  final bool lapseCheckinEnabled;
}

/// Whether [minute] is inside quiet hours, which can run past midnight (21:00 to 07:00).
bool isQuietMinute(int minute, String quietStart, String quietEnd) {
  final start = parseClock(quietStart);
  final end = parseClock(quietEnd);
  if (start == end) return false;
  return start < end ? minute >= start && minute < end : minute >= start || minute < end;
}

/// EQ-005: may a reminder of [kind] go out at [slot]? [existing] is every reminder already scheduled or sent.
///
/// - Nothing when reminders are off, during quiet hours, or on a paused day (BR-012, BR-013).
/// - At most [maxRemindersPerDay] a day and [maxRemindersPerWeek] in the 7 local days ending on the slot's day.
/// - While [lapsed] only the weekly check-in is allowed, at most once in 7 days, and only if the person left
///   it on.
ReminderDecision decideReminder({
  required ReminderSlot slot,
  required List<ReminderSlot> existing,
  required ReminderSettings settings,
  required bool dayIsPaused,
  required bool lapsed,
}) {
  if (!settings.enabled) return ReminderDecision.disabled;
  if (isQuietMinute(slot.minute, settings.quietStart, settings.quietEnd)) return ReminderDecision.quietHours;
  if (dayIsPaused) return ReminderDecision.paused;

  // The 7 days ending on the slot's day. Windows that end later are checked below for the weekly cap.
  final weekFrom = addDays(slot.day, -6);
  bool inWeek(ReminderSlot r) => r.day.compareTo(weekFrom) >= 0 && r.day.compareTo(slot.day) <= 0;

  if (lapsed) {
    if (slot.kind != ReminderKind.lapseCheckin) return ReminderDecision.lapseOnlyCheckin;
    if (!settings.lapseCheckinEnabled) return ReminderDecision.lapseCheckinOff;
    if (existing.any((r) => r.kind == ReminderKind.lapseCheckin && inWeek(r))) {
      return ReminderDecision.lapseCheckinCap;
    }
  } else if (slot.kind == ReminderKind.lapseCheckin) {
    // A check-in is for a lapse only.
    return ReminderDecision.lapseOnlyCheckin;
  }

  if (existing.where((r) => r.day == slot.day).length >= maxRemindersPerDay) return ReminderDecision.dailyCap;
  // Every rolling 7-day window that contains this day, so a reminder booked for later cannot be pushed over.
  for (var end = 0; end < 7; end++) {
    final windowEnd = addDays(slot.day, end);
    final windowStart = addDays(windowEnd, -6);
    final inWindow = existing.where((r) => r.day.compareTo(windowStart) >= 0 && r.day.compareTo(windowEnd) <= 0);
    if (inWindow.length >= maxRemindersPerWeek) return ReminderDecision.weeklyCap;
  }
  return ReminderDecision.allowed;
}
