import 'package:flutter/material.dart';

import '../../../../core/core.dart';

/// Encouragement card – motivational message at the bottom.
///
/// Matches the React `EncouragementCard` component.
class EncouragementCardWidget extends StatelessWidget {
  const EncouragementCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        color: AppColors.tertiaryContainer.withValues(
          alpha: AppDimensions.opacitySubtle,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(
          color: AppColors.tertiaryContainer,
          width: AppDimensions.borderWidth,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: AppDimensions.avatarLG,
            height: AppDimensions.avatarLG,
            decoration: const BoxDecoration(
              color: AppColors.tertiaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.psychology_outlined,
              size: AppDimensions.iconLG,
              color: AppColors.onTertiaryContainer,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingLG),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.readyForMore,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.onTertiaryContainer,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXS),
                Text(
                  AppStrings.encouragementMessage,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onTertiaryContainer.withValues(
                      alpha: AppDimensions.opacityHigh,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
