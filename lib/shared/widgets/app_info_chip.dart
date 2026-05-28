import 'package:flutter/material.dart';

import '../../core/core.dart';

/// Reusable pill-shaped info chip with solid background.
///
/// Replaces the repeated small chip / pill pattern used in dashboard
/// (e.g. "8 Units", "124 Formulas"), geometry progress badges,
/// and algebra section tags.
class AppInfoChip extends StatelessWidget {
  const AppInfoChip({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.horizontalPadding = AppDimensions.paddingMD,
    this.verticalPadding = AppDimensions.paddingXS,
  });

  /// Text displayed inside the chip.
  final String label;

  /// Background colour of the chip.
  final Color? backgroundColor;

  /// Text colour.
  final Color? textColor;

  /// Text style override. Defaults to [AppTextStyles.bodySmall] w500.
  final TextStyle? textStyle;

  /// Horizontal padding.
  final double horizontalPadding;

  /// Vertical padding.
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      child: AppText(
        label,
        style:
            textStyle ??
            AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
              color: textColor ?? colorScheme.onSurface,
            ),
        maxLines: 1,
        softWrap: false,
      ),
    );
  }
}
