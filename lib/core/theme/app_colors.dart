import 'package:flutter/material.dart';

/// Design tokens mapped from the original React CSS theme.
///
/// All colors follow Material Design 3 naming conventions
/// and correspond directly to the Tailwind CSS custom properties.
///
/// Extended with gradient presets, glassmorphism tokens, and
/// semantic color aliases for premium UI treatment.
abstract final class AppColors {
  /// Returns light or dark color based on [context] brightness.
  static Color of(BuildContext context, Color light, Color dark) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;

  // ──────────────────────── Background & Surface ─────────────────
  static const Color background = Color(0xFFF7F9FF);
  static const Color surface = Color(0xFFF7F9FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF1F3F9);
  static const Color surfaceContainer = Color(0xFFECEEF3);
  static const Color surfaceContainerHigh = Color(0xFFE6E8EE);
  static const Color surfaceContainerHighest = Color(0xFFE0E2E8);

  // ──────────────────────── On-Surface ───────────────────────────
  static const Color onSurface = Color(0xFF181C20);
  static const Color onSurfaceVariant = Color(0xFF404750);

  // ──────────────────────── Primary ──────────────────────────────
  static const Color primary = Color(0xFF00639A);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF5DA9E9);
  static const Color onPrimaryContainer = Color(0xFF003C61);
  static const Color primaryFixed = Color(0xFFCEE5FF);
  static const Color primaryFixedDim = Color(0xFF96CCFF);
  static const Color onPrimaryFixed = Color(0xFF001D32);
  static const Color onPrimaryFixedVariant = Color(0xFF004A76);

  // ──────────────────────── Secondary ────────────────────────────
  static const Color secondary = Color(0xFF056C42);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFF9DF5BF);
  static const Color onSecondaryContainer = Color(0xFF137348);
  static const Color secondaryFixed = Color(0xFF9DF5BF);
  static const Color secondaryFixedDim = Color(0xFF82D8A4);
  static const Color onSecondaryFixed = Color(0xFF002110);
  static const Color onSecondaryFixedVariant = Color(0xFF005230);

  // ──────────────────────── Tertiary ─────────────────────────────
  static const Color tertiary = Color(0xFF655781);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFAC9CCA);
  static const Color onTertiaryContainer = Color(0xFF403359);
  static const Color tertiaryFixed = Color(0xFFEBDDFF);
  static const Color tertiaryFixedDim = Color(0xFFD0BFEE);
  static const Color onTertiaryFixed = Color(0xFF211439);
  static const Color onTertiaryFixedVariant = Color(0xFF4D4068);

  // ──────────────────────── Outline ──────────────────────────────
  static const Color outline = Color(0xFF707881);
  static const Color outlineVariant = Color(0xFFC0C7D1);

  // ──────────────────────── Error ────────────────────────────────
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // ──────────────────────── Extra utility colors ─────────────────
  static const Color blue50 = Color(0xFFEFF6FF);
  static const Color blue100 = Color(0xFFDBEAFE);
  static const Color blue600 = Color(0xFF2563EB);
  static const Color blue700 = Color(0xFF1D4ED8);
  static const Color blue900 = Color(0xFF1E3A5F);
  static const Color orange100 = Color(0xFFFFEDD5);
  static const Color orange400 = Color(0xFFFB923C);
  static const Color orange500 = Color(0xFFF97316);
  static const Color orange600 = Color(0xFFEA580C);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color green200 = Color(0xFFBBF7D0);
  static const Color blue200 = Color(0xFFBFDBFE);

  // ──────────────────────── Surface variants ─────────────────────
  static const Color surfaceDim = Color(0xFFD8DADF);
  static const Color surfaceBright = Color(0xFFF7F9FF);
  static const Color surfaceVariant = Color(0xFFE0E2E8);
  static const Color surfaceTint = Color(0xFF00639A);
  static const Color inverseSurface = Color(0xFF2D3135);
  static const Color inverseOnSurface = Color(0xFFEFF1F6);
  static const Color inversePrimary = Color(0xFF96CCFF);

  // ──────────────────────── Dark mode variants ───────────────────
  static const Color darkSurface = Color(0xFF0F1419);
  static const Color darkOnSurface = Color(0xFFE2E3E8);
  static const Color darkSurfaceContainerLowest = Color(0xFF161B22);
  static const Color darkSurfaceContainerLow = Color(0xFF1C2128);
  static const Color darkSurfaceContainer = Color(0xFF22272E);
  static const Color darkSurfaceContainerHigh = Color(0xFF2D333B);
  static const Color darkSurfaceContainerHighest = Color(0xFF373E47);
  static const Color darkOnSurfaceVariant = Color(0xFFC2C7CF);
  static const Color darkPrimary = Color(0xFF96CCFF);
  static const Color darkOnPrimary = Color(0xFF003353);
  static const Color darkPrimaryContainer = Color(0xFF004B77);
  static const Color darkOnPrimaryContainer = Color(0xFFD1E4FF);
  static const Color darkSecondary = Color(0xFF82D8A4);
  static const Color darkOnSecondary = Color(0xFF003921);
  static const Color darkSecondaryContainer = Color(0xFF00522F);
  static const Color darkOnSecondaryContainer = Color(0xFF9EF5C0);
  static const Color darkTertiary = Color(0xFFD0BFEE);
  static const Color darkOnTertiary = Color(0xFF36284E);
  static const Color darkTertiaryContainer = Color(0xFF4D3F65);
  static const Color darkOnTertiaryContainer = Color(0xFFECDCFF);
  static const Color darkError = Color(0xFFFFB4AB);
  static const Color darkOnError = Color(0xFF690005);
  static const Color darkOutline = Color(0xFF8C929C);

  // ──────────────────────── Core utility ─────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);

  // ═══════════════════════════════════════════════════════════════
  // PREMIUM DESIGN EXTENSIONS
  // ═══════════════════════════════════════════════════════════════

  // ──────────────────────── Semantic Colors ──────────────────────
  static const Color successGreen = Color(0xFF10B981);
  static const Color successGreenLight = Color(0xFFD1FAE5);
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color warningAmberLight = Color(0xFFFEF3C7);
  static const Color infoBlue = Color(0xFF3B82F6);
  static const Color infoBlueLight = Color(0xFFDBEAFE);

  // ──────────────────────── Glassmorphism ────────────────────────
  /// Light mode glass surface.
  static const Color glassLight = Color(0xCCFFFFFF); // ~80% white
  /// Dark mode glass surface.
  static const Color glassDark = Color(0xB30F1419); // ~70% dark
  /// Glass border — subtle white line.
  static const Color glassBorderLight = Color(0x33FFFFFF); // ~20% white
  static const Color glassBorderDark = Color(0x1AFFFFFF); // ~10% white

  /// Returns glass surface color based on brightness.
  static Color glass(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? glassDark : glassLight;

  /// Returns glass border color based on brightness.
  static Color glassBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? glassBorderDark
      : glassBorderLight;

  // ──────────────────────── Gradient Presets ─────────────────────
  /// Primary gradient — hero cards, CTAs.
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0077B6), Color(0xFF00B4D8)],
  );

  /// Hero gradient — onboarding, splash, large hero sections.
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF003C61), Color(0xFF00639A), Color(0xFF5DA9E9)],
  );

  /// Accent gradient — secondary actions, badges.
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF056C42), Color(0xFF10B981)],
  );

  /// Error gradient — destructive actions, delete buttons.
  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFBA1A1A), Color(0xFFFF5449)],
  );

  /// Card shimmer gradient — subtle premium shine on cards.
  static const LinearGradient cardShimmer = LinearGradient(
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    colors: [Color(0x00FFFFFF), Color(0x0DFFFFFF), Color(0x00FFFFFF)],
  );

  /// Dark mode primary gradient — adjusted for dark surfaces.
  static const LinearGradient darkPrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF004B77), Color(0xFF0077B6)],
  );

  /// Dark mode hero gradient.
  static const LinearGradient darkHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF001D32), Color(0xFF003C61), Color(0xFF004B77)],
  );

  /// Dark mode error gradient.
  static const LinearGradient darkErrorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF690005), Color(0xFFBA1A1A)],
  );

  /// Returns the primary gradient for the current brightness.
  static LinearGradient primaryGradientOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkPrimaryGradient
      : primaryGradient;

  /// Returns the hero gradient for the current brightness.
  static LinearGradient heroGradientOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkHeroGradient
      : heroGradient;

  /// Returns the error gradient for the current brightness.
  static LinearGradient errorGradientOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkErrorGradient
      : errorGradient;
}
