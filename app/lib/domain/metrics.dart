import '../data/enums.dart';
import 'day.dart';
import 'models.dart';

/// EQ-010 [assumption]: an edit that keeps the action and changes the length by at most this share is "light".
const lightEditMaxChange = 0.5;

/// One week of offers (weeks run Monday to Sunday). Offers still `offered` at day end are left out.
class WeekAcceptance {
  const WeekAcceptance({
    required this.weekStart,
    required this.accepted,
    required this.edited,
    required this.lightEdits,
    required this.replaced,
    required this.declined,
  });

  final String weekStart;
  final int accepted;
  final int edited;
  final int lightEdits;
  final int replaced;
  final int declined;

  int get denominator => accepted + edited + replaced + declined;

  /// `(accepted + light edits) / (accepted + edited + replaced + declined)`, or null for a week with no
  /// answered offer. Each "Something else" counts as not accepted, by design.
  double? get rate => denominator == 0 ? null : (accepted + lightEdits) / denominator;
}

/// Whether an edit kept the length within [lightEditMaxChange] of the library's.
bool isLightEdit(OfferRecord offer) {
  final edited = offer.editedDurationMin;
  if (edited == null) return true; // only the day or time changed
  if (offer.actionDurationMin <= 0) return false;
  return (edited - offer.actionDurationMin).abs() / offer.actionDurationMin <= lightEditMaxChange;
}

/// EQ-010: "do the options feel feasible?", per week, oldest week first. Compare the first week with the last.
List<WeekAcceptance> weeklyAcceptance(List<OfferRecord> offers) {
  final byWeek = <String, List<OfferRecord>>{};
  for (final o in offers) {
    if (o.status == OfferStatus.offered) continue;
    (byWeek[weekStart(o.day)] ??= []).add(o);
  }
  final weeks = byWeek.keys.toList()..sort();
  return [
    for (final w in weeks)
      WeekAcceptance(
        weekStart: w,
        accepted: byWeek[w]!.where((o) => o.status == OfferStatus.accepted).length,
        edited: byWeek[w]!.where((o) => o.status == OfferStatus.edited).length,
        lightEdits: byWeek[w]!.where((o) => o.status == OfferStatus.edited && isLightEdit(o)).length,
        replaced: byWeek[w]!.where((o) => o.status == OfferStatus.replaced).length,
        declined: byWeek[w]!.where((o) => o.status == OfferStatus.declined).length,
      ),
  ];
}

/// EQ-011: the totals shown to the person. Both only ever go up (BR-007): no rule subtracts from them.
class Totals {
  const Totals({required this.activeDays, required this.returns});

  final int activeDays;
  final int returns;
}

/// Active days = distinct reflected days, all time. Returns = recorded `return_event` rows.
Totals totals({required Iterable<ReflectionRecord> reflections, required int returnEvents}) => Totals(
      activeDays: {
        for (final r in reflections)
          if (r.makesReflectedDay) r.day,
      }.length,
      returns: returnEvents,
    );
