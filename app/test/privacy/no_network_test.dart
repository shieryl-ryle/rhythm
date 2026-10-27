import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/app/app.dart';
import 'package:lilt/data/database.dart';
import 'package:lilt/data/library/library_loader.dart';
import 'package:lilt/data/providers.dart';

import '../support/test_support.dart';

/// TC-023 (BR-015): no network call carries personal data, and no analytics or advertising package is a
/// dependency. Any HTTP request during the flow fails the test.
class _NoNetwork extends HttpOverrides {
  final requested = <String>[];

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    requested.add('createHttpClient');
    throw StateError('The app made a network request (BR-015).');
  }
}

void main() {
  test('pubspec.yaml has no analytics, crash-reporting or advertising package', () {
    final text = File('pubspec.yaml').readAsStringSync();
    final dependencies = RegExp(r'^  ([a-z0-9_]+):', multiLine: true)
        .allMatches(text.split('dev_dependencies:').first)
        .map((m) => m.group(1)!)
        .toSet();

    final banned = RegExp(
      r'analytics|crashlytics|sentry|mixpanel|amplitude|posthog|appsflyer|adjust|segment|'
      r'google_mobile_ads|admob|facebook_app_events|bugsnag|datadog|instabug',
    );
    final found = dependencies.where(banned.hasMatch).toList();
    expect(found, isEmpty, reason: 'Analytics or ad packages are not allowed in P0: $found');
  });

  testWidgets('consent, Today, export and delete-all make no network request', (tester) async {
    final overrides = _NoNetwork();
    final previous = HttpOverrides.current;
    HttpOverrides.global = overrides;
    addTearDown(() => HttpOverrides.global = previous);

    final db = LiltDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          libraryLoaderProvider.overrideWithValue(DriftLibraryLoader(db, readAssetFile)),
        ],
        child: const LiltApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('I agree, continue'));
    await tester.pumpAndSettle();
    expect(find.text('Here’s what fits today'), findsOneWidget);

    final container = ProviderScope.containerOf(tester.element(find.byType(LiltApp)));
    final json = await container.read(myDataServiceProvider).exportJson();
    expect(json, contains('"consent"'));
    await container.read(deleteEverythingProvider)();
    await tester.pumpAndSettle();

    expect(overrides.requested, isEmpty);
  });
}
