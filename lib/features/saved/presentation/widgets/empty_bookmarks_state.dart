library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

class EmptyBookmarksState extends StatelessWidget {
  const EmptyBookmarksState({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingSectionLG),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: AppDimensions.imageXL,
                height: AppDimensions.imageXL,
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.bookmark,
                  size: AppDimensions.imageLG,
                  color: colorScheme.onTertiaryContainer,
                ),
              ),
              Positioned(
                bottom: AppDimensions.positionOffsetSM,
                right: AppDimensions.positionOffsetSM,
                child: Container(
                  width: AppDimensions.imageMD,
                  height: AppDimensions.imageMD,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLowest,
                    shape: BoxShape.circle,
                    boxShadow: const [AppShadows.ghost],
                  ),
                  child: Icon(
                    LucideIcons.plus,
                    size: AppDimensions.iconLG,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingXXL),
          Text(
            AppStrings.nothingHereYet,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          Text(
            AppStrings.emptyBookmarksDesc,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXXL),
          ElevatedButton.icon(
            onPressed: () {
              StatefulNavigationShell.of(context).goBranch(1);
            },
            icon: const Icon(LucideIcons.compass),
            label: const Text(AppStrings.browseLessons),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.secondaryContainer,
              foregroundColor: colorScheme.onSecondaryContainer,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingXXL,
                vertical: AppDimensions.paddingMD,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
              ),
              elevation: AppDimensions.elevationNone,
            ),
          ),
        ],
      ),
    );
  }
}
