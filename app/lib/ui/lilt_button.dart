import 'package:flutter/material.dart';

import '../app/theme.dart';
import 'focus_ring.dart';

enum LiltButtonKind { primary, secondary, text }

/// The one button (docs/DESIGN.md Components). Always at least 48 dp tall, pill shaped.
///
/// - **primary**: filled `ink`. One per screen.
/// - **secondary**: outlined, `ink` text. With [danger] the text and border are `danger`, never filled (the
///   delete-all rule).
/// - **text**: semibold `ink`, no underline, for in-app actions such as "Something else" and "Not today". A
///   standalone, left-aligned one is [flush]: its label sits on the content edge and the 48 dp target stays.
///
/// A null [onPressed] shows the disabled look. [loading] keeps the button's place and shows a spinner. Keyboard
/// focus shows a 2 px `primary` ring.
class LiltButton extends StatelessWidget {
  const LiltButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.kind = LiltButtonKind.primary,
    this.icon,
    this.loading = false,
    this.danger = false,
    this.flush = false,
    this.expand,
    this.semanticLabel,
  }) : assert(!flush || kind == LiltButtonKind.text, 'Only a text button can be flush');

  final String label;
  final VoidCallback? onPressed;
  final LiltButtonKind kind;
  final IconData? icon;
  final bool loading;
  final bool danger;
  final bool flush;

  /// Full width. Defaults to true for primary and secondary, false for text.
  final bool? expand;

  /// What a screen reader says when the visible label alone is not enough ("Edit" on a list of cards).
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final fullWidth = expand ?? kind != LiltButtonKind.text;
    final VoidCallback? tap = loading ? () {} : onPressed;

    // The spinner is drawn in the label's colour, so it never vanishes on a light button.
    final spinnerColor = switch (kind) {
      LiltButtonKind.primary => LiltColors.onPrimary,
      LiltButtonKind.secondary => danger ? LiltColors.danger : LiltColors.ink,
      LiltButtonKind.text => LiltColors.ink,
    };
    final content = loading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: spinnerColor),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: LiltSpacing.sm)],
              Flexible(child: Text(label, textAlign: flush ? TextAlign.start : TextAlign.center)),
            ],
          );

    const shape = StadiumBorder();
    final padding = EdgeInsets.symmetric(
      horizontal: flush ? 0 : (kind == LiltButtonKind.text ? LiltSpacing.md : LiltSpacing.xl),
      vertical: LiltSpacing.md,
    );
    final minimum = Size(fullWidth ? double.infinity : 48, 48);
    final alignment = flush ? Alignment.centerLeft : Alignment.center;

    // Focus shows a 2 px primary ring; otherwise the button keeps its own edge, if it has one.
    WidgetStateProperty<BorderSide?> side(BorderSide? resting) =>
        WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.focused) ? focusRingSide : resting);

    final Widget button = switch (kind) {
      LiltButtonKind.primary => FilledButton(
          onPressed: tap,
          style: FilledButton.styleFrom(
            minimumSize: minimum,
            padding: padding,
            shape: shape,
            backgroundColor: LiltColors.ink,
            foregroundColor: LiltColors.onPrimary,
            disabledBackgroundColor: LiltColors.selected,
            disabledForegroundColor: LiltColors.inkMuted,
            textStyle: LiltText.button,
          ).copyWith(side: side(null)),
          child: content,
        ),
      LiltButtonKind.secondary => OutlinedButton(
          onPressed: tap,
          style: OutlinedButton.styleFrom(
            minimumSize: minimum,
            padding: padding,
            shape: shape,
            foregroundColor: danger ? LiltColors.danger : LiltColors.ink,
            disabledForegroundColor: LiltColors.inkMuted,
            textStyle: LiltText.button,
          ).copyWith(
            side: side(BorderSide(color: danger ? LiltColors.danger : LiltColors.field, width: 1.5)),
          ),
          child: content,
        ),
      LiltButtonKind.text => TextButton(
          onPressed: tap,
          style: TextButton.styleFrom(
            minimumSize: minimum,
            padding: padding,
            alignment: alignment,
            shape: shape,
            foregroundColor: LiltColors.ink,
            disabledForegroundColor: LiltColors.inkMuted,
            textStyle: LiltText.button,
          ).copyWith(side: side(null)),
          child: content,
        ),
    };

    final spoken = semanticLabel != null && !loading;
    return Semantics(
      container: true,
      label: loading ? '$label, loading' : semanticLabel,
      excludeSemantics: loading || spoken,
      button: loading || spoken,
      // excludeSemantics drops the tap handler below, so the button says it can be activated itself.
      onTap: spoken ? onPressed : null,
      enabled: onPressed != null,
      child: button,
    );
  }
}
