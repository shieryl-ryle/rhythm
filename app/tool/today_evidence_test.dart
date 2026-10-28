import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/drift.dart' hide isNull, isNotNull;
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
import 'package:lilt/data/providers.dart';
import 'package:lilt/domain/day.dart';
import 'package:lilt/features/starting_point/setup_model.dart';
import 'package:lilt/features/starting_point/setup_repository.dart';
import 'package:lilt/features/support/support_providers.dart';

import '../test/support/test_support.dart';

/// Renders the Today screen in its states with the bundled fonts and writes PNGs for the senior UI review
/// (step 2 of the build checks). Evidence for a person to compare with Figma, not golden files.
///
///     flutter test tool/today_evidence_test.dart --dart-define=EVIDENCE_DIR=C:/some/folder
const _dir = String.fromEnvironment('EVIDENCE_DIR');

class _Agreed implements ConsentRepository {
  @override
  Future<bool> hasAgreed() async => true;
  @override
  Future<void> agree() async {}
}

class _NoLibrary extends NoopLibraryLoader {}

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
  paths: {SetupPath.keepGoing, SetupPath.pickUpAgain},
  keepActivity: ActivityKind.gym,
  progress: Progress.goingWell,
  pickUpActivity: ActivityKind.running,
  stoppedAgo: StoppedAgo.months,
  freeTimes: {'lunch', 'weekends'},
  access: {'gym_membership'},
);

/// A history of past reflections so the grid is populated: a pattern of done, partly and rest days.
Future<void> _history(LiltDatabase db) async {
  final actions = await db.select(db.actions).get();
  final run = actions.firstWhere((a) => a.id == 'act_run_walk_20');
  const today = '2026-10-23';
  for (var i = 1; i <= 60; i++) {
    if (i % 3 == 0 || i % 7 == 0) continue; // rest days
    final day = addDays(today, -i);
    final item = await db.into(db.planItems).insertReturning(
          PlanItemsCompanion.insert(
            source: PlanSource.offer,
            activity: run.activity,
            title: run.title,
            plannedDay: day,
            actionId: Value(run.id),
          ),
        );
    await db.into(db.reflections).insert(
          ReflectionsCompanion.insert(
            planItemId: item.id,
            status: Value(i % 4 == 0 ? ReflectionStatus.partly : ReflectionStatus.completed),
            enjoyment: const Value(3),
          ),
        );
  }
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

  Future<(LiltDatabase, GlobalKey)> open(
    WidgetTester tester, {
    double scale = 1,
    Future<void> Function(LiltDatabase)? seed,
    bool emptyLibrary = false,
  }) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final db = inMemoryDatabase();
    addTearDown(db.close);
    await DriftLibraryLoader(db, readAssetFile).load();
    await DriftSetupRepository(db).save(_runner);
    await seed?.call(db);
    final key = GlobalKey();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          consentRepositoryProvider.overrideWithValue(_Agreed()),
          ...todayTestOverrides(db),
          if (emptyLibrary) libraryLoaderProvider.overrideWithValue(_NoLibrary()),
          assetReaderProvider.overrideWithValue(readAssetFile),
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
    return (db, key);
  }

  Future<void> tap(WidgetTester tester, String text, {int index = 0}) async {
    final finder = find.text(text).at(index);
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  for (final scale in [1.0, 2.0]) {
    final tag = '${(scale * 100).round()}';

    testWidgets('day one, plan and sheets at $tag%', (tester) async {
      if (_dir.isEmpty) return;
      final (_, key) = await open(tester, scale: scale);
      await _save(tester, key, 't01_day_one_$tag');
      await tap(tester, 'Not today');
      await _save(tester, key, 't02_not_today_sheet_$tag');
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      await tap(tester, '20 min');
      await _save(tester, key, 't03_time_sheet_$tag');
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();
      await tap(tester, 'I’ll try this');
      await _save(tester, key, 't04_planned_$tag');
    });

    testWidgets('with history and paused at $tag%', (tester) async {
      if (_dir.isEmpty) return;
      final (_, key) = await open(tester, scale: scale, seed: _history);
      await _save(tester, key, 't05_with_history_$tag');
      await tap(tester, 'Not today');
      await tap(tester, 'Pause for 1 week');
      await _save(tester, key, 't06_paused_$tag');
    });

    testWidgets('nothing fits at $tag%', (tester) async {
      if (_dir.isEmpty) return;
      Future<void> oneAction(LiltDatabase db) async {
        await db.delete(db.actions).go();
        await db.into(db.actions).insert(
              ActionsCompanion.insert(
                id: 'act_only',
                activity: ActivityKind.running,
                title: 'A long easy run',
                description: 'Run at an easy pace.',
                durationMin: 45,
                intensity: Intensity.low,
                energyNeeded: Energy.medium,
                tags: const Value('solo,outdoors,free'),
                isStarter: const Value(true),
                libraryVersion: 'test-1',
              ),
            );
      }

      final (_, key) = await open(tester, scale: scale, seed: oneAction, emptyLibrary: true);
      await _save(tester, key, 't07_nothing_fits_chips_$tag');
    });
  }
}
