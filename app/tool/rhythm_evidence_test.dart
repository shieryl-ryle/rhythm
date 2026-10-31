import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/app/app.dart';
import 'package:lilt/data/consent_repository.dart';
import 'package:lilt/data/database.dart';
import 'package:lilt/data/enums.dart';
import 'package:lilt/data/library/library_loader.dart';
import 'package:lilt/domain/day.dart';
import 'package:lilt/features/starting_point/setup_model.dart';
import 'package:lilt/features/starting_point/setup_repository.dart';
import 'package:lilt/data/my_data.dart';
import 'package:lilt/features/settings/demo_seed.dart';
import 'package:lilt/features/settings/settings_providers.dart';
import 'package:lilt/features/support/support_providers.dart';

import '../test/support/test_support.dart';

/// Renders My rhythm, the full history, the day detail and the observation sheet with the bundled fonts, as PNGs
/// for the senior UI review. Evidence to compare with Figma frames 6.1, 6.3, 6.4 and 6.5, not golden files.
///
///     flutter test tool/rhythm_evidence_test.dart --dart-define=EVIDENCE_DIR=C:/some/folder
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

  late LiltDatabase db;

  Future<GlobalKey> open(
    WidgetTester tester, {
    double scale = 1,
    Size size = const Size(360, 800),
    bool dayOne = false,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    db = inMemoryDatabase();
    addTearDown(db.close);
    if (dayOne) {
      await DriftConsentRepository(db).agree();
      await DriftSetupRepository(db).save(_runner);
    } else {
      await DriftLibraryLoader(db, readAssetFile).load();
      await DemoSeed(db, MyDataService(db)).load(DemoPersona.rana, now: fixedNow());
    }
    final key = GlobalKey();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...todayTestOverrides(db),
          assetReaderProvider.overrideWithValue(readAssetFile),
          demoBuildProvider.overrideWithValue(false),
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
    await tester.tap(find.text('My rhythm').last);
    await tester.pumpAndSettle();
    return key;
  }

  Future<void> tap(WidgetTester tester, String text) async {
    if (find.text(text).evaluate().isEmpty) {
      await tester.scrollUntilVisible(find.text(text), 200, scrollable: find.byType(Scrollable).first);
    }
    final finder = find.text(text).first;
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  for (final scale in [1.0, 2.0]) {
    final tag = '${(scale * 100).round()}';

    testWidgets('my rhythm and the observation sheet at $tag%', (tester) async {
      if (_dir.isEmpty) return;
      final key = await open(tester, scale: scale);
      await _save(tester, key, 'r01_my_rhythm_top_$tag');
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -600));
      await tester.pumpAndSettle();
      await _save(tester, key, 'r02_my_rhythm_scrolled_$tag');
      await tap(tester, 'Edit');
      await _save(tester, key, 'r03_observation_sheet_$tag');
      await tester.tap(find.text('Say it differently'));
      await tester.pumpAndSettle();
      await _save(tester, key, 'r04_observation_reword_$tag');
    });

    testWidgets('history and the day detail at $tag%', (tester) async {
      if (_dir.isEmpty) return;
      final key = await open(tester, scale: scale);
      await tap(tester, 'See every day');
      await _save(tester, key, 'r05_history_$tag');
      await tester.tap(find.bySemanticsLabel(RegExp('^Thursday 15 October')));
      await tester.pumpAndSettle();
      await _save(tester, key, 'r06_day_detail_empty_$tag');
      await tester.tapAt(const Offset(180, 40));
      await tester.pumpAndSettle();
      // A done day, and a day that was never answered: the two states of an entry.
      await tester.tap(find.bySemanticsLabel(RegExp('^Wednesday 21 October')));
      await tester.pumpAndSettle();
      await _save(tester, key, 'r07_day_detail_done_$tag');
      await tester.tapAt(const Offset(180, 40));
      await tester.pumpAndSettle();
      final unanswered = await (db.select(db.reflections)..where((t) => t.status.equals('unknown'))).get();
      final item = await (db.select(db.planItems)..where((t) => t.id.equals(unanswered.first.planItemId))).getSingle();
      final d = parseDay(item.plannedDay);
      const months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      await tester.tap(find.bySemanticsLabel(RegExp('^\\w+ ${d.day} ${months[d.month - 1]}')));
      await tester.pumpAndSettle();
      await _save(tester, key, 'r08_day_detail_not_shared_$tag');
    });

    testWidgets('day one at $tag%', (tester) async {
      if (_dir.isEmpty) return;
      final key = await open(tester, scale: scale, dayOne: true);
      await _save(tester, key, 'r09_day_one_$tag');
    });
  }
}
