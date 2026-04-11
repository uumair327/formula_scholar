import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';

/// Bookmarks page – displays saved/bookmarked formulas and chapters.
///
/// Accessible from profile settings. Shows a polished empty state
/// when no bookmarks exist with actions to browse content.
class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingXL,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppDimensions.paddingXXL),
                // Bookmark categories
                const AppSectionTitle(title: AppStrings.bookmarkCategories),
                const SizedBox(height: AppDimensions.paddingLG),
                _buildCategoryCard(
                  icon: LucideIcons.sigma,
                  title: AppStrings.savedFormulas,
                  count: '23',
                  color: AppColors.primary,
                  bgColor: AppColors.primaryFixed,
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                _buildCategoryCard(
                  icon: LucideIcons.bookOpen,
                  title: AppStrings.savedChapters,
                  count: '8',
                  color: AppColors.secondary,
                  bgColor: AppColors.secondaryFixed,
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                _buildCategoryCard(
                  icon: LucideIcons.fileText,
                  title: AppStrings.savedNotes,
                  count: '15',
                  color: AppColors.tertiary,
                  bgColor: AppColors.tertiaryFixed,
                ),
                const SizedBox(height: AppDimensions.paddingXXL),
                // Recent bookmarks
                const AppSectionTitle(title: AppStrings.recentBookmarks),
                const SizedBox(height: AppDimensions.paddingLG),
                _buildBookmarkItem(
                  title: AppStrings.pythagoreanTheorem,
                  subtitle: AppStrings.mathematics,
                  icon: LucideIcons.triangle,
                  time: AppStrings.twoHoursAgo,
                  color: AppColors.primary,
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                _buildBookmarkItem(
                  title: AppStrings.newtonsThirdLaw,
                  subtitle: AppStrings.physics,
                  icon: LucideIcons.zap,
                  time: AppStrings.yesterday,
                  color: AppColors.secondary,
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                _buildBookmarkItem(
                  title: AppStrings.atomsAndMolecules,
                  subtitle: AppStrings.chemistry,
                  icon: LucideIcons.atom,
                  time: AppStrings.yesterday,
                  color: AppColors.tertiary,
                ),
                const SizedBox(height: AppDimensions.paddingXXL),
                // Info card
                _buildInfoCard(),
                const SizedBox(height: AppDimensions.bottomNavPadding),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppColors.surfaceContainerLowest.withValues(
        alpha: AppDimensions.opacityAppBar,
      ),
      surfaceTintColor: AppColors.transparent,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(LucideIcons.arrowLeft, color: AppColors.onSurface),
      ),
      title: Text(
        AppStrings.myBookmarks,
        style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () => ComingSoonSheet.show(
            context,
            featureName: AppStrings.searchBookmarks,
          ),
          icon: const Icon(LucideIcons.search, color: AppColors.primary),
        ),
        const SizedBox(width: AppDimensions.paddingSM),
      ],
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required String title,
    required String count,
    required Color color,
    required Color bgColor,
  }) {
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXL,
        vertical: AppDimensions.paddingLG,
      ),
      child: Row(
        children: [
          Container(
            width: AppDimensions.avatarLG,
            height: AppDimensions.avatarLG,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            ),
            child: Icon(icon, size: AppDimensions.iconLG, color: color),
          ),
          const SizedBox(width: AppDimensions.paddingLG),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelLarge),
                const SizedBox(height: AppDimensions.paddingXXS),
                Text(
                  '$count items',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.chipPaddingHorizontal,
              vertical: AppDimensions.chipPaddingVertical,
            ),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            ),
            child: Text(
              count,
              style: AppTextStyles.labelLarge.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required String time,
    required Color color,
  }) {
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXL,
        vertical: AppDimensions.paddingLG,
      ),
      child: Row(
        children: [
          AppIconCircle(
            icon: icon,
            backgroundColor: color.withValues(
              alpha: AppDimensions.opacityFaint,
            ),
            iconColor: color,
          ),
          const SizedBox(width: AppDimensions.paddingLG),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelLarge),
                const SizedBox(height: AppDimensions.paddingXXS),
                Row(
                  children: [
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingSM),
                    Container(
                      width: AppDimensions.paddingXXS,
                      height: AppDimensions.paddingXXS,
                      decoration: BoxDecoration(
                        color: AppColors.outlineVariant,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingSM),
                    Text(
                      time,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(LucideIcons.bookmark, size: AppDimensions.iconMD, color: color),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        color: AppColors.primaryFixed.withValues(
          alpha: AppDimensions.opacityLight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(
          color: AppColors.primaryFixed,
          width: AppDimensions.borderWidth,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: AppDimensions.avatarLG,
            height: AppDimensions.avatarLG,
            decoration: const BoxDecoration(
              color: AppColors.primaryFixed,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.lightbulb,
              size: AppDimensions.iconLG,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingLG),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.proTip,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.onPrimaryFixed,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXS),
                Text(
                  AppStrings.proTipContent,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onPrimaryFixed.withValues(
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
