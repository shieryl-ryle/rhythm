import 'package:flutter/material.dart';

import '../app/theme.dart';

/// The logo mark: three bars, `peak` (cobalt), `dip` (light cobalt) and `comeback` (orange), with heights in the
/// fixed ratio 1 : 0.75 : 0.87 on one baseline and a gap of half a bar width (docs/DESIGN.md, Brand motion).
/// It is decorative; the name "Lilt" comes from [semanticLabel].
///
/// [beat] (0 to 1) changes each bar by a different amount, so the bars never move in unison. A static mark
/// uses 0.
class EqualizerBars extends StatelessWidget {
  const EqualizerBars({super.key, this.height = 28, this.beat = 0, this.semanticLabel = 'Lilt'});

  /// The height of the tallest bar.
  final double height;
  final double beat;
  final String? semanticLabel;

  /// Bar width as a share of the tallest bar.
  static const _barWidthRatio = 0.22;

  @override
  Widget build(BuildContext context) {
    final bar = height * _barWidthRatio;
    final width = bar * 3 + bar * 0.5 * 2;
    return Semantics(
      label: semanticLabel,
      image: true,
      excludeSemantics: true,
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(painter: _BarsPainter(bar: bar, beat: beat)),
      ),
    );
  }
}

class _BarsPainter extends CustomPainter {
  _BarsPainter({required this.bar, required this.beat});

  final double bar;
  final double beat;

  static const _ratios = [1.0, 0.75, 0.87];
  // How far each bar moves at a full beat, as a share of its height; different in size and direction.
  static const _beatShift = [-0.12, 0.2, -0.06];
  static const _colors = [LiltColors.eqPeak, LiltColors.eqDip, LiltColors.eqComeback];

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < 3; i++) {
      final h = (size.height * (_ratios[i] + _beatShift[i] * beat)).clamp(bar, size.height);
      final x = i * (bar + bar * 0.5);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, size.height - h, bar, h), Radius.circular(bar / 2)),
        Paint()..color = _colors[i],
      );
    }
  }

  @override
  bool shouldRepaint(_BarsPainter old) => old.bar != bar || old.beat != beat;
}
