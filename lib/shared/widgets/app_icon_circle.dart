import 'package:flutter/material.dart';

import '../../core/core.dart';

/// Reusable circular icon container used across features.
///
/// Replaces the repeated Container(width, height, BoxDecoration(circle))
/// + Icon pattern found in settings list, progress stats, dashboard subject
/// cards, and profile widgets — over 10 instances.
class AppIconCircle extends StatelessWidget {
  const AppIconCircle({
    super.key,
    required this.icon,
    this.size = AppDimensions.avatarMD,
    this.backgroundColor,
    this.iconColor,
    this.iconSize = AppDimensions.iconDefault,
    this.borderRadius,
    this.boxShadow,
  });

  /// The icon to display.
  final IconData icon;

  /// Circle diameter.
  final double size;

  /// Background colour of the circle.
  final Color? backgroundColor;

  /// Icon colour.
  final Color? iconColor;

  /// Icon size. Defaults to [AppDimensions.iconDefault].
  final double iconSize;

  /// Optional border radius override (uses circle by default).
  /// Supply a value to get a rounded-square instead of circle.
  final double? borderRadius;

  /// Optional box shadow.
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.primaryContainer,
        shape: borderRadius != null ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: borderRadius != null
            ? BorderRadius.circular(borderRadius!)
            : null,
        boxShadow: boxShadow,
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor ?? colorScheme.primary,
      ),
    );
  }
}
