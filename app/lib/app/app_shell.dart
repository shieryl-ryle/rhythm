import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/ui.dart';

/// The four tabs (docs/sitemap.md §1): Today, Discover, Together, My rhythm. Each keeps its own place when the
/// person switches away and back.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: LiltNavBar(
        index: shell.currentIndex,
        // Tapping the tab you are on goes back to its first screen.
        onSelect: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
      ),
    );
  }
}

/// A tab whose screens are not built yet. It says so plainly instead of leaving a dead tab.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Semantics(header: true, child: Text(title, style: const TextStyle(fontFamily: 'Instrument Serif', fontStyle: FontStyle.italic, fontSize: 34, height: 1.18))),
              const SizedBox(height: 12),
              Text(body, style: const TextStyle(fontFamily: 'Geist', fontSize: 16, height: 1.5, color: Color(0xFF5A6168))),
            ],
          ),
        ),
      ),
    );
  }
}
