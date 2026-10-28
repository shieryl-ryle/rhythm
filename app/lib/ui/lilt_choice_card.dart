import 'package:flutter/material.dart';

import '../app/theme.dart';
import 'focus_ring.dart';

enum LiltChoiceKind { checkbox, radio }

/// A card for a choice of 4 or fewer longer options (docs/DESIGN.md, Selection): a checkbox when several can be
/// picked, a radio button when only one can. At least 48 dp tall and it grows with the text. [dimmed] is for an
/// exclusive choice that is unavailable right now: the text stays readable (`ink-muted`) but the card loses its
/// fill, and it can still be tapped.
class LiltChoiceCard extends StatelessWidget {
  const LiltChoiceCard({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.kind = LiltChoiceKind.checkbox,
    this.dimmed = false,
  });

  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback? onTap;
  final LiltChoiceKind kind;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(LiltRadius.card),
      side: BorderSide(
        color: selected ? LiltColors.primary : LiltColors.line,
        width: selected ? 1.5 : 1,
      ),
    );
    return Semantics(
      button: true,
      checked: kind == LiltChoiceKind.checkbox ? selected : null,
      selected: kind == LiltChoiceKind.radio ? selected : null,
      inMutuallyExclusiveGroup: kind == LiltChoiceKind.radio ? true : null,
      label: subtitle == null ? title : '$title, $subtitle',
      excludeSemantics: true,
      child: LiltFocusRing(
        onTap: onTap,
        shape: shape,
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: LiltSpacing.lg, vertical: LiltSpacing.md),
          decoration: ShapeDecoration(color: (dimmed || !selected) ? Colors.transparent : LiltColors.surface, shape: shape),
          child: Row(
            children: [
              _Mark(kind: kind, selected: selected),
              const SizedBox(width: LiltSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: LiltText.body.copyWith(color: dimmed ? LiltColors.inkMuted : LiltColors.ink),
                    ),
                    if (subtitle != null)
                      Text(subtitle!, style: LiltText.label.copyWith(color: LiltColors.inkMuted, fontWeight: FontWeight.w400)),
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

class _Mark extends StatelessWidget {
  const _Mark({required this.kind, required this.selected});

  final LiltChoiceKind kind;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.5);
    final size = 24.0 * scale;
    if (kind == LiltChoiceKind.checkbox) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: selected ? LiltColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: selected ? LiltColors.primary : LiltColors.field, width: 1.5),
        ),
        child: selected ? Icon(Icons.check, size: size * 0.75, color: LiltColors.onPrimary) : null,
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: selected ? LiltColors.ink : LiltColors.field, width: 1.5),
      ),
      child: selected
          ? Center(
              child: Container(
                width: size * 0.6,
                height: size * 0.6,
                decoration: const BoxDecoration(color: LiltColors.ink, shape: BoxShape.circle),
              ),
            )
          : null,
    );
  }
}
