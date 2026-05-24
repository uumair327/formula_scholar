import 'package:flutter/material.dart';

import '../../../core/core.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMD,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.primaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: AppDimensions.iconXS,
              color: textColor ?? colorScheme.primary,
            ),
            const SizedBox(width: AppDimensions.paddingXXS),
          ],
          Text(
            label.toUpperCase(),
            style: AppTextStyles.overline.copyWith(
              color: textColor ?? colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
