import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'enums.dart';
import 'ids.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    ConsentRecords,
    Profiles,
    FollowedActivities,
    Preferences,
    Actions,
    OptionOffers,
    OfferReasons,
    PlanItems,
    Reflections,
    Pauses,
    Observations,
    SavedActions,
    ReturnEvents,
    AchievementsEarned,
    NotificationSettings,
  ],
)
class LiltDatabase extends _$LiltDatabase {
  LiltDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// 1: the walking skeleton (only `consent`). 2: the full schema from docs/data-model.md v0.2.
  /// 3: `action.similar_to` (TASK-004).
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _createTriggers();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Version 1 stored dates as integers (unix seconds); version 2 stores UTC ISO-8601 text.
            await customStatement(
              "UPDATE consent SET accepted_at = strftime('%Y-%m-%dT%H:%M:%fZ', accepted_at, 'unixepoch') "
              "WHERE typeof(accepted_at) = 'integer'",
            );
            // Version 1 had only `consent`; add every other table and index.
            for (final entity in allSchemaEntities) {
              if (entity == consentRecords) continue;
              await m.create(entity);
            }
            await _createTriggers();
          } else if (from < 3) {
            await m.addColumn(actions, actions.similarTo);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
          // Deleted rows are overwritten, not just unlinked, so delete-all really removes the data (BR-017).
          await customStatement('PRAGMA secure_delete = ON');
        },
      );

  /// Rules the schema alone cannot express (docs/data-model.md §4 `preference`).
  Future<void> _createTriggers() async {
    // Frame 1.13: "Pick up to 3" motivations.
    await customStatement(
      'CREATE TRIGGER IF NOT EXISTS preference_motivation_limit BEFORE INSERT ON preference '
      "WHEN NEW.kind = 'motivation' AND (SELECT COUNT(*) FROM preference WHERE kind = 'motivation') >= 3 "
      "BEGIN SELECT RAISE(ABORT, 'At most 3 motivations'); END",
    );
  }

  /// The tables a person's data lives in: everything except the read-only library.
  List<TableInfo<Table, dynamic>> get userTables =>
      allTables.where((t) => t.actualTableName != actions.actualTableName).toList();

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'lilt',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}
