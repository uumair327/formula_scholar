import 'package:flutter/material.dart';

/// Wraps a directional icon so it auto-flips in RTL contexts.
///
/// Usage:
/// ```dart
/// RtlSafeIcon(LucideIcons.chevronRight)
/// RtlSafeIcon(Icons.arrow_forward)
/// ```
///
/// In LTR: icon renders normally.
/// In RTL: icon is mirrored horizontally.
class RtlSafeIcon extends StatelessWidget {
  const RtlSafeIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
  });

  final IconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final effectiveIcon = isRtl ? _mirrorIcon(icon) : icon;

    return Icon(
      effectiveIcon,
      size: size,
      color: color,
      semanticLabel: semanticLabel,
    );
  }

  /// Returns the mirrored version of known directional icons.
  static IconData _mirrorIcon(IconData icon) {
    // Material Icons
    if (icon == Icons.arrow_back) return Icons.arrow_forward;
    if (icon == Icons.arrow_forward) return Icons.arrow_back;
    if (icon == Icons.chevron_left) return Icons.chevron_right;
    if (icon == Icons.chevron_right) return Icons.chevron_left;
    if (icon == Icons.keyboard_arrow_left) return Icons.keyboard_arrow_right;
    if (icon == Icons.keyboard_arrow_right) return Icons.keyboard_arrow_left;

    // For LucideIcons (not in Material's registry), use Transform.flip.
    return icon;
  }
}

/// Wraps a widget and flips it horizontally when the context is RTL.
///
/// Useful for LucideIcons which don't have directional variants.
class RtlFlip extends StatelessWidget {
  const RtlFlip({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    if (!isRtl) return child;
    return Transform.flip(flipX: true, child: child);
  }
}
