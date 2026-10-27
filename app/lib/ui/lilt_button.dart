import 'package:flutter/material.dart';

import '../app/theme.dart';

enum LiltButtonKind { primary, secondary, text }

/// The one button (docs/DESIGN.md Components). Always at least 48 dp tall, pill shaped.
///
/// - **primary**: filled `ink`. One per screen.
/// - **secondary**: outlined, `ink` text. With [danger] the text and border are `danger`, never filled (the
///   delete-all rule).
/// - **text**: semibold `ink`, no underline, for in-app actions such as "Something else" and "Not today".
///
/// A null [onPressed] shows the disabled look. [loading] keeps the button's place and shows a spinner.
class LiltButton extends StatelessWidget {
  const LiltButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.kind = LiltButtonKind.primary,
    this.icon,
    this.loading = false,
    this.danger = false,
    this.expand,
  });

  final String label;
  final VoidCallback? onPressed;
  final LiltButtonKind kind;
  final IconData? icon;
  final bool loading;
  final bool danger;

  /// Full width. Defaults to true for primary and secondary, false for text.
  final bool? expand;

  @override
  Widget build(BuildContext context) {
    final fullWidth = expand ?? kind != LiltButtonKind.text;
    final VoidCallback? tap = loading ? () {} : onPressed;

    final content = loading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: LiltColors.onPrimary),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: LiltSpacing.sm)],
              Flexible(child: Text(label, textAlign: TextAlign.center)),
            ],
          );

    final shape = const StadiumBorder();
    final padding = EdgeInsets.symmetric(
      horizontal: kind == LiltButtonKind.text ? LiltSpacing.md : LiltSpacing.xl,
      vertical: LiltSpacing.md,
    );
    final minimum = Size(fullWidth ? double.infinity : 48, 48);

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
          ),
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
            side: BorderSide(color: danger ? LiltColors.danger : LiltColors.field, width: 1.5),
            textStyle: LiltText.button,
          ),
          child: content,
        ),
      LiltButtonKind.text => TextButton(
          onPressed: tap,
          style: TextButton.styleFrom(
            minimumSize: minimum,
            padding: padding,
            shape: shape,
            foregroundColor: LiltColors.ink,
            disabledForegroundColor: LiltColors.inkMuted,
            textStyle: LiltText.button,
          ),
          child: content,
        ),
    };

    return Semantics(
      container: true,
      label: loading ? '$label, loading' : null,
      excludeSemantics: loading,
      button: loading,
      enabled: onPressed != null,
      child: button,
    );
  }
}
