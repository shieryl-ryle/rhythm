import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

/// Append-only consent log (docs/data-model.md `consent`). No row is written before the person
/// agrees (BR-014, TC-022). The empty local store itself is created on first launch.
class ConsentRecords extends Table {
  @override
  String get tableName => 'consent';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get consentVersion => text()();
  DateTimeColumn get acceptedAt => dateTime()();
}

@DriftDatabase(tables: [ConsentRecords])
class LiltDatabase extends _$LiltDatabase {
  LiltDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

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
