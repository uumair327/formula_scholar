import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_dimensions.dart';

/// Typography system using Plus Jakarta Sans,
/// matching the original React app's font styles.
abstract final class AppTextStyles {
  static TextStyle get _baseStyle => GoogleFonts.plusJakartaSans();

  // Display
  static TextStyle get displayLarge => _baseStyle.copyWith(
    fontSize: AppDimensions.fontSizeDisplayLG,
    fontWeight: FontWeight.w800,
    letterSpacing: AppDimensions.letterSpacingTight,
    height: AppDimensions.lineHeightCompact,
  );

  // Headlines
  static TextStyle get headlineLarge => _baseStyle.copyWith(
    fontSize: AppDimensions.fontSizeDisplay,
    fontWeight: FontWeight.w800,
    letterSpacing: AppDimensions.letterSpacingMediumTight,
  );

  static TextStyle get headlineMedium => _baseStyle.copyWith(
    fontSize: AppDimensions.fontSizeHeadline,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get headlineSmall => _baseStyle.copyWith(
    fontSize: AppDimensions.fontSizeXXL,
    fontWeight: FontWeight.w800,
    letterSpacing: AppDimensions.letterSpacingSlightTight,
  );

  // Titles
  static TextStyle get titleLarge => _baseStyle.copyWith(
    fontSize: AppDimensions.fontSizeXL,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get titleMedium => _baseStyle.copyWith(
    fontSize: AppDimensions.fontSizeLG,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get titleSmall => _baseStyle.copyWith(
    fontSize: AppDimensions.fontSizeMD,
    fontWeight: FontWeight.w600,
  );

  // Body
  static TextStyle get bodyLarge => _baseStyle.copyWith(
    fontSize: AppDimensions.fontSizeLG,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get bodyMedium => _baseStyle.copyWith(
    fontSize: AppDimensions.fontSizeMD,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get bodySmall => _baseStyle.copyWith(
    fontSize: AppDimensions.fontSizeSM,
    fontWeight: FontWeight.w400,
  );

  // Labels
  static TextStyle get labelLarge => _baseStyle.copyWith(
    fontSize: AppDimensions.fontSizeMD,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get labelMedium => _baseStyle.copyWith(
    fontSize: AppDimensions.fontSizeSM,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get labelSmall => _baseStyle.copyWith(
    fontSize: AppDimensions.fontSizeXS,
    fontWeight: FontWeight.w700,
    letterSpacing: AppDimensions.letterSpacingWide,
  );

  // Overline / Tag
  static TextStyle get overline => _baseStyle.copyWith(
    fontSize: AppDimensions.fontSizeXS,
    fontWeight: FontWeight.w700,
    letterSpacing: AppDimensions.letterSpacingWide,
  );
}
