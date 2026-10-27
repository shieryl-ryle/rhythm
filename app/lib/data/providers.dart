import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'consent_repository.dart';
import 'database.dart';

final databaseProvider = Provider<LiltDatabase>((ref) {
  final db = LiltDatabase();
  ref.onDispose(db.close);
  return db;
});

final consentRepositoryProvider = Provider<ConsentRepository>(
  (ref) => DriftConsentRepository(ref.watch(databaseProvider)),
);

/// Whether the person has agreed. Loading until the local store has been read.
final consentProvider = AsyncNotifierProvider<ConsentNotifier, bool>(ConsentNotifier.new);

class ConsentNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() => ref.watch(consentRepositoryProvider).hasAgreed();

  Future<void> agree() async {
    await ref.read(consentRepositoryProvider).agree();
    state = const AsyncData(true);
  }
}
