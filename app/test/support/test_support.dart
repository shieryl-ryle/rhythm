import 'dart:io';

import 'package:lilt/data/library/library_loader.dart';

/// Reads a bundled asset straight from disk, so tests need no platform channel (run from `app/`).
Future<String> readAssetFile(String path) async => File(path).readAsStringSync();

/// A loader that does nothing, for tests that use a fake consent repository and no database.
class NoopLibraryLoader implements LibraryLoader {
  @override
  Future<int> load() async => 0;
}
