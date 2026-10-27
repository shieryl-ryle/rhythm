import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'stub_actions.dart';

/// S-004 Today. For the walking skeleton it lists three hard-coded library actions.
class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(LiltSpacing.lg),
          children: [
            const SizedBox(height: LiltSpacing.xl),
            Text('Here’s what fits today', style: text.headlineMedium),
            const SizedBox(height: LiltSpacing.lg),
            for (final action in stubActions) ...[
              _ActionCard(action: action),
              const SizedBox(height: LiltSpacing.md),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.action});

  final StubAction action;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(LiltSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(action.category, style: text.labelLarge?.copyWith(color: LiltColors.primary)),
            const SizedBox(height: LiltSpacing.xs),
            Text(action.title, style: text.titleMedium),
            const SizedBox(height: LiltSpacing.xs),
            Text(action.detail, style: text.bodyMedium?.copyWith(color: LiltColors.inkMuted)),
            const SizedBox(height: LiltSpacing.sm),
            Text(action.reason, style: text.bodyMedium),
          ],
        ),
      ),
    );
  }
}
