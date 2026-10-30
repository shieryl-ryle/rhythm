import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/app/app.dart';
import 'package:lilt/data/consent_repository.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/features/settings/settings_providers.dart';
import 'package:lilt/features/starting_point/setup_model.dart';
import 'package:lilt/features/starting_point/setup_repository.dart';
import 'package:lilt/features/support/support_providers.dart';

import '../test/support/test_support.dart';

/// Renders Settings, the delete dialog and the demo people with the bundled fonts, as PNGs for the senior UI
/// review. Evidence to compare with Figma frames 7.1, 7.4 to 7.7, not golden files.
///
///     flutter test tool/settings_evidence_test.dart --dart-define=EVIDENCE_DIR=C:/some/folder
const _dir = String.fromEnvironment('EVIDENCE_DIR');

Future<void> _font(String family, List<String> assets) async {
  final loader = FontLoader(family);
  for (final a in assets) {
    loader.addFont(Future.value(ByteData.sublistView(File(a).readAsBytesSync())));
  }
  await loader.load();
}

Future<void> _save(WidgetTester tester, GlobalKey key, String name) async {
  await tester.runAsync(() async {
    final boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2);
    final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
    File('$_dir/$name.png')
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes.buffer.asUint8List());
  });
}

const _runner = SetupAnswers(
  paths: {SetupPath.keepGoing},
  keepActivity: ActivityKind.gym,
  progress: Progress.goingWell,
  freeTimes: {'lunch'},
  access: {'gym_membership'},
);

void main() {
  setUpAll(() async {
    await _font('Geist', [
      'assets/fonts/geist/Geist-Regular.ttf',
      'assets/fonts/geist/Geist-Medium.ttf',
      'assets/fonts/geist/Geist-SemiBold.ttf',
    ]);
    await _font('Instrument Serif', ['assets/fonts/instrument-serif/InstrumentSerif-Italic.ttf']);
    await _font('Unbounded', ['assets/fonts/unbounded/Unbounded-Variable.ttf']);
    final root = Platform.environment['FLUTTER_ROOT'];
    if (root != null) {
      await _font('MaterialIcons', ['$root/bin/cache/artifacts/material_fonts/materialicons-regular.otf']);
    }
  });

  Future<GlobalKey> open(WidgetTester tester, {double scale = 1, bool demo = false, Size size = const Size(360, 800)}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final db = inMemoryDatabase();
    addTearDown(db.close);
    await DriftConsentRepository(db).agree();
    await DriftSetupRepository(db).save(_runner);
    final key = GlobalKey();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...todayTestOverrides(db),
          assetReaderProvider.overrideWithValue(readAssetFile),
          demoBuildProvider.overrideWithValue(demo),
        ],
        child: RepaintBoundary(
          key: key,
          child: MediaQuery(
            data: MediaQueryData(size: size, textScaler: TextScaler.linear(scale)),
            child: const LiltApp(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return key;
  }

  Future<void> tap(WidgetTester tester, String text) async {
    final finder = find.text(text).first;
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  for (final scale in [1.0, 2.0]) {
    final tag = '${(scale * 100).round()}';

    testWidgets('settings and the delete dialog at $tag%', (tester) async {
      if (_dir.isEmpty) return;
      final key = await open(tester, scale: scale);
      await tester.tap(find.bySemanticsLabel('Settings'));
      await tester.pumpAndSettle();
      await _save(tester, key, 's01_settings_$tag');
      await tap(tester, 'Delete everything');
      await _save(tester, key, 's02_delete_dialog_$tag');
    });

    testWidgets('settings in a demo build, with demo data loaded, at $tag%', (tester) async {
      if (_dir.isEmpty) return;
      final key = await open(tester, scale: scale, demo: true);
      await tester.tap(find.bySemanticsLabel('Settings'));
      await tester.pumpAndSettle();
      await _save(tester, key, 's03_settings_demo_$tag');
      await tap(tester, 'Load demo data: Rana');
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      await _save(tester, key, 's04_today_rana_$tag');
      await tester.tap(find.bySemanticsLabel('Settings'));
      await tester.pumpAndSettle();
      await _save(tester, key, 's05_settings_with_demo_label_$tag');
    });
  }
}
