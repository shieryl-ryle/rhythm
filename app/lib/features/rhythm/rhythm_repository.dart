import 'package:drift/drift.dart';

import '../../data/database.dart';
import '../../data/enums.dart';
import '../../domain/day.dart';
import '../../domain/metrics.dart';
import '../../domain/observation.dart';
import '../today/today_controller.dart';
import '../today/today_data.dart';

/// The most weeks the My rhythm card shows (frame 6.1). It shows as many as there is history for, and at least
/// [myRhythmMinWeeks], so a newer person does not see an empty stretch. Today shows 12; the full history (6.4)
/// goes back as far as there is anything to show.
const myRhythmWeeks = 17;
const myRhythmMinWeeks = 12;

/// The longest an edited observation can be. It is shown on one card, so it stays a sentence.
const maxObservationLength = 140;

/// One thing planned for a day with how it went, for the day detail (frame 6.5). [reflection] is `unknown` until
/// the person answers (BR-009).
class DayEntry {
  const DayEntry({required this.planItemId, required this.activity, required this.title, required this.reflection});

  final String planItemId;
  final ActivityKind activity;
  final String title;
  final Reflection reflection;

  ReflectionStatus get status => reflection.status;
}

/// What My rhythm draws, read in one go.
class RhythmData {
  const RhythmData({
    required this.today,
    required this.totals,
    required this.grid,
    required this.history,
    required this.confirmed,
    required this.proposed,
  });

  final String today;

  /// Active days and returns. Both only ever go up (BR-007, EQ-011).
  final Totals totals;

  /// The last [myRhythmWeeks] weeks up to today, oldest first, starting on a Monday.
  final List<GridDay> grid;

  /// Every day from the first Monday on or before the first planned thing, to today. Empty before there is any.
  final List<GridDay> history;

  /// Observations the person confirmed or wrote, newest first. They are the only ones ranking uses (BR-010).
  final List<Observation> confirmed;

  /// A pattern the rules noticed that is waiting for the person's answer, or null.
  final Observation? proposed;

  /// Nothing has been reflected yet, so there is nothing to draw (the day-one state of S-006).
  bool get isEmpty => totals.activeDays == 0 && totals.returns == 0 && confirmed.isEmpty && proposed == null;
}

/// Reads My rhythm and changes observations (F-004, F-006). Nothing here touches ranking except through an
/// observation's status: only `confirmed` counts, a deleted one never comes back (BR-010).
class RhythmRepository {
  RhythmRepository(this._db);

  final LiltDatabase _db;

  Future<RhythmData> read({required String today, required DateTime now}) async {
    final inputs = await loadTodayInputs(_db);
    final returns = (await _db.select(_db.returnEvents).get()).length;
    final observations = await (_db.select(
      _db.observations,
    )..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])).get();

    final first = inputs.reflections
        .map((r) => r.day)
        .fold<String?>(null, (a, d) => a == null || d.compareTo(a) < 0 ? d : a);
    final historyWeeks = first == null ? 0 : daysBetween(weekStart(first), weekStart(today)) ~/ 7 + 1;
    final gridStart = addDays(weekStart(today), -7 * (historyWeeks.clamp(myRhythmMinWeeks, myRhythmWeeks) - 1));
    final historyStart = first == null ? null : weekStart(first);

    List<GridDay> days(String from) =>
        gridDays(from: from, to: today, today: today, reflections: inputs.reflections, pauses: inputs.pauses);

    return RhythmData(
      today: today,
      totals: totals(reflections: inputs.reflections, returnEvents: returns),
      grid: days(gridStart),
      history: historyStart == null ? const [] : days(historyStart),
      confirmed: [
        for (final o in observations)
          if (o.status == ObsStatus.confirmed) o,
      ],
      proposed: observations.where((o) => o.status == ObsStatus.proposed).firstOrNull,
    );
  }

  /// EQ-009: notices at most one new pattern a day and keeps it as `proposed` until the person answers. It does
  /// nothing while one is already waiting, and never re-proposes anything that was confirmed or deleted.
  Future<void> proposeIfDue({required String today, required DateTime now}) => _db.transaction(() async {
    final all = await _db.select(_db.observations).get();
    if (all.any((o) => o.status == ObsStatus.proposed)) return;
    final proposedToday = all.where((o) => formatDay(_localDay(o.createdAt)) == today).length;
    final inputs = await loadTodayInputs(_db);
    final proposal = proposeObservation(
      reflections: inputs.reflections,
      existingKeys: {for (final o in all) o.patternKey},
      proposedToday: proposedToday,
    );
    if (proposal == null) return;
    await _db
        .into(_db.observations)
        .insert(
          ObservationsCompanion.insert(
            text_: proposal.text,
            source: ObsSource.rule,
            patternKey: proposal.patternKey,
            createdAt: Value(now.toUtc()),
          ),
        );
  });

  /// "Yes, it fits": the observation now counts for suggestions (BR-010).
  Future<void> confirm(String id, {required DateTime now}) =>
      (_db.update(_db.observations)..where((t) => t.id.equals(id) & t.status.equals(ObsStatus.proposed.code))).write(
        ObservationsCompanion(status: const Value(ObsStatus.confirmed), confirmedAt: Value(now.toUtc())),
      );

  /// The person rewrote it. Writing their own words is also saying it fits, so it is confirmed, and it keeps its
  /// pattern so suggestions keep following what it was about. Empty or too long text changes nothing.
  Future<bool> edit(String id, String text, {required DateTime now}) async {
    final clean = text.trim();
    if (clean.isEmpty || clean.length > maxObservationLength) return false;
    final rows =
        await (_db.update(
          _db.observations,
        )..where((t) => t.id.equals(id) & t.status.isNotValue(ObsStatus.deleted.code))).write(
          ObservationsCompanion(
            text_: Value(clean),
            source: const Value(ObsSource.user),
            status: const Value(ObsStatus.confirmed),
            confirmedAt: Value(now.toUtc()),
          ),
        );
    return rows > 0;
  }

  /// "Not really" or Delete: it stops affecting suggestions at once and is not proposed again (BR-010). The row
  /// stays, marked deleted, so the pattern is remembered.
  Future<void> delete(String id) => (_db.update(
    _db.observations,
  )..where((t) => t.id.equals(id))).write(const ObservationsCompanion(status: Value(ObsStatus.deleted)));

  /// Everything planned for [day] with how it went, oldest first.
  Future<List<DayEntry>> entriesFor(String day) async {
    final rows =
        await (_db.select(_db.planItems).join([
                innerJoin(_db.reflections, _db.reflections.planItemId.equalsExp(_db.planItems.id)),
              ])
              ..where(_db.planItems.plannedDay.equals(day))
              ..orderBy([
                OrderingTerm(expression: _db.planItems.plannedTime),
                OrderingTerm(expression: _db.planItems.title),
              ]))
            .get();
    return [
      for (final r in rows)
        DayEntry(
          planItemId: r.readTable(_db.planItems).id,
          activity: r.readTable(_db.planItems).activity,
          title: r.readTable(_db.planItems).title,
          reflection: r.readTable(_db.reflections),
        ),
    ];
  }
}

DateTime _localDay(DateTime utc) {
  final l = utc.toLocal();
  return DateTime.utc(l.year, l.month, l.day);
}
