import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lilt/app/app.dart';
import 'package:lilt/data/consent_repository.dart';
import 'package:lilt/data/providers.dart';
import 'package:lilt/features/starting_point/setup_controller.dart';

import '../test/support/test_support.dart';

/// Renders the setup flow and the support message with the bundled fonts and writes PNGs for the senior UI
/// review (step 2 of the build checks). Evidence for a person to compare with Figma, not golden files.
///
///     flutter test tool/setup_evidence_test.dart --dart-define=EVIDENCE_DIR=C:/some/folder
const _dir = String.fromEnvironment('EVIDENCE_DIR');

class _Agreed implements ConsentRepository {
  @override
  Future<bool> hasAgreed() async => true;
  @override
  Future<void> agree() async {}
}

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

  for (final scale in [1.0, 2.0]) {
    final tag = '${(scale * 100).round()}';
    testWidgets('setup flow at $tag%', (tester) async {
      if (_dir.isEmpty) return;
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final key = GlobalKey();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            consentRepositoryProvider.overrideWithValue(_Agreed()),
            setupRepositoryProvider.overrideWithValue(FakeSetupRepository()),
            libraryLoaderProvider.overrideWithValue(NoopLibraryLoader()),
            ...setupTestOverrides(),
          ],
          child: RepaintBoundary(
            key: key,
            child: MediaQuery(
              data: MediaQueryData(size: const Size(360, 800), textScaler: TextScaler.linear(scale)),
              child: const LiltApp(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      Future<void> tap(String text) async {
        await tester.ensureVisible(find.text(text).first);
        await tester.pumpAndSettle();
        await tester.tap(find.text(text).first);
        await tester.pumpAndSettle();
      }

      await _save(tester, key, 's01_brings_empty_$tag');
      await tap('Keep going with something I do now');
      await tap('Pick up something I stopped');
      await _save(tester, key, 's02_brings_ticked_$tag');
      await tap('Next');
      await tap('Gym');
      await _save(tester, key, 's03_keep_activity_$tag');
      await tap('Next');
      await tap('Up and down');
      await tap('Finding time');
      await _save(tester, key, 's04_keep_progress_$tag');
      await tap('Next');
      await tap('Running');
      await tap('Next');
      await tap('A few months ago');
      await _save(tester, key, 's05_stopped_$tag');
      await tap('Next');
      await tap('Busier at work or study');
      await _save(tester, key, 's06_got_in_the_way_$tag');
      await tap('Next');
      await tap('Skip');
      await tap('Lunch');
      await tap('Gym membership');
      await tap('Time');
      await _save(tester, key, 's07_week_$tag');
      await tap('Next');
      await tap('More energy');
      await tap('Less stress');
      await _save(tester, key, 's08_why_$tag');
      await tap('Next');
      await tap('Outdoors after dark');
      await _save(tester, key, 's09_leave_out_$tag');

      // Back to the activity question and open the search.
      for (var i = 0; i < 12; i++) {
        final back = find.byTooltip('Back');
        if (back.evaluate().isEmpty) break;
        await tester.tap(back);
        await tester.pumpAndSettle();
      }
      await tap('Next');
      await tap('Other');
      await tester.enterText(find.byType(TextField), 'pil');
      await tester.pumpAndSettle();
      await _save(tester, key, 's10_search_$tag');

      await tester.enterText(find.byType(TextField), 'xyz');
      await tester.pumpAndSettle();
      await _save(tester, key, 's11_search_none_$tag');

      GoRouter.of(tester.element(find.byType(Scaffold).first)).go('/support');
      await tester.pumpAndSettle();
      await _save(tester, key, 's12_support_$tag');
    });
  }
}
