import 'package:flutter/material.dart';

import '../../core/core.dart';

/// Gradient box decoration matching the React app's `.signature-glow`.
class SignatureGlowDecoration extends BoxDecoration {
  const SignatureGlowDecoration()
    : super(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryContainer],
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppDimensions.radiusLG),
        ),
      );
}

/// Ghost shadow matching the React app's `.ghost-shadow`.
BoxDecoration ghostShadowDecoration({
  Color color = AppColors.surfaceContainerLowest,
  double borderRadius = AppDimensions.radiusLG,
}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: const [AppShadows.ghost],
  );
}

/// Progress bar widget used across the app.
class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.percentage,
    this.barColor = AppColors.secondary,
    this.backgroundColor = AppColors.secondaryFixedDim,
    this.height = AppDimensions.progressBarDefault,
  });
  final double percentage;
  final Color barColor;
  final Color backgroundColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(height),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: (percentage / 100).clamp(0, 1),
        child: Container(
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(height),
          ),
        ),
      ),
    );
  }
}

/// Category chip/tag widget.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    this.backgroundColor = AppColors.primaryFixed,
    this.textColor = AppColors.onPrimaryFixed,
  });
  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMD,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.overline.copyWith(color: textColor),
      ),
    );
  }
}

/// Section header with optional action.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.headlineMedium),
        if (actionLabel != null)
          TextButton.icon(
            onPressed: onAction,
            icon: Text(
              actionLabel!,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
            label: const Icon(
              Icons.arrow_forward,
              size: AppDimensions.iconSM,
              color: AppColors.primary,
            ),
          ),
      ],
    );
  }
}
