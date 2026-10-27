import 'package:flutter/material.dart';

/// Colour tokens from docs/DESIGN.md (frontmatter). Code uses the token names, not raw hex.
abstract final class LiltColors {
  static const primary = Color(0xFF2F3BFF);
  static const onPrimary = Color(0xFFFFFFFF);
  static const canvas = Color(0xFFF3F4F2);
  static const surface = Color(0xFFFFFFFF);
  static const selected = Color(0xFFE5E7EF);
  static const ink = Color(0xFF111418);
  static const inkMuted = Color(0xFF5A6168);
  static const line = Color(0xFFE1E3E0);
  static const field = Color(0xFF868C92);
  static const accent = Color(0xFFB84A00);
  static const danger = Color(0xFFC62828);
}

/// Spacing tokens from docs/DESIGN.md.
abstract final class LiltSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

/// Radius tokens from docs/DESIGN.md.
abstract final class LiltRadius {
  static const card = 20.0;
  static const pill = 9999.0;
}

ThemeData buildLiltTheme() {
  const scheme = ColorScheme.light(
    primary: LiltColors.primary,
    onPrimary: LiltColors.onPrimary,
    surface: LiltColors.surface,
    onSurface: LiltColors.ink,
    secondary: LiltColors.accent,
    error: LiltColors.danger,
    outline: LiltColors.field,
    outlineVariant: LiltColors.line,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: LiltColors.canvas,
    textTheme: Typography.blackMountainView.apply(
      bodyColor: LiltColors.ink,
      displayColor: LiltColors.ink,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        backgroundColor: LiltColors.ink,
        foregroundColor: LiltColors.onPrimary,
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    ),
    cardTheme: CardThemeData(
      color: LiltColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(LiltRadius.card),
        side: const BorderSide(color: LiltColors.line),
      ),
    ),
  );
}
