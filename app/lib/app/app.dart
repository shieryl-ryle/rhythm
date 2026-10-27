import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme.dart';

class LiltApp extends ConsumerWidget {
  const LiltApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Lilt',
      debugShowCheckedModeBanner: false,
      theme: buildLiltTheme(),
      routerConfig: ref.watch(routerProvider),
      // On wide screens the web build is centred at 480 px so it looks like the phone app.
      builder: (context, child) => ColoredBox(
        color: LiltColors.canvas,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: child,
          ),
        ),
      ),
    );
  }
}
