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
    this.selected = false,
    this.trailing,
    this.liveRegion = false,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool chevron;
  final bool divider;

  /// A choice in a list of choices: shows a tick, and tells screen readers it is selected.
  final bool selected;

  /// An icon at the end for a row that does something rather than opening a screen (a chevron means "opens").
  final Widget? trailing;

  /// The row's lines change while the person is on it (a state such as "Copied"), so a screen reader announces them.
  final bool liveRegion;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      liveRegion: liveRegion,
      // excludeSemantics drops the tap handler below, so the row says it can be activated itself.
      onTap: onTap,
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
                if (selected) const Icon(Icons.check, color: LiltColors.primary),
                ?trailing,
                if (chevron && !selected && trailing == null) const Icon(Icons.chevron_right, color: LiltColors.ink),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
