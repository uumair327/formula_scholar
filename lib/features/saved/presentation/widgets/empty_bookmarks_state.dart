library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';

class EmptyBookmarksState extends StatelessWidget {
  const EmptyBookmarksState({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXL,
        vertical: AppDimensions.paddingSectionLG,
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
                  gradient: isDark
                      ? AppColors.darkPrimaryGradient
                      : AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  LucideIcons.bookmark,
                  size: AppDimensions.imageLG,
                  color: Colors.white,
                ),
              ),
              Positioned(
                bottom: -AppDimensions.positionOffsetSM,
                right: -AppDimensions.positionOffsetSM,
                child: Container(
                  width: AppDimensions.imageMD,
                  height: AppDimensions.imageMD,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    shape: BoxShape.circle,
                    boxShadow: const [AppShadows.medium],
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
              fontWeight: FontWeight.w800,
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
          AppGradientButton(
            label: AppStrings.browseLessons,
            icon: LucideIcons.compass,
            onPressed: () {
              StatefulNavigationShell.of(context).goBranch(1);
            },
          ),
        ],
      ),
    );
  }
}
