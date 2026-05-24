import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class CurriculumBadge extends StatelessWidget {
  const CurriculumBadge({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.isActive,
    required this.activeColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final bool isActive;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMD,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: activeColor.withValues(alpha: AppDimensions.opacityFaint),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
        border: Border.all(
          color: activeColor.withValues(alpha: AppDimensions.opacitySubtle),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppDimensions.iconSM, color: iconColor),
          const SizedBox(width: AppDimensions.paddingXS),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: activeColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
