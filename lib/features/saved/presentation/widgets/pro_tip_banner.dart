library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

class ProTipBanner extends StatelessWidget {
  const ProTipBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer.withValues(
          alpha: AppDimensions.opacitySubtle,
        ),
        border: Border.all(
          color: colorScheme.tertiaryContainer.withValues(
            alpha: AppDimensions.opacityLight,
          ),
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            LucideIcons.lightbulb,
            size: AppDimensions.iconLG,
            color: colorScheme.onTertiaryContainer,
          ),
          const SizedBox(width: AppDimensions.paddingLG),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.proTip,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onTertiaryContainer,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimensions.paddingXS),
                Text(
                  AppStrings.proTipContent,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onTertiaryContainer,
                    height: AppDimensions.lineHeightDefault,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMD),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
