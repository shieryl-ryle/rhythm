import 'dart:convert';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/data/database.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/data/library/library_loader.dart';
import 'package:lilt/data/library/library_models.dart';

import '../support/test_support.dart';
import 'seed_helper.dart';

/// The bundled library loads into `action` after consent, can be reloaded safely, and keeps a person's
/// history intact (docs/data-model.md "Rules for the code that uses the schema").
void main() {
  late LiltDatabase db;

  setUp(() => db = LiltDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('loads every action with its attributes and similar links', () async {
    final written = await DriftLibraryLoader(db, readAssetFile).load();

    final library = parseActionLibrary(await readAssetFile(LibraryAssets.actions));
    expect(written, library.actions.length);
    expect(await db.select(db.actions).get(), hasLength(library.actions.length));

    final run = await (db.select(db.actions)..where((t) => t.id.equals('act_run_walk_20'))).getSingle();
    expect(run.activity, ActivityKind.running);
    expect(run.durationMin, 20);
    expect(run.tags, 'solo,outdoors,free');
    expect(run.similarTo, 'act_run_easy_10,act_walk_brisk_30');
    expect(run.libraryVersion, library.version);
  });

  test('loading again changes nothing', () async {
    final loader = DriftLibraryLoader(db, readAssetFile);
    await loader.load();
    expect(await loader.load(), 0);
    expect(await db.select(db.actions).get(), isNotEmpty);
  });

  test('a new library version updates rows in place and keeps a person\'s history', () async {
    await DriftLibraryLoader(db, readAssetFile).load();
    await seedEverything(db); // plan item, offer, reflection and a saved action all point at the library

    // A second version: one action renamed, and most of the old actions gone.
    Future<String> trimmed(String path) async {
      final json = jsonDecode(await readAssetFile(path)) as Map<String, Object?>;
      json['library_version'] = '2099-01-01.1';
      final all = (json['actions']! as List).cast<Map<String, Object?>>();
      final kept = all.where((a) => a['id'] == 'act_run_walk_20' || a['id'] == 'act_walk_10').toList();
      for (final a in kept) {
        a['similar_to'] = <String>[]; // the trimmed version cannot link to actions it no longer has
        if (a['id'] == 'act_run_walk_20') a['title'] = 'Run-walk around the park (renamed)';
      }
      return jsonEncode({...json, 'actions': kept});
    }

    final written = await DriftLibraryLoader(db, trimmed).load();
    expect(written, 2);

    final renamed = await (db.select(db.actions)..where((t) => t.id.equals('act_run_walk_20'))).getSingle();
    expect(renamed.title, 'Run-walk around the park (renamed)');
    expect(renamed.libraryVersion, '2099-01-01.1');

    // Nothing was deleted: actions that left the library stay, and the person's data still points at them.
    expect(await db.select(db.actions).get(), hasLength(greaterThan(2)));
    expect(await db.select(db.savedActions).get(), hasLength(1));
    expect(await db.select(db.planItems).get(), hasLength(1));
    expect(await db.select(db.optionOffers).get(), hasLength(1));
  });

  group('rejects a broken library', () {
    Future<String> broken(void Function(Map<String, Object?> json) edit) async {
      final json = jsonDecode(await readAssetFile(LibraryAssets.actions)) as Map<String, Object?>;
      edit(json);
      return jsonEncode(json);
    }

    List<Map<String, Object?>> actionsOf(Map<String, Object?> json) =>
        (json['actions']! as List).cast<Map<String, Object?>>();

    test('a duplicate id', () async {
      final text = await broken((j) => actionsOf(j)[1]['id'] = actionsOf(j)[0]['id']);
      await expectLater(DriftLibraryLoader(db, (_) async => text).load(), throwsFormatException);
    });

    test('a link to an action that does not exist', () async {
      final text = await broken((j) => actionsOf(j)[0]['similar_to'] = ['act_missing']);
      await expectLater(DriftLibraryLoader(db, (_) async => text).load(), throwsFormatException);
    });

    test('an unknown tag', () async {
      final text = await broken((j) => actionsOf(j)[0]['tags'] = ['mystery']);
      await expectLater(DriftLibraryLoader(db, (_) async => text).load(), throwsFormatException);
    });

    test('an unknown activity code', () async {
      final text = await broken((j) => actionsOf(j)[0]['activity'] = 'sailing');
      await expectLater(DriftLibraryLoader(db, (_) async => text).load(), throwsFormatException);
    });

    test('and writes nothing when it is rejected', () async {
      final text = await broken((j) => actionsOf(j)[0]['activity'] = 'sailing');
      await expectLater(DriftLibraryLoader(db, (_) async => text).load(), throwsFormatException);
      expect(await db.select(db.actions).get(), isEmpty);
    });
  });

  test('upgrading a version 2 database adds action.similar_to', () async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final old = LiltDatabase(
      NativeDatabase.memory(
        setup: (raw) {
          raw.execute(
            'CREATE TABLE action (id TEXT NOT NULL PRIMARY KEY, activity TEXT NOT NULL, title TEXT NOT NULL, '
            "description TEXT NOT NULL, duration_min INTEGER NOT NULL, intensity TEXT NOT NULL, "
            "energy_needed TEXT NOT NULL, tags TEXT NOT NULL DEFAULT '', is_starter INTEGER NOT NULL DEFAULT 0, "
            'library_version TEXT NOT NULL)',
          );
          raw.execute('PRAGMA user_version = 2');
        },
      ),
    );
    addTearDown(old.close);

    final columns = (await old.customSelect('PRAGMA table_info(action)').get()).map((r) => r.read<String>('name'));
    expect(columns, contains('similar_to'));
  });
}
