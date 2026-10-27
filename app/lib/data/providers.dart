import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/services.dart' show rootBundle;

import 'consent_repository.dart';
import 'database.dart';
import 'library/library_loader.dart';
import 'my_data.dart';

final databaseProvider = Provider<LiltDatabase>((ref) {
  final db = LiltDatabase();
  ref.onDispose(db.close);
  return db;
});

final consentRepositoryProvider = Provider<ConsentRepository>(
  (ref) => DriftConsentRepository(ref.watch(databaseProvider)),
);

/// Loads the bundled activity library into the database (DS-001). Tests override it.
final libraryLoaderProvider = Provider<LibraryLoader>(
  (ref) => DriftLibraryLoader(ref.watch(databaseProvider), rootBundle.loadString),
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

/// The activity library in the database. It loads only once the person has agreed (BR-014) and has its own
/// error state, so a failed load never changes whether someone has consented. Anything that needs actions
/// (ranking, Today) waits on this provider.
final libraryReadyProvider = FutureProvider<void>((ref) async {
  final agreed = ref.watch(consentProvider).valueOrNull ?? false;
  if (agreed) await ref.read(libraryLoaderProvider).load();
});

/// Steps that run before delete-all removes anything (cancel notifications, delete a Together
/// account). The features that own them override this provider.
final deleteAllHooksProvider = Provider<List<DeleteAllHook>>((ref) => const []);

final myDataServiceProvider = Provider<MyDataService>(
  (ref) => MyDataService(ref.watch(databaseProvider), hooks: ref.watch(deleteAllHooksProvider)),
);

/// Deletes everything, then sends the person back to the consent screen (BR-014, BR-017).
final deleteEverythingProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    await ref.read(myDataServiceProvider).deleteAll();
    ref.invalidate(consentProvider);
  };
});
