import 'package:flutter/material.dart';

import '../app/theme.dart';

/// A quick chip (docs/DESIGN.md Components, Interaction rules): 32 dp to look at, a 48 dp hit area, never
/// narrower than 48 dp, and the same height whether selected or not.
///
/// - Single choice: no tick. Multiple choice ([multi]): a tick when selected, which always means "you can pick
///   more than one".
/// - [menu] chips open a list and show a chevron and the chosen value; they have no tick.
class LiltChip extends StatelessWidget {
  const LiltChip({
    super.key,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.multi = false,
    this.menu = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool selected;
  final bool multi;
  final bool menu;

  @override
  Widget build(BuildContext context) {
    final showTick = multi && selected && !menu;
    return Semantics(
      button: true,
      selected: selected,
      enabled: onTap != null,
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          child: Center(
            widthFactor: 1,
            child: Container(
              constraints: const BoxConstraints(minHeight: 32),
              padding: const EdgeInsets.symmetric(horizontal: LiltSpacing.md, vertical: LiltSpacing.xs),
              decoration: ShapeDecoration(
                color: selected ? LiltColors.selected : LiltColors.surface,
                shape: StadiumBorder(
                  side: BorderSide(
                    color: selected ? LiltColors.primary : LiltColors.field,
                    width: selected ? 1.5 : 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showTick) ...[
                    const Icon(Icons.check, size: 16, color: LiltColors.primary),
                    const SizedBox(width: LiltSpacing.xs),
                  ],
                  Flexible(child: Text(label, style: LiltText.label, textAlign: TextAlign.center)),
                  if (menu) ...[
                    const SizedBox(width: LiltSpacing.xs),
                    const Icon(Icons.expand_more, size: 18, color: LiltColors.ink),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
