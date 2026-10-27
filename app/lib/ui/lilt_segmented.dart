import 'package:flutter/material.dart';

import '../app/theme.dart';
import 'focus_ring.dart';

class LiltSegment<T> {
  const LiltSegment({required this.value, required this.label});

  final T value;
  final String label;
}

/// A single choice from 2 or 3 short options (docs/DESIGN.md Components). 48 dp tall, a tinted track and a white
/// selected segment with a cobalt outline. At large text (1.5x and up) the segments stack, one per row.
/// Not for navigation tabs.
class LiltSegmented<T> extends StatelessWidget {
  const LiltSegmented({super.key, required this.segments, required this.value, required this.onChanged})
      : assert(segments.length >= 2 && segments.length <= 3, 'A segmented control has 2 or 3 segments');

  final List<LiltSegment<T>> segments;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final stacked = MediaQuery.textScalerOf(context).scale(1) >= 1.5;

    Widget cell(LiltSegment<T> s) {
      final selected = s.value == value;
      return Semantics(
        button: true,
        selected: selected,
        inMutuallyExclusiveGroup: true,
        child: LiltFocusRing(
          onTap: () => onChanged(s.value),
          shape: const StadiumBorder(),
          child: Container(
            constraints: const BoxConstraints(minHeight: 48),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: LiltSpacing.md, vertical: LiltSpacing.sm),
            decoration: selected
                ? const ShapeDecoration(
                    color: LiltColors.surface,
                    shape: StadiumBorder(side: BorderSide(color: LiltColors.primary, width: 1.5)),
                  )
                : null,
            child: Text(
              s.label,
              textAlign: TextAlign.center,
              style: LiltText.label.copyWith(
                color: selected ? LiltColors.ink : LiltColors.inkMuted,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(LiltSpacing.xs / 2),
      decoration: ShapeDecoration(
        color: LiltColors.selected,
        shape: stacked
            ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(LiltRadius.card))
            : const StadiumBorder(),
      ),
      child: stacked
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [for (final s in segments) cell(s)],
            )
          : Row(children: [for (final s in segments) Expanded(child: cell(s))]),
    );
  }
}
