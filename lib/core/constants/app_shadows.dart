import 'package:flutter/material.dart';

import 'app_dimensions.dart';

/// Centralized box shadow presets used across the application.
///
/// Eliminates the duplication of identical `BoxShadow` declarations
/// that appear in multiple widget files.
abstract final class AppShadows {
  /// Very subtle shadow for small elevation – cards, chips.
  static const BoxShadow subtle = BoxShadow(
    color: Color(0x08000000),
    blurRadius: AppDimensions.blurRadiusSM,
    offset: Offset(0, AppDimensions.shadowOffsetSM),
  );

  /// Ghost shadow used on surface cards – the primary content shadow.
  static const BoxShadow ghost = BoxShadow(
    color: Color(0x0F181C20),
    blurRadius: AppDimensions.blurRadiusLG,
    offset: Offset(0, AppDimensions.shadowOffsetLG),
    spreadRadius: AppDimensions.spreadRadiusSM,
  );

  /// Bottom nav bar shadow (inverted direction).
  static const BoxShadow bottomNav = BoxShadow(
    color: Color(0x0F000000),
    blurRadius: AppDimensions.blurRadiusLG,
    offset: Offset(0, -AppDimensions.shadowOffsetMD),
  );

  /// Medium shadow for floating action elements.
  static const BoxShadow medium = BoxShadow(
    color: Color(0x30000000),
    blurRadius: AppDimensions.blurRadiusMD,
    offset: Offset(0, AppDimensions.shadowOffsetMD),
  );

  /// Active chip / pressed element shadow.
  static const BoxShadow chip = BoxShadow(
    color: Color(0x18000000),
    blurRadius: AppDimensions.blurRadiusSM,
    offset: Offset(0, AppDimensions.shadowOffsetSM),
  );

  /// Switch thumb shadow.
  static const BoxShadow switchThumb = BoxShadow(
    color: Color(0x18000000),
    blurRadius: AppDimensions.blurRadiusXS,
    offset: Offset(0, AppDimensions.shadowOffsetXS),
  );
}
