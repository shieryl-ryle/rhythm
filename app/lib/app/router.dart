import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/providers.dart';
import '../features/consent/consent_screen.dart';
import '../features/today/today_screen.dart';

/// Routes from docs/sitemap.md §4. Without consent every route redirects to /welcome (BR-014).
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(consentProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final consent = ref.read(consentProvider);
      final at = state.matchedLocation;
      if (consent.isLoading) return at == '/' ? null : '/';
      final agreed = consent.value ?? false;
      if (!agreed) return at == '/welcome' ? null : '/welcome';
      return (at == '/' || at == '/welcome') ? '/today' : null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, _) => const _Splash()),
      GoRoute(path: '/welcome', builder: (_, _) => const ConsentScreen()),
      GoRoute(path: '/today', builder: (_, _) => const TodayScreen()),
    ],
  );
});

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) => const Scaffold(body: SizedBox.shrink());
}
