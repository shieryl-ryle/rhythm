import 'package:flutter/material.dart';

import '../app/theme.dart';
import 'focus_ring.dart';

/// A list row (docs/DESIGN.md: a full-width row is a 48 dp target; rows touch and a 1 dp divider separates
/// them). At least 48 dp tall and it grows with the text, so nothing is cut at 200%. A second line is optional.
/// A chevron shows when the row opens something.
class LiltListRow extends StatelessWidget {
  const LiltListRow({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.chevron = true,
    this.divider = true,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool chevron;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: subtitle == null ? title : '$title, $subtitle',
      excludeSemantics: true,
      child: LiltFocusRing(
        onTap: onTap,
        shape: const RoundedRectangleBorder(),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: divider ? const Border(bottom: BorderSide(color: LiltColors.line)) : null,
          ),
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(vertical: LiltSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title, style: LiltText.body.copyWith(fontWeight: FontWeight.w600)),
                      if (subtitle != null)
                        Text(subtitle!, style: LiltText.label.copyWith(color: LiltColors.inkMuted, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
                if (chevron) const Icon(Icons.chevron_right, color: LiltColors.ink),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
