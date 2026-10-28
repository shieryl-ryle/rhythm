import 'dart:ui' as ui;

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/library/library_models.dart';
import '../../domain/red_flags.dart';
import 'helplines.dart';

/// Reads a bundled asset. Tests override it to read from disk.
final assetReaderProvider = Provider<Future<String> Function(String path)>((ref) => rootBundle.loadString);

/// The red-flag detector (EQ-008), built from the bundled list (DS-002). Free text is checked with it before
/// anything is saved or suggested (BR-003).
final redFlagDetectorProvider = FutureProvider<RedFlagDetector>((ref) async {
  final read = ref.watch(assetReaderProvider);
  return RedFlagDetector(parseRedFlags(await read(LibraryAssets.redFlags)));
});

const helplinesAsset = 'assets/support/helplines.json';

final helplinesProvider = FutureProvider<Helplines>((ref) async {
  final read = ref.watch(assetReaderProvider);
  return Helplines.parse(await read(helplinesAsset));
});

/// The country from the phone's language and region setting (no permission, nothing leaves the device).
final deviceCountryProvider = Provider<String?>((ref) => ui.PlatformDispatcher.instance.locale.countryCode);
