import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/providers.dart';
import '../features/consent/consent_screen.dart';
import '../features/discover/activity_detail_screen.dart';
import '../features/discover/discover_screen.dart';
import '../features/rhythm/history_screen.dart';
import '../features/rhythm/rhythm_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/starting_point/setup_controller.dart';
import '../features/starting_point/setup_screen.dart';
import '../features/support/support_screen.dart';
import '../features/today/today_screen.dart';
import '../features/way_back/way_back_screen.dart';
import 'app_shell.dart';

/// Routes from docs/sitemap.md §4. Without consent every route except the support message redirects to
/// /welcome (BR-014); after consent and until setup is finished everything goes to /setup.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(consentProvider, (_, _) => refresh.value++);
  ref.listen(setupDoneProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    observers: [_ClearSnackBars()],
    redirect: (context, state) {
      final at = state.matchedLocation;
      // S-090 is public: a person in distress is never sent somewhere else first (BR-003).
      if (at == '/support') return null;

      final consent = ref.read(consentProvider);
      if (consent.isLoading) return at == '/' ? null : '/';
      if (!(consent.value ?? false)) return at == '/welcome' ? null : '/welcome';

      final setup = ref.read(setupDoneProvider);
      if (setup.isLoading) return at == '/' ? null : '/';
      if (!(setup.value ?? false)) return at == '/setup' ? null : '/setup';

      return (at == '/' || at == '/welcome' || at == '/setup') ? '/today' : null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, _) => const _Splash()),
      GoRoute(path: '/welcome', builder: (_, _) => const ConsentScreen()),
      GoRoute(path: '/setup', builder: (_, _) => const SetupScreen()),
      GoRoute(path: '/support', builder: (_, _) => const SupportScreen()),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
      // My Way Back (S-005): offered by a banner on Today after a lapse, and by a link on My rhythm.
      GoRoute(path: '/way-back', builder: (_, _) => const WayBackScreen()),
      // Activity detail (S-013): opened from a Discover card.
      GoRoute(path: '/activity/:id', builder: (_, state) => ActivityDetailScreen(actionId: state.pathParameters['id']!)),
      // The full history is a page above the tabs, with Back (frame 6.4).
      GoRoute(path: '/rhythm/history', builder: (_, _) => const HistoryScreen()),
      // The four tabs. Together is not built yet and says so.
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/today', builder: (_, _) => const TodayScreen())]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/discover', builder: (_, _) => const DiscoverScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/together',
              builder: (_, _) => const ComingSoonScreen(title: 'Together', body: 'Events and clubs near you. Coming soon.'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/rhythm', builder: (_, _) => const RhythmScreen()),
          ]),
        ],
      ),
    ],
  );
});

/// Opening or leaving a screen above the tabs (Settings, the support message, a sheet) clears any snackbar, so a
/// message about Today is never drawn over the support message (BR-003).
class _ClearSnackBars extends NavigatorObserver {
  void _clear() {
    final context = navigator?.context;
    if (context != null) ScaffoldMessenger.maybeOf(context)?.clearSnackBars();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => _clear();

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => _clear();
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) => const Scaffold(body: SizedBox.shrink());
}
