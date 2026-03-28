import 'package:flutter/material.dart';

import '../../core/core.dart';

/// Reusable pill-shaped info chip with solid background.
///
/// Replaces the repeated small chip / pill pattern used in dashboard
/// (e.g. "8 Units", "124 Formulas"), geometry progress badges,
/// and algebra section tags.
class AppInfoChip extends StatelessWidget {
  /// Text displayed inside the chip.
  final String label;

  /// Background colour of the chip.
  final Color backgroundColor;

  /// Text colour.
  final Color textColor;

  /// Text style override. Defaults to [AppTextStyles.bodySmall] w500.
  final TextStyle? textStyle;

  /// Horizontal padding.
  final double horizontalPadding;

  /// Vertical padding.
  final double verticalPadding;

  const AppInfoChip({
    super.key,
    required this.label,
    this.backgroundColor = AppColors.surfaceContainerHigh,
    this.textColor = AppColors.onSurface,
    this.textStyle,
    this.horizontalPadding = AppDimensions.paddingMD,
    this.verticalPadding = AppDimensions.paddingXS,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      child: Text(
        label,
        style: textStyle ??
            AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
      ),
    );
  }
}
