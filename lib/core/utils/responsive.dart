import 'package:flutter/material.dart';

/// Device screen type classification for responsive layouts.
enum ScreenType { mobile, tablet, desktop, wideDesktop }

/// Responsive layout breakpoints and helpers.
///
/// Provides consistent screen classification and value-selection
/// across the app using [LayoutBuilder] or [MediaQuery].
abstract final class Responsive {
  // ─── Breakpoints ────────────────────────────────────────────
  static const double breakpointMobile = 600.0;
  static const double breakpointTablet = 900.0;
  static const double breakpointDesktop = 1024.0;
  static const double breakpointWideDesktop = 1440.0;
  static const double breakpointMaxContent = 1200.0;

  // ─── Screen Type ────────────────────────────────────────────
  static ScreenType screenType(double width) {
    if (width >= breakpointWideDesktop) return ScreenType.wideDesktop;
    if (width >= breakpointDesktop) return ScreenType.desktop;
    if (width >= breakpointTablet) return ScreenType.tablet;
    return ScreenType.mobile;
  }

  static bool isMobile(double width) => width < breakpointTablet;
  static bool isTablet(double width) =>
      width >= breakpointTablet && width < breakpointDesktop;
  static bool isDesktop(double width) => width >= breakpointDesktop;
  static bool isWideDesktop(double width) => width >= breakpointWideDesktop;

  // ─── Value Selection ────────────────────────────────────────
  static T value<T>({
    required BuildContext context,
    T? mobile,
    T? tablet,
    T? desktop,
    T? wideDesktop,
    T? fallback,
  }) {
    final width = MediaQuery.of(context).size.width;
    final type = screenType(width);
    switch (type) {
      case ScreenType.wideDesktop:
        return wideDesktop ?? desktop ?? tablet ?? mobile ?? fallback as T;
      case ScreenType.desktop:
        return desktop ?? tablet ?? mobile ?? fallback as T;
      case ScreenType.tablet:
        return tablet ?? mobile ?? fallback as T;
      case ScreenType.mobile:
        return mobile ?? fallback as T;
    }
  }

  // ─── Grid Layout ────────────────────────────────────────────
  static int gridColumns(double width, {required int mobile, int? tablet, int? desktop, int? wideDesktop}) {
    final type = screenType(width);
    return switch (type) {
      ScreenType.wideDesktop => wideDesktop ?? desktop ?? tablet ?? mobile,
      ScreenType.desktop => desktop ?? tablet ?? mobile,
      ScreenType.tablet => tablet ?? mobile,
      ScreenType.mobile => mobile,
    };
  }
}

/// BuildContext extension for convenient responsive lookups.
extension ResponsiveContext on BuildContext {
  ScreenType get screenType => Responsive.screenType(MediaQuery.of(this).size.width);
  bool get isMobile => Responsive.isMobile(MediaQuery.of(this).size.width);
  bool get isTablet => Responsive.isTablet(MediaQuery.of(this).size.width);
  bool get isDesktop => Responsive.isDesktop(MediaQuery.of(this).size.width);
  bool get isWideDesktop => Responsive.isWideDesktop(MediaQuery.of(this).size.width);
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}

/// A widget that constrains its child to a maximum content width
/// and centers it horizontally — useful for web layouts.
class ConstrainedContentWidth extends StatelessWidget {
  const ConstrainedContentWidth({
    super.key,
    required this.child,
    this.maxWidth = Responsive.breakpointMaxContent,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padding != null
            ? Padding(padding: padding!, child: child)
            : child,
      ),
    );
  }
}
