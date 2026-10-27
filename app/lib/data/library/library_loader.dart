import 'package:drift/drift.dart';

import '../database.dart';
import 'library_models.dart';

/// Reads a bundled asset as text. Production uses `rootBundle.loadString`; tests read the file directly.
typedef AssetReader = Future<String> Function(String path);

/// Loads the bundled activity library into the `action` table (docs/data-model.md, DS-001).
abstract interface class LibraryLoader {
  /// Returns how many actions were written; 0 when this library version is already loaded.
  Future<int> load();
}

class DriftLibraryLoader implements LibraryLoader {
  DriftLibraryLoader(this._db, this._read);

  final LiltDatabase _db;
  final AssetReader _read;

  /// Upserts by id and never deletes a row: offers, plan items and the Saved list point at library
  /// actions, so a reload must not erase or break a person's history (docs/data-model.md).
  /// Run after consent, not before (BR-014).
  @override
  Future<int> load() async {
    final library = parseActionLibrary(await _read(LibraryAssets.actions));
    _check(library);

    final loaded = await (_db.select(_db.actions)..where((t) => t.libraryVersion.equals(library.version))).get();
    if (loaded.length >= library.actions.length) return 0;

    await _db.transaction(() async {
      for (final a in library.actions) {
        await _db.into(_db.actions).insertOnConflictUpdate(
              ActionsCompanion.insert(
                id: a.id,
                activity: a.activity,
                title: a.title,
                description: a.description,
                durationMin: a.durationMin,
                intensity: a.intensity,
                energyNeeded: a.energyNeeded,
                tags: Value(a.tags.join(',')),
                isStarter: Value(a.isStarter),
                similarTo: Value(a.similarTo.join(',')),
                libraryVersion: library.version,
              ),
            );
      }
    });
    return library.actions.length;
  }

  void _check(ActionLibrary library) {
    final ids = library.actions.map((a) => a.id).toSet();
    if (ids.length != library.actions.length) throw const FormatException('Duplicate action ids in the library');
    for (final a in library.actions) {
      for (final other in a.similarTo) {
        if (!ids.contains(other)) {
          throw FormatException('Action ${a.id} is similar to unknown action $other');
        }
      }
      for (final tag in a.tags) {
        if (!library.tagCodes.contains(tag)) {
          throw FormatException('Action ${a.id} has unknown tag $tag');
        }
      }
    }
  }
}
