import 'database.dart';

/// Current consent text version, `date.revision` as in docs/data-model.md. Bump it when the
/// consent screen's wording changes (BR-014).
const currentConsentVersion = '2026-10-27.1';

/// The data layer sits behind interfaces so later features (and P1 sync) can swap implementations.
abstract interface class ConsentRepository {
  /// True when the person has agreed to the current consent version.
  Future<bool> hasAgreed();

  /// Records the agreement. Called only after the person taps "I agree, continue".
  Future<void> agree();
}

class DriftConsentRepository implements ConsentRepository {
  DriftConsentRepository(this._db);

  final LiltDatabase _db;

  @override
  Future<bool> hasAgreed() async {
    final rows = await (_db.select(_db.consentRecords)
          ..where((t) => t.consentVersion.equals(currentConsentVersion))
          ..limit(1))
        .get();
    return rows.isNotEmpty;
  }

  @override
  Future<void> agree() async {
    await _db.into(_db.consentRecords).insert(
          ConsentRecordsCompanion.insert(
            consentVersion: currentConsentVersion,
            acceptedAt: DateTime.now().toUtc(),
          ),
        );
  }
}
