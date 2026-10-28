import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/data/database.dart';
import 'package:lilt/data/library/library_loader.dart';
import 'package:lilt/data/providers.dart';
import 'package:lilt/features/starting_point/setup_controller.dart';
import 'package:lilt/features/starting_point/setup_model.dart';
import 'package:lilt/features/starting_point/setup_repository.dart';
import 'package:lilt/features/support/support_providers.dart';
import 'package:lilt/features/today/today_controller.dart';

/// Reads a bundled asset straight from disk, so tests need no platform channel (run from `app/`).
Future<String> readAssetFile(String path) async => File(path).readAsStringSync();

/// A loader that does nothing, for tests that use a fake consent repository and no database.
class NoopLibraryLoader implements LibraryLoader {
  @override
  Future<int> load() async => 0;
}

/// In-memory stand-in for the setup repository, for tests with a fake consent repository.
class FakeSetupRepository implements SetupRepository {
  FakeSetupRepository({this.done = false});

  bool done;
  SetupAnswers? saved;
  int saves = 0;

  @override
  Future<bool> isDone() async => done;

  @override
  Future<void> save(SetupAnswers answers) async {
    saves++;
    saved = answers;
    done = true;
  }
}

/// Overrides every test needs for the setup flow: no pause on the "Finding ideas" screen, and the support
/// assets read from disk.
List<Override> setupTestOverrides() => [
      setupTransitionProvider.overrideWithValue(Duration.zero),
      assetReaderProvider.overrideWithValue(readAssetFile),
    ];

/// Taps through the shortest setup (start fresh, "not sure yet", lunch, nothing else) to Today.
Future<void> completeSetup(WidgetTester tester) async {
  Future<void> tapText(String text) async {
    await tester.ensureVisible(find.text(text));
    await tester.pumpAndSettle();
    await tester.tap(find.text(text));
    await tester.pumpAndSettle();
  }

  await tapText('Start being active for the first time');
  await tapText('Next');
  await tapText('Not sure yet');
  await tapText('Next');
  await tapText('Lunch');
  await tapText('Next');
  await tapText('Next');
  await tapText('Show me today');
}

/// Friday 23 October 2026, 09:00: the day the Today screens are drawn for in tests and in the design.
DateTime fixedNow() => DateTime(2026, 10, 23, 9);

/// A real in-memory database with the real library, and a fixed clock, for tests that show Today. The caller
/// closes the database.
List<Override> todayTestOverrides(LiltDatabase db, {DateTime Function()? clock}) => [
      databaseProvider.overrideWithValue(db),
      libraryLoaderProvider.overrideWithValue(DriftLibraryLoader(db, readAssetFile)),
      clockProvider.overrideWithValue(clock ?? fixedNow),
    ];

LiltDatabase inMemoryDatabase() => LiltDatabase(NativeDatabase.memory());
