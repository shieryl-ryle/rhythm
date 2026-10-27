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
  Future<bool> build() async {
    final agreed = await ref.watch(consentRepositoryProvider).hasAgreed();
    // The library is loaded only after consent (BR-014).
    if (agreed) await ref.read(libraryLoaderProvider).load();
    return agreed;
  }

  Future<void> agree() async {
    await ref.read(consentRepositoryProvider).agree();
    await ref.read(libraryLoaderProvider).load();
    state = const AsyncData(true);
  }
}

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
