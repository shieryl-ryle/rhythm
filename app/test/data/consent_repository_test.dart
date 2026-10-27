import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/data/consent_repository.dart';
import 'package:lilt/data/database.dart';
import 'package:lilt/data/my_data.dart';

/// TC-022 (BR-014): a fresh install has no consent row until the person agrees.
/// Runs against the real drift repository on an in-memory database.
void main() {
  late LiltDatabase db;
  late DriftConsentRepository repo;

  setUp(() {
    db = LiltDatabase(NativeDatabase.memory());
    repo = DriftConsentRepository(db);
  });

  tearDown(() => db.close());

  test('a fresh install has no consent rows and has not agreed', () async {
    expect(await repo.hasAgreed(), isFalse);
    expect(await db.select(db.consentRecords).get(), isEmpty);
  });

  test('agreeing writes exactly one consent row for the current version', () async {
    await repo.agree();

    expect(await repo.hasAgreed(), isTrue);
    final rows = await db.select(db.consentRecords).get();
    expect(rows, hasLength(1));
    expect(rows.single.consentVersion, currentConsentVersion);
  });

  test('the consent time is stored and exported in UTC', () async {
    await repo.agree();
    final export = await MyDataService(db).exportData();
    final tables = export['tables']! as Map<String, Object?>;
    final row = (tables['consent']! as List).single as Map<String, Object?>;
    expect(row['accepted_at'], endsWith('Z'));
    expect(export['format_notes'], isA<Map<String, Object?>>());
  });

  test('a consent given for an older version does not count', () async {
    await db.into(db.consentRecords).insert(
          ConsentRecordsCompanion.insert(
            consentVersion: '2000-01-01.1',
            acceptedAt: DateTime(2000),
          ),
        );

    expect(await repo.hasAgreed(), isFalse);
  });
}
