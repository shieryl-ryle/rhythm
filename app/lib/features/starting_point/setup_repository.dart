import 'package:drift/drift.dart';

import '../../data/database.dart';
import '../../data/enums.dart';
import 'setup_model.dart';

/// Reads and writes the answers of the setup wizard (S-003). Behind an interface like the other repositories
/// (ADR-002 decision 6), so screens can be tested without a database.
abstract interface class SetupRepository {
  /// True once the person has finished setup ("Show me today").
  Future<bool> isDone();

  /// Saves every answer in one transaction and marks setup done. Nothing is written before this: the wizard
  /// keeps its answers in memory, so leaving halfway stores nothing (BR-014). First run only: once setup is done
  /// this throws, so a later "edit my starting point" cannot wipe followed activities and preferences.
  Future<void> save(SetupAnswers answers);
}

class DriftSetupRepository implements SetupRepository {
  DriftSetupRepository(this._db);

  final LiltDatabase _db;

  @override
  Future<bool> isDone() async {
    final row = await (_db.select(_db.profiles)..where((t) => t.setupDoneAt.isNotNull())).getSingleOrNull();
    return row != null;
  }

  @override
  Future<void> save(SetupAnswers a) => _db.transaction(() async {
        if (await isDone()) throw StateError('Setup is already done; editing uses its own methods.');
        // A failed first attempt leaves nothing behind, so these are empty; clear them anyway to be safe.
        await _db.delete(_db.followedActivities).go();
        await _db.delete(_db.preferences).go();

        for (final row in followedRows(a)) {
          await _db.into(_db.followedActivities).insert(row);
        }
        for (final row in preferenceRows(a)) {
          await _db.into(_db.preferences).insert(row);
        }
        await _db.into(_db.profiles).insertOnConflictUpdate(
              ProfilesCompanion(id: const Value('me'), setupDoneAt: Value(DateTime.now().toUtc())),
            );
      });
}

/// The `followed_activity` rows for the paths that were ticked (docs/data-model.md §4 and §7). "Add something
/// new" stores the activity the person already does as one they keep going with, unless Keep going already
/// holds the same one; what to add is chosen later in Discover.
List<FollowedActivitiesCompanion> followedRows(SetupAnswers a) {
  String? csv(Set<String> values) => values.isEmpty ? null : (values.toList()..sort()).join(',');
  String? custom(ActivityKind? kind, String? name) =>
      kind == ActivityKind.other && name != null && name.trim().isNotEmpty ? name.trim() : null;

  final rows = <FollowedActivitiesCompanion>[];

  if (a.paths.contains(SetupPath.keepGoing) && a.keepActivity != null) {
    rows.add(
      FollowedActivitiesCompanion.insert(
        activity: a.keepActivity!,
        path: SetupPath.keepGoing,
        customName: Value(custom(a.keepActivity, a.keepCustomName)),
        progress: Value(a.progress),
        hardBecause: Value(a.asksWhatMakesItHarder ? csv(a.hardBecause) : null),
      ),
    );
  }

  if (a.paths.contains(SetupPath.addNew) && a.addNewActivity != null) {
    final name = custom(a.addNewActivity, a.addNewCustomName);
    final duplicate = rows.any(
      (r) =>
          r.activity.value == a.addNewActivity &&
          (r.customName.value ?? '').toLowerCase() == (name ?? '').toLowerCase(),
    );
    if (!duplicate) {
      rows.add(
        FollowedActivitiesCompanion.insert(
          activity: a.addNewActivity!,
          path: SetupPath.keepGoing,
          customName: Value(name),
        ),
      );
    }
  }

  if (a.paths.contains(SetupPath.pickUpAgain) && a.pickUpActivity != null) {
    rows.add(
      FollowedActivitiesCompanion.insert(
        activity: a.pickUpActivity!,
        path: SetupPath.pickUpAgain,
        customName: Value(custom(a.pickUpActivity, a.pickUpCustomName)),
        stoppedAgo: Value(a.stoppedAgo),
        gotInTheWay: Value(csv(a.gotInTheWay)),
        wouldHelp: Value(csv(a.wouldHelp)),
      ),
    );
  }

  if (a.paths.contains(SetupPath.startFresh) && a.freshChoice != null) {
    rows.add(FollowedActivitiesCompanion.insert(activity: a.freshChoice!, path: SetupPath.startFresh));
  }
  return rows;
}

/// The `preference` rows: free times, access, usual barriers, motivations and leave-outs. "Nothing to leave
/// out" is an empty set, so it stores nothing. At most 3 motivations (the data layer enforces it too).
List<PreferencesCompanion> preferenceRows(SetupAnswers a) {
  PreferencesCompanion row(PrefKind kind, String value) =>
      PreferencesCompanion.insert(kind: kind, value: value);
  return [
    for (final v in a.freeTimes) row(PrefKind.freeTime, v),
    for (final v in a.access) row(PrefKind.access, v),
    for (final v in a.barriers) row(PrefKind.usualBarrier, v),
    for (final v in a.motivations.take(maxMotivations)) row(PrefKind.motivation, v),
    for (final v in a.excluded) row(PrefKind.excluded, v),
  ];
}
