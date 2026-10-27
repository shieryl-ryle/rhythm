import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../data/providers.dart';

/// S-001 Welcome and consent. Nothing is stored until the person taps the button (BR-014).
class ConsentScreen extends ConsumerWidget {
  const ConsentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(LiltSpacing.xl),
                children: [
                  const SizedBox(height: LiltSpacing.xl),
                  Text('Welcome to Lilt', style: text.headlineMedium),
                  const SizedBox(height: LiltSpacing.md),
                  Text(
                    'Find ways to be active that fit your life, and an easy way back when it gets busy.',
                    style: text.bodyLarge?.copyWith(color: LiltColors.inkMuted),
                  ),
                  const SizedBox(height: LiltSpacing.xl),
                  const _Point('Ideas that fit what you like, your time and energy'),
                  const _Point('No streaks. Rest counts too.'),
                  const _Point('It learns from you, and shows what it changed'),
                  const SizedBox(height: LiltSpacing.lg),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(LiltSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Your health data stays on this phone.', style: text.titleSmall),
                          const SizedBox(height: LiltSpacing.xs),
                          Text(
                            'No account needed. Only the Together tab uses an account, and only if you choose it.',
                            style: text.bodyMedium?.copyWith(color: LiltColors.inkMuted),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: LiltSpacing.lg),
                  Text(
                    'Lilt supports everyday wellbeing. It’s not medical advice.',
                    style: text.bodySmall?.copyWith(color: LiltColors.inkMuted),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                LiltSpacing.lg,
                LiltSpacing.sm,
                LiltSpacing.lg,
                LiltSpacing.lg,
              ),
              child: FilledButton(
                onPressed: () => ref.read(consentProvider.notifier).agree(),
                child: const Text('I agree, continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Point extends StatelessWidget {
  const _Point(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: LiltSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6, right: LiltSpacing.md),
            child: Icon(Icons.circle, size: 8, color: LiltColors.primary),
          ),
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
