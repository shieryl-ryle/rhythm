import 'package:flutter/material.dart';

import '../app/theme.dart';

/// The progress bar of a wizard: one 24 dp segment per step, filled with `primary` up to the current step.
/// Screen readers hear "Step N of M" (docs/DESIGN.md, Setup steps).
class LiltStepProgress extends StatelessWidget {
  const LiltStepProgress({super.key, required this.step, required this.steps})
      : assert(step >= 1 && step <= steps, 'step is 1-based and within steps');

  /// The current step, starting at 1.
  final int step;
  final int steps;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Step $step of $steps',
      excludeSemantics: true,
      child: Row(
        children: [
          for (var i = 1; i <= steps; i++) ...[
            if (i > 1) const SizedBox(width: LiltSpacing.xs),
            Container(
              width: 24,
              height: 4,
              decoration: BoxDecoration(
                color: i <= step ? LiltColors.primary : LiltColors.field,
                borderRadius: BorderRadius.circular(LiltRadius.pill),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
