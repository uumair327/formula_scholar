import 'package:flutter/material.dart';

/// Responsive breakpoints for the app.
///
/// Use these with [LayoutBuilder] or [MediaQuery] to adapt layouts
/// for small, medium, and large screens.
class ResponsiveBreakpoints {
  ResponsiveBreakpoints._();

  /// Devices narrower than this are considered "small" (<360dp).
  static const double small = 360;

  /// Devices wider than this are considered "large" (>=768dp, e.g. tablets).
  static const double large = 768;
}

/// Extension on [BuildContext] for responsive layout decisions.
extension ResponsiveContext on BuildContext {
  /// Whether the device width is considered small (<360dp).
  bool get isSmallScreen => MediaQuery.sizeOf(this).width < ResponsiveBreakpoints.small;

  /// Whether the device width is considered large (>=768dp, tablet).
  bool get isLargeScreen => MediaQuery.sizeOf(this).width >= ResponsiveBreakpoints.large;

  /// Whether the device width is medium (360dp – 768dp).
  bool get isMediumScreen => !isSmallScreen && !isLargeScreen;

  /// Returns a responsive value based on the screen width.
  ///
  /// Usage:
  /// ```dart
  /// final padding = context.responsive(small: 8, medium: 16, large: 24);
  /// ```
  T responsive<T>({
    required T small,
    T? medium,
    required T large,
  }) {
    if (isSmallScreen) return small;
    if (isLargeScreen) return large;
    return medium ?? small;
  }

  /// Returns side padding for the current screen size.
  double get horizontalPadding => responsive(small: 12.0, medium: 16.0, large: 24.0);
}
