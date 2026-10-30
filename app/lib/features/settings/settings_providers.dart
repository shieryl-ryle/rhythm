import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../today/today_controller.dart';
import 'demo_seed.dart';

/// Whether this is a demo build. Tests replace it; a release build is always false (BR-017: no way to put
/// invented data on a real person's phone).
final demoBuildProvider = Provider<bool>((ref) => demoBuild);

/// True when the demo data is on this phone, so every main screen can say so (seed/README.md).
final demoDataLoadedProvider = FutureProvider<bool>((ref) async {
  // Delete-all resets consent, which re-reads this, so the label never outlives the data.
  ref.watch(consentProvider);
  final db = ref.watch(databaseProvider);
  final rows = await db
      .customSelect("SELECT 1 FROM followed_activity WHERE id LIKE '$demoIdPrefix%' LIMIT 1", readsFrom: {db.followedActivities})
      .get();
  return rows.isNotEmpty;
});

/// Wipes, then loads one persona, and refreshes what reads the data. Consent and setup are written again by the
/// seed (a demo person has agreed), so the router has nothing to redo.
final loadDemoProvider = Provider<Future<void> Function(DemoPersona)>((ref) {
  return (persona) async {
    if (!ref.read(demoBuildProvider)) return;
    // The library is what the plan rows point at.
    await ref.read(libraryLoaderProvider).load();
    await DemoSeed(ref.read(databaseProvider), ref.read(myDataServiceProvider)).load(persona, now: ref.read(clockProvider)());
    // Consent and setup are both on record again, so only what reads the data is refreshed.
    ref
      ..invalidate(todayControllerProvider)
      ..invalidate(demoDataLoadedProvider);
  };
});

/// What the person copied. The export is the whole JSON document (F-007, BR-017); there is no file or share
/// sheet yet, so it goes to the clipboard.
final exportMyDataProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final json = await ref.read(myDataServiceProvider).exportJson();
    await Clipboard.setData(ClipboardData(text: json));
  };
});
