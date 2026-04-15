import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';

/// Bottom sheet that surfaces backend-fed profile stats and next actions.
class ProfileInsightsSheet extends StatelessWidget {
  final String displayName;
  final List<ProfileStat> stats;

  const ProfileInsightsSheet({
    super.key,
    required this.displayName,
    required this.stats,
  });

  static void show(
    BuildContext context, {
    required String displayName,
    required List<ProfileStat> stats,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) =>
          ProfileInsightsSheet(displayName: displayName, stats: stats),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusXXL),
          topRight: Radius.circular(AppDimensions.radiusXXL),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXXL,
            vertical: AppDimensions.paddingLG,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: AppDimensions.avatarMD,
                  height: AppDimensions.borderWidthThick,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusXXL,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              Row(
                children: [
                  AppIconCircle(
                    icon: LucideIcons.barChart3,
                    size: AppDimensions.avatarHero,
                    backgroundColor: AppColors.primaryFixed,
                    iconColor: AppColors.primary,
                    iconSize: AppDimensions.iconXL,
                  ),
                  const SizedBox(width: AppDimensions.paddingLG),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.profileInsightsTitle,
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingXXS),
                        Text(
                          '${AppStrings.profileInsightsSubtitle} for $displayName',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              Text(
                AppStrings.profileInsightsSource,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: AppDimensions.letterSpacingWide,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              if (stats.isEmpty)
                AppCard(
                  color: AppColors.surfaceContainerHighest.withValues(
                    alpha: AppDimensions.opacityLight,
                  ),
                  child: Text(
                    'Your profile stats will appear here once your backend sync completes.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                )
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount =
                        constraints.maxWidth > AppDimensions.breakpointMedium
                        ? 2
                        : 1;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: AppDimensions.paddingMD,
                        crossAxisSpacing: AppDimensions.paddingMD,
                        childAspectRatio: crossAxisCount == 1 ? 4.5 : 2.6,
                      ),
                      itemCount: stats.length,
                      itemBuilder: (context, index) {
                        return _buildStatCard(stats[index]);
                      },
                    );
                  },
                ),
              const SizedBox(height: AppDimensions.paddingXXL),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final router = GoRouter.of(context);
                        Navigator.of(context).pop();
                        router.go(AppRoutes.practicePath);
                      },
                      icon: const Icon(
                        LucideIcons.playCircle,
                        size: AppDimensions.iconSM,
                      ),
                      label: const Text(AppStrings.continuePracticing),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingMD),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final router = GoRouter.of(context);
                        Navigator.of(context).pop();
                        router.go(AppRoutes.chaptersPath);
                      },
                      icon: const Icon(
                        LucideIcons.bookOpen,
                        size: AppDimensions.iconSM,
                      ),
                      label: const Text(AppStrings.browseChapters),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingMD),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(ProfileStat stat) {
    return AppCard(
      color: AppColors.surfaceContainerHighest.withValues(
        alpha: AppDimensions.opacityLight,
      ),
      border: Border.all(color: AppColors.surfaceContainerHigh),
      child: Row(
        children: [
          AppIconCircle(
            icon: _resolveIcon(stat.iconName),
            backgroundColor: AppColors.surfaceContainerHigh,
            iconColor: AppColors.primary,
          ),
          const SizedBox(width: AppDimensions.paddingLG),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stat.value,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXS),
                Text(
                  stat.label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _resolveIcon(String iconName) {
    return switch (iconName) {
      'functions' => LucideIcons.functionSquare,
      'fire' => LucideIcons.flame,
      'stars' => LucideIcons.sparkles,
      _ => LucideIcons.barChart3,
    };
  }
}
