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
  static const sheetLine = Color(0xFFE1E3E0);

  /// Commit grid levels (EQ-002); a paused day is drawn like level 0 (ADR-012).
  static const grid0 = Color(0xFFE5E7EF);
  static const grid1 = Color(0xFFB5BCFF);
  static const grid2 = Color(0xFF6C78FF);
  static const grid3 = Color(0xFF2F3BFF);
  static const gridPause = Color(0xFFE1E3E0);

  /// The three equalizer bars of the logo mark, in order: peak, dip, comeback.
  static const eqPeak = Color(0xFF2F3BFF);
  static const eqDip = Color(0xFF6C78FF);
  static const eqComeback = Color(0xFFFF7A1A);

  /// The 32% black behind a sheet (docs/DESIGN.md, Sheets).
  static const scrim = Color(0x52000000);
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
  static const sm = 8.0;
  static const md = 12.0;
  static const thumb = 16.0;
  static const card = 20.0;
  static const sheet = 28.0;
  static const pill = 9999.0;
}

/// Type styles from docs/DESIGN.md (frontmatter). Sizes are logical pixels, so the system text scale applies.
abstract final class LiltText {
  /// Screen titles and the "Welcome back" heading only. Instrument Serif has an italic and nothing else.
  static const display = TextStyle(
    fontFamily: 'Instrument Serif',
    fontStyle: FontStyle.italic,
    fontSize: 34,
    fontWeight: FontWeight.w400,
    height: 1.18,
    color: LiltColors.ink,
  );

  /// Milestone and achievement titles, and big numbers.
  static const celebration = TextStyle(
    fontFamily: 'Unbounded',
    fontSize: 20,
    fontVariations: [FontVariation('wght', 600)],
    height: 1.3,
    color: LiltColors.ink,
  );

  /// Options, reasons and reflections.
  static const body = TextStyle(
    fontFamily: 'Geist',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: LiltColors.ink,
  );

  /// Chips, tabs and the grid legend.
  static const label = TextStyle(
    fontFamily: 'Geist',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    color: LiltColors.ink,
  );

  /// A button label: semibold body size.
  static const button = TextStyle(
    fontFamily: 'Geist',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );
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
    fontFamily: 'Geist',
    colorScheme: scheme,
    scaffoldBackgroundColor: LiltColors.canvas,
    textTheme: Typography.blackMountainView
        .apply(fontFamily: 'Geist', bodyColor: LiltColors.ink, displayColor: LiltColors.ink)
        .copyWith(
          headlineMedium: LiltText.display,
          titleLarge: LiltText.celebration,
          bodyLarge: LiltText.body,
          labelLarge: LiltText.label,
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
