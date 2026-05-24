import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';

class HelpVersionCard extends StatelessWidget {
  const HelpVersionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
      ),
      child: Column(
        children: [
          Icon(LucideIcons.sparkles, size: AppDimensions.iconLG, color: colorScheme.primary),
          const SizedBox(height: AppDimensions.paddingSM),
          Text(AppStrings.appName, style: AppTextStyles.labelLarge.copyWith(color: colorScheme.onSurface)),
          const SizedBox(height: AppDimensions.paddingXXS),
          Text(AppStrings.appVersion, style: AppTextStyles.bodySmall.copyWith(color: colorScheme.outline)),
          const SizedBox(height: AppDimensions.paddingXXS),
          Text(AppStrings.madeWithLove, style: AppTextStyles.bodySmall.copyWith(color: colorScheme.outline)),
        ],
      ),
    );
  }
}
