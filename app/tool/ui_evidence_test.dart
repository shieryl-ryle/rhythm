import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/app/theme.dart';
import 'package:lilt/ui/ui.dart';

/// Renders the shared widgets with the bundled fonts and writes PNGs for the senior UI review (step 2 of the
/// build checks). It asserts nothing about pixels: fonts differ between machines, so the images are evidence
/// for a person to compare with the Figma frames, not golden files.
///
///     flutter test tool/ui_evidence_test.dart --dart-define=EVIDENCE_DIR=C:/some/folder
const _dir = String.fromEnvironment('EVIDENCE_DIR');

Future<void> _loadFont(String family, List<String> assets) async {
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
    final file = File('$_dir/$name.png')..createSync(recursive: true);
    file.writeAsBytesSync(bytes.buffer.asUint8List());
  });
}

Widget _app(GlobalKey key, double scale, Widget child) => RepaintBoundary(
      key: key,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildLiltTheme(),
        builder: (context, c) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
          child: c!,
        ),
        home: child,
      ),
    );

void main() {
  setUpAll(() async {
    await _loadFont('Geist', [
      'assets/fonts/geist/Geist-Regular.ttf',
      'assets/fonts/geist/Geist-Medium.ttf',
      'assets/fonts/geist/Geist-SemiBold.ttf',
    ]);
    await _loadFont('Instrument Serif', ['assets/fonts/instrument-serif/InstrumentSerif-Italic.ttf']);
    await _loadFont('Unbounded', ['assets/fonts/unbounded/Unbounded-Variable.ttf']);
    // The icon font, so icons are drawn instead of boxes.
    final root = Platform.environment['FLUTTER_ROOT'];
    if (root != null) {
      await _loadFont('MaterialIcons', ['$root/bin/cache/artifacts/material_fonts/materialicons-regular.otf']);
    }
  });

  for (final scale in [1.0, 2.0]) {
    final tag = '${(scale * 100).round()}';

    testWidgets('gallery at $tag%', (tester) async {
      if (_dir.isEmpty) return;
      tester.view.physicalSize = const Size(360, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final key = GlobalKey();
      await tester.pumpWidget(
        _app(
          key,
          scale,
          Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(LiltSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LiltHeader(onProfile: () {}, initial: 'S'),
                    Text('Friday 23 October', style: LiltText.body.copyWith(color: LiltColors.inkMuted)),
                    const Text('Here’s what fits today', style: LiltText.display),
                    const SizedBox(height: LiltSpacing.md),
                    LiltChipWrap(children: [
                      LiltChip(label: '20 min', onTap: () {}, menu: true),
                      LiltChip(label: 'Medium energy', onTap: () {}, menu: true),
                    ]),
                    const SizedBox(height: LiltSpacing.lg),
                    LiltButton(label: 'I’ll try this', onPressed: () {}),
                    LiltButtonRow(children: [
                      LiltButton(label: 'Something else', onPressed: () {}, kind: LiltButtonKind.text),
                      LiltButton(label: 'Not today', onPressed: () {}, kind: LiltButtonKind.text),
                    ]),
                    const SizedBox(height: LiltSpacing.md),
                    LiltButton(label: 'Pause for 1 week', onPressed: () {}, kind: LiltButtonKind.secondary),
                    const SizedBox(height: LiltSpacing.sm),
                    LiltButton(label: 'Next', onPressed: null),
                    const SizedBox(height: LiltSpacing.lg),
                    LiltChipWrap(children: [
                      LiltChip(label: 'Walking', onTap: () {}, selected: true, multi: true),
                      LiltChip(label: 'Running', onTap: () {}, multi: true),
                      LiltChip(label: 'Done', onTap: () {}, selected: true),
                      LiltChip(label: 'Partly', onTap: () {}),
                    ]),
                    const SizedBox(height: LiltSpacing.lg),
                    LiltSegmented<int>(
                      segments: const [
                        LiltSegment(value: 3, label: '3 days'),
                        LiltSegment(value: 7, label: '1 week'),
                        LiltSegment(value: 14, label: '2 weeks'),
                      ],
                      value: 7,
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: LiltSpacing.lg),
                    Text('25 active days', style: LiltText.celebration),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: LiltNavBar(index: 0, onSelect: (_) {}),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await _save(tester, key, 'gallery_$tag');
    });

    testWidgets('sheet at $tag%', (tester) async {
      if (_dir.isEmpty) return;
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final key = GlobalKey();
      await tester.pumpWidget(
        _app(
          key,
          scale,
          Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: LiltButton(
                  label: 'Open',
                  onPressed: () => showLiltSheet<void>(
                    context,
                    title: 'Not today?',
                    subtitle: 'That’s okay. What would help?',
                    bodyBuilder: (_) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final row in ['Something lighter', 'Move it to later', 'My plan fell through'])
                          ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 56),
                            child: Row(children: [
                              Expanded(child: Text(row, style: LiltText.body.copyWith(fontWeight: FontWeight.w600))),
                              const Icon(Icons.chevron_right),
                            ]),
                          ),
                        const SizedBox(height: LiltSpacing.lg),
                        LiltSegmented<int>(
                          segments: const [
                            LiltSegment(value: 3, label: '3 days'),
                            LiltSegment(value: 7, label: '1 week'),
                            LiltSegment(value: 14, label: '2 weeks'),
                          ],
                          value: 7,
                          onChanged: (_) {},
                        ),
                        const SizedBox(height: LiltSpacing.md),
                        LiltButton(label: 'Pause for 1 week', onPressed: () {}, kind: LiltButtonKind.secondary),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await _save(tester, key, 'sheet_$tag');
    });
  }
}
