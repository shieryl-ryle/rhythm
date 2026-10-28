import 'package:flutter/material.dart';

import '../app/theme.dart';

/// Buttons that sit side by side at normal text size and stack at large text (1.5x and up), full width, so a
/// label never breaks mid-word (docs/DESIGN.md, Large text). Keep the screen's one primary out of this row.
class LiltButtonRow extends StatelessWidget {
  const LiltButtonRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final stacked = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
    if (stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: LiltSpacing.sm),
            children[i],
          ],
        ],
      );
    }
    return Row(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: LiltSpacing.sm),
          Expanded(child: children[i]),
        ],
      ],
    );
  }
}
