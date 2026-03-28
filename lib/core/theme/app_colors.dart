import 'package:flutter/material.dart';

/// Design tokens mapped from the original React CSS theme.
///
/// All colors follow Material Design 3 naming conventions
/// and correspond directly to the Tailwind CSS custom properties.
abstract final class AppColors {
  // Background & Surface
  static const Color background = Color(0xFFF7F9FF);
  static const Color surface = Color(0xFFF7F9FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF1F3F9);
  static const Color surfaceContainer = Color(0xFFECEEF3);
  static const Color surfaceContainerHigh = Color(0xFFE6E8EE);
  static const Color surfaceContainerHighest = Color(0xFFE0E2E8);

  // On-Surface
  static const Color onSurface = Color(0xFF181C20);
  static const Color onSurfaceVariant = Color(0xFF404750);

  // Primary
  static const Color primary = Color(0xFF00639A);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF5DA9E9);
  static const Color onPrimaryContainer = Color(0xFF003C61);
  static const Color primaryFixed = Color(0xFFCEE5FF);
  static const Color primaryFixedDim = Color(0xFF96CCFF);
  static const Color onPrimaryFixed = Color(0xFF001D32);
  static const Color onPrimaryFixedVariant = Color(0xFF004A76);

  // Secondary
  static const Color secondary = Color(0xFF056C42);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFF9DF5BF);
  static const Color onSecondaryContainer = Color(0xFF137348);
  static const Color secondaryFixed = Color(0xFF9DF5BF);
  static const Color secondaryFixedDim = Color(0xFF82D8A4);
  static const Color onSecondaryFixed = Color(0xFF002110);
  static const Color onSecondaryFixedVariant = Color(0xFF005230);

  // Tertiary
  static const Color tertiary = Color(0xFF655781);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFAC9CCA);
  static const Color onTertiaryContainer = Color(0xFF403359);
  static const Color tertiaryFixed = Color(0xFFEBDDFF);
  static const Color tertiaryFixedDim = Color(0xFFD0BFEE);
  static const Color onTertiaryFixed = Color(0xFF211439);
  static const Color onTertiaryFixedVariant = Color(0xFF4D4068);

  // Outline
  static const Color outline = Color(0xFF707881);
  static const Color outlineVariant = Color(0xFFC0C7D1);

  // Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Extra utility colors
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

  // Core utility colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);
}
