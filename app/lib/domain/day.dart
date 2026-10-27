/// Local days as `YYYY-MM-DD` text, the way the data layer stores them (docs/data-model.md). Arithmetic is
/// done on UTC dates so a daylight-saving change never skips or repeats a day.
DateTime parseDay(String day) {
  final parts = day.split('-');
  if (parts.length == 3) {
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y != null && m != null && d != null) {
      final parsed = DateTime.utc(y, m, d);
      if (formatDay(parsed) == day) return parsed;
    }
  }
  throw FormatException('Not a day (YYYY-MM-DD): "$day"');
}

String formatDay(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

String addDays(String day, int days) => formatDay(parseDay(day).add(Duration(days: days)));

/// Whole days from [from] to [to] (negative when [to] is earlier).
int daysBetween(String from, String to) => parseDay(to).difference(parseDay(from)).inDays;

/// The Monday of the week that contains [day]. Weeks run Monday to Sunday.
String weekStart(String day) => addDays(day, -(parseDay(day).weekday - DateTime.monday));

/// Minutes since midnight for "HH:MM".
int parseClock(String clock) {
  final parts = clock.split(':');
  final h = parts.length == 2 ? int.tryParse(parts[0]) : null;
  final m = parts.length == 2 ? int.tryParse(parts[1]) : null;
  if (h == null || m == null || h < 0 || h > 23 || m < 0 || m > 59) {
    throw FormatException('Not a time (HH:MM): "$clock"');
  }
  return h * 60 + m;
}
