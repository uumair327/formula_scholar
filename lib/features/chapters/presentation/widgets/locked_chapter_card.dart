import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';

class LockedChapterCard extends StatelessWidget {
  const LockedChapterCard({super.key, required this.chapter});

  final Chapter chapter;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer.withValues(alpha: AppDimensions.opacitySubtle),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(color: colorScheme.tertiaryContainer.withValues(alpha: AppDimensions.opacityLight)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(chapter.name, style: AppTextStyles.labelLarge.copyWith(color: colorScheme.tertiary)),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(chapter.subtitle, style: AppTextStyles.bodySmall.copyWith(
            color: colorScheme.onTertiaryContainer.withValues(alpha: AppDimensions.opacityHigh))),
          const SizedBox(height: AppDimensions.paddingMD),
          Row(
            children: [
              AppInfoChip(
                label: AppStrings.locked,
                backgroundColor: colorScheme.surface.withValues(alpha: AppDimensions.opacityMediumLight),
                textColor: AppColors.tertiary,
                textStyle: AppTextStyles.overline.copyWith(color: colorScheme.tertiary),
              ),
              const SizedBox(width: AppDimensions.paddingSM),
              Icon(LucideIcons.lock, size: AppDimensions.iconSM, color: colorScheme.tertiary),
            ],
          ),
        ],
      ),
    );
  }
}
