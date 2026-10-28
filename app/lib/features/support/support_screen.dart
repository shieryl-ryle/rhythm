import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../ui/ui.dart';
import 'helplines.dart';
import 'support_providers.dart';

/// S-090 Support message (BR-003): fixed wording, no AI, no suggestion, and nothing the person typed is kept.
/// Shown whenever free text matches the red-flag list. The three rows open the numbers for the person's
/// region as text; the app never dials (owner decision 2026-10-28).
class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final helplines = ref.watch(helplinesProvider).valueOrNull;
    final region = helplines?.regionFor(ref.watch(deviceCountryProvider));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(LiltSpacing.lg, LiltSpacing.xl, LiltSpacing.lg, LiltSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(header: true, child: const Text('You don’t have to handle this alone', style: LiltText.display)),
                    const SizedBox(height: LiltSpacing.md),
                    Text(
                      'Lilt can’t help with this, but people can. If you are in danger right now, call your local emergency number.',
                      style: LiltText.body.copyWith(color: LiltColors.inkMuted),
                    ),
                    const SizedBox(height: LiltSpacing.lg),
                    _ActionRow(
                      title: 'Call emergency services',
                      subtitle: 'If you’re in danger now',
                      filled: true,
                      onTap: () => _open(
                        context,
                        title: 'Call emergency services',
                        numbers: region?.emergency ?? const [],
                        fallback: 'Call your local emergency number.',
                      ),
                    ),
                    const SizedBox(height: LiltSpacing.sm),
                    _ActionRow(
                      title: 'Call a crisis line',
                      subtitle: (region?.crisis.isNotEmpty ?? false) ? '24/7, free and confidential' : 'Ask for one in your country',
                      onTap: () => _open(
                        context,
                        title: 'Call a crisis line',
                        numbers: region?.crisis ?? const [],
                        fallback: 'Look for a crisis line in your country, or ask your doctor or someone you trust to help you find one.',
                      ),
                    ),
                    const SizedBox(height: LiltSpacing.sm),
                    _ActionRow(
                      title: 'Talk to your doctor',
                      subtitle: 'Someone you trust',
                      onTap: () => _open(
                        context,
                        title: 'Talk to your doctor',
                        numbers: const [],
                        fallback: region?.doctorNote ??
                            'Contact your doctor, a clinic or a health professional you trust. If you can, tell someone close to you how you feel.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(LiltSpacing.lg, 0, LiltSpacing.lg, LiltSpacing.lg),
              child: LiltButton(
                label: 'Back',
                kind: LiltButtonKind.text,
                onPressed: () => context.canPop() ? context.pop() : context.go('/'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _open(
    BuildContext context, {
    required String title,
    required List<HelplineNumber> numbers,
    required String fallback,
  }) {
    showLiltSheet<void>(
      context,
      title: title,
      bodyBuilder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final n in numbers) ...[
            Text(n.label, style: LiltText.label.copyWith(color: LiltColors.inkMuted)),
            SelectableText(n.number, style: LiltText.celebration),
            const SizedBox(height: LiltSpacing.lg),
          ],
          if (numbers.isEmpty) Text(fallback, style: LiltText.body),
        ],
      ),
    );
  }
}

/// A two-line action row (12 dp radius, DESIGN.md Shapes). The first is the screen's one filled primary.
class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.title, required this.subtitle, required this.onTap, this.filled = false});

  final String title;
  final String subtitle;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = filled ? LiltColors.onPrimary : LiltColors.ink;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(LiltRadius.md),
      side: BorderSide(color: filled ? LiltColors.ink : LiltColors.field),
    );
    return Semantics(
      button: true,
      label: '$title, $subtitle',
      excludeSemantics: true,
      child: LiltFocusRing(
        onTap: onTap,
        shape: shape,
        child: Container(
          constraints: const BoxConstraints(minHeight: 64),
          padding: const EdgeInsets.symmetric(horizontal: LiltSpacing.lg, vertical: LiltSpacing.md),
          decoration: ShapeDecoration(color: filled ? LiltColors.ink : Colors.transparent, shape: shape),
          child: Row(
            children: [
              Icon(Icons.phone_outlined, color: filled ? LiltColors.onPrimary : LiltColors.primary),
              const SizedBox(width: LiltSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: LiltText.body.copyWith(fontWeight: FontWeight.w600, color: fg)),
                    Text(
                      subtitle,
                      style: LiltText.label.copyWith(
                        fontWeight: FontWeight.w400,
                        color: filled ? LiltColors.onPrimary : LiltColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
