import 'package:drift/drift.dart';

import '../../data/database.dart';
import '../../data/enums.dart';
import '../../domain/day.dart';
import '../../domain/lapse.dart';
import '../../domain/models.dart';
import '../../domain/ranking.dart';

/// Turns database rows into the plain inputs the domain rules use (docs/methods.md EQ-003, EQ-001). The rules
/// stay pure; this is the only place rows are read for Today.

Set<String> _csv(String? value) =>
    value == null || value.isEmpty ? <String>{} : value.split(',').where((s) => s.isNotEmpty).toSet();

ActionInfo toActionInfo(LibraryAction row) => ActionInfo(
      id: row.id,
      activity: row.activity,
      title: row.title,
      durationMin: row.durationMin,
      energyNeeded: row.energyNeeded,
      tags: _csv(row.tags),
      isStarter: row.isStarter,
      similarTo: row.similarTo.isEmpty ? const [] : row.similarTo.split(','),
      libraryVersion: row.libraryVersion,
    );

/// Minutes since midnight for a stored "HH:MM", or null.
int? _minute(String? clock) {
  if (clock == null) return null;
  final parts = clock.split(':');
  if (parts.length != 2) return null;
  final h = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  return h == null || m == null ? null : h * 60 + m;
}

/// Everything Today needs from the database, read in one go.
class TodayInputs {
  const TodayInputs({
    required this.actions,
    required this.libraryVersion,
    required this.person,
    required this.followedOrder,
    required this.followedPaths,
    required this.freeTimes,
    required this.pauses,
    required this.reflections,
  });

  final List<ActionInfo> actions;

  /// The newest library version loaded. A retired action (older version) is never offered.
  final String libraryVersion;
  final PersonContext person;

  /// Followed activities in `followed_at` order, which is the order of their cards (docs/data-model.md).
  final List<ActivityKind> followedOrder;

  /// How each followed activity was chosen, for the label on its card ("Picking up again").
  final Map<ActivityKind, SetupPath> followedPaths;
  final Set<String> freeTimes;
  final List<PauseSpan> pauses;
  final List<ReflectionRecord> reflections;

  Set<String> get reflectedDays => reflectedDaysOf(reflections);
}

Future<TodayInputs> loadTodayInputs(LiltDatabase db) async {
  final actionRows = await db.select(db.actions).get();
  final actions = [for (final r in actionRows) toActionInfo(r)];
  final tagsById = {for (final a in actions) a.id: a.tags};
  final version = actions.isEmpty ? '' : (actions.map((a) => a.libraryVersion).toList()..sort()).last;

  final followed = await (db.select(db.followedActivities)
        ..where((t) => t.unfollowedAt.isNull())
        ..orderBy([(t) => OrderingTerm(expression: t.followedAt)]))
      .get();
  final prefs = await db.select(db.preferences).get();
  Set<String> prefValues(PrefKind kind) => {for (final p in prefs) if (p.kind == kind) p.value};

  final saved = {for (final s in await db.select(db.savedActions).get()) s.actionId};
  final observations = [
    for (final o in await db.select(db.observations).get())
      ObservationInfo(patternKey: o.patternKey, text: o.text_, status: o.status),
  ];

  // Every plan item with its reflection (one each), as the rules see it.
  final joined = await (db.select(db.planItems).join([
    innerJoin(db.reflections, db.reflections.planItemId.equalsExp(db.planItems.id)),
  ])).get();
  final reflections = [
    for (final row in joined)
      ReflectionRecord(
        day: row.readTable(db.planItems).plannedDay,
        activity: row.readTable(db.planItems).activity,
        status: row.readTable(db.reflections).status,
        actionId: row.readTable(db.planItems).actionId,
        tags: tagsById[row.readTable(db.planItems).actionId] ?? const {},
        plannedMinute: _minute(row.readTable(db.planItems).plannedTime),
        enjoyment: row.readTable(db.reflections).enjoyment,
        barrier: row.readTable(db.reflections).barrier,
      ),
  ];

  final pauses = [
    for (final p in await db.select(db.pauses).get())
      // `end_day` is the first day active again, but the domain's pause span includes its last day.
      if (p.kind == PauseKind.pause && (p.endDay == null || p.endDay!.compareTo(p.startDay) > 0))
        PauseSpan(startDay: p.startDay, endDay: p.endDay == null ? null : addDays(p.endDay!, -1)),
  ];

  final wouldHelp = <String>{for (final f in followed) ..._csv(f.wouldHelp)};

  return TodayInputs(
    actions: actions,
    libraryVersion: version,
    followedOrder: [for (final f in followed) f.activity],
    followedPaths: {for (final f in followed.reversed) f.activity: f.path},
    freeTimes: prefValues(PrefKind.freeTime),
    pauses: pauses,
    reflections: reflections,
    person: PersonContext(
      excluded: prefValues(PrefKind.excluded),
      access: prefValues(PrefKind.access),
      wouldHelp: wouldHelp,
      motivations: prefValues(PrefKind.motivation),
      followed: {for (final f in followed) f.activity},
      savedActionIds: saved,
      observations: observations,
      reflections: reflections,
    ),
  );
}
