import 'package:flutter/material.dart';

import '../app/theme.dart';

/// The keyboard focus ring (docs/DESIGN.md: `primary` is the focus ring; WCAG 2.4.7). A 2 px `primary` outline
/// that follows [shape] and shows only while the control has keyboard focus. Material's own focus tint is far
/// too faint on an ink button or a white chip.
const focusRingSide = BorderSide(color: LiltColors.primary, width: 2);

/// An [InkWell] that draws the focus ring around its child.
class LiltFocusRing extends StatefulWidget {
  const LiltFocusRing({super.key, required this.shape, required this.onTap, required this.child});

  /// The outline of the control: a stadium for chips and segments, a rounded rectangle for a tab.
  final OutlinedBorder shape;
  final VoidCallback? onTap;
  final Widget child;

  @override
  State<LiltFocusRing> createState() => _LiltFocusRingState();
}

class _LiltFocusRingState extends State<LiltFocusRing> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      customBorder: widget.shape,
      onFocusChange: (focused) => setState(() => _focused = focused),
      child: Container(
        key: _focused ? const Key('lilt-focus-ring') : null,
        foregroundDecoration: _focused ? ShapeDecoration(shape: widget.shape.copyWith(side: focusRingSide)) : null,
        child: widget.child,
      ),
    );
  }
}
