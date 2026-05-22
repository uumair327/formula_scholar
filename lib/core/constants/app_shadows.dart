import 'package:flutter/material.dart';

import 'app_dimensions.dart';

/// Centralized box shadow presets used across the application.
///
/// Eliminates the duplication of identical `BoxShadow` declarations
/// that appear in multiple widget files. Extended with premium
/// variants for hover, elevation, and dark mode.
abstract final class AppShadows {
  // ──────────────────────── Light Mode ────────────────────────────

  /// Very subtle shadow for small elevation – cards, chips.
  static const BoxShadow subtle = BoxShadow(
    color: Color(0x08000000),
    blurRadius: AppDimensions.blurRadiusSM,
    offset: Offset(0, AppDimensions.shadowOffsetSM),
  );

  /// Soft shadow — minimal depth for flat surfaces.
  static const BoxShadow soft = BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 12.0,
    offset: Offset(0, 2.0),
    spreadRadius: -2.0,
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

  // ──────────────────────── Premium Additions ────────────────────

  /// Elevated shadow — FABs, modals, dropdown menus.
  static const BoxShadow elevated = BoxShadow(
    color: Color(0x20000000),
    blurRadius: 32.0,
    offset: Offset(0, 12.0),
    spreadRadius: -8.0,
  );

  /// Card hover state — slight lift with wider spread.
  static const BoxShadow cardHover = BoxShadow(
    color: Color(0x18000000),
    blurRadius: 28.0,
    offset: Offset(0, 10.0),
    spreadRadius: -4.0,
  );

  /// Card pressed / active state — compressed shadow.
  static const BoxShadow cardPressed = BoxShadow(
    color: Color(0x0D000000),
    blurRadius: 8.0,
    offset: Offset(0, 2.0),
    spreadRadius: -2.0,
  );

  /// Glow shadow — coloured glow for accent elements.
  static BoxShadow glow(Color color) => BoxShadow(
        color: color.withValues(alpha: 0.3),
        blurRadius: 20.0,
        offset: const Offset(0, 4.0),
        spreadRadius: -4.0,
      );

  /// Inner shadow — for inset/pressed effects (simulated).
  static const BoxShadow inner = BoxShadow(
    color: Color(0x10000000),
    blurRadius: 6.0,
    offset: Offset(0, 2.0),
    spreadRadius: -1.0,
  );

  // ──────────────────────── Dark Mode Shadows ────────────────────

  /// Dark mode ghost shadow — darker with less spread.
  static const BoxShadow darkGhost = BoxShadow(
    color: Color(0x40000000),
    blurRadius: 20.0,
    offset: Offset(0, 6.0),
    spreadRadius: -6.0,
  );

  /// Dark mode elevated shadow.
  static const BoxShadow darkElevated = BoxShadow(
    color: Color(0x60000000),
    blurRadius: 32.0,
    offset: Offset(0, 12.0),
    spreadRadius: -8.0,
  );

  /// Dark mode bottom nav.
  static const BoxShadow darkBottomNav = BoxShadow(
    color: Color(0x50000000),
    blurRadius: 20.0,
    offset: Offset(0, -4.0),
  );

  /// Returns the appropriate ghost shadow for the current theme.
  static BoxShadow ghostOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkGhost : ghost;

  /// Returns the appropriate elevated shadow for the current theme.
  static BoxShadow elevatedOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkElevated
          : elevated;

  /// Returns the appropriate bottom nav shadow for the current theme.
  static BoxShadow bottomNavOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? darkBottomNav
          : bottomNav;
}
