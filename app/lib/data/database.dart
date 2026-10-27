import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

/// One row per consent the person gave. Nothing is written before they agree (BR-014).
class ConsentRecords extends Table {
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
