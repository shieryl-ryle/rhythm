import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lilt/app/app.dart';
import 'package:lilt/data/consent_repository.dart';
import 'package:lilt/data/library/library_loader.dart';
import 'package:lilt/data/providers.dart';
import 'package:lilt/features/today/stub_actions.dart';

import 'support/test_support.dart';

/// In-memory stand-in for the drift repository (the interface seam, ADR-002 decision 6).
class FakeConsentRepository implements ConsentRepository {
  bool agreed = false;
  int writes = 0;

  @override
  Future<bool> hasAgreed() async => agreed;

  @override
  Future<void> agree() async {
    writes++;
    agreed = true;
  }
}

void main() {
  testWidgets('consent comes first, nothing is stored until the person agrees, then Today shows 3 actions',
      (tester) async {
    final repo = FakeConsentRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          consentRepositoryProvider.overrideWithValue(repo),
          libraryLoaderProvider.overrideWithValue(NoopLibraryLoader()),
        ],
        child: const LiltApp(),
      ),
    );
    await tester.pumpAndSettle();

    // S-001: consent is shown and nothing has been written (BR-014).
    expect(find.text('Welcome to Lilt'), findsOneWidget);
    expect(find.text('Your health data stays on this phone.'), findsOneWidget);
    expect(repo.writes, 0);

    await tester.tap(find.text('I agree, continue'));
    await tester.pumpAndSettle();

    // S-004: three hard-coded library actions.
    expect(repo.writes, 1);
    expect(find.text('Here’s what fits today'), findsOneWidget);
    expect(stubActions.length, 3);
    for (final action in stubActions) {
      expect(find.text(action.title), findsOneWidget);
    }
    expect(find.text('Welcome to Lilt'), findsNothing);
  });

  testWidgets('the consent screen explains what is stored without agreeing (BR-014)', (tester) async {
    final repo = FakeConsentRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          consentRepositoryProvider.overrideWithValue(repo),
          libraryLoaderProvider.overrideWithValue(NoopLibraryLoader()),
        ],
        child: const LiltApp(),
      ),
    );
    await tester.pumpAndSettle();

    final link = find.text('See exactly what we store', skipOffstage: false);
    await tester.ensureVisible(link);
    await tester.pumpAndSettle();
    await tester.tap(link);
    await tester.pumpAndSettle();

    expect(find.text('What we store'), findsOneWidget);
    expect(find.text('What Lilt uses'), findsOneWidget);
    expect(find.text('Only on this phone. No tracking, no ads.'), findsOneWidget);
    expect(repo.writes, 0);

    await tester.tap(find.text('Got it'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome to Lilt', skipOffstage: false), findsOneWidget);
    expect(repo.writes, 0);
  });

  testWidgets('a person who already agreed goes straight to Today', (tester) async {
    final repo = FakeConsentRepository()..agreed = true;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          consentRepositoryProvider.overrideWithValue(repo),
          libraryLoaderProvider.overrideWithValue(NoopLibraryLoader()),
        ],
        child: const LiltApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Here’s what fits today'), findsOneWidget);
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('a library that fails to load does not undo consent', (tester) async {
    final repo = FakeConsentRepository()..agreed = true;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          consentRepositoryProvider.overrideWithValue(repo),
          libraryLoaderProvider.overrideWithValue(_FailingLibraryLoader()),
        ],
        child: const LiltApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Here’s what fits today'), findsOneWidget);
    expect(find.text('Welcome to Lilt'), findsNothing);
    final container = ProviderScope.containerOf(tester.element(find.byType(LiltApp)));
    expect(container.read(libraryReadyProvider).hasError, isTrue);
  });
}

class _FailingLibraryLoader implements LibraryLoader {
  @override
  Future<int> load() async => throw const FormatException('broken library');
}
