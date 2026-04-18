import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/core.dart';

/// Reusable "Coming Soon" bottom sheet displayed when a feature is not yet
/// implemented.
///
/// Usage:
/// ```dart
/// ComingSoonSheet.show(context, featureName: 'Notifications');
/// ```
class ComingSoonSheet {
  ComingSoonSheet._();

  /// Shows a beautifully animated "Coming Soon" bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required String featureName,
    String? description,
    IconData icon = LucideIcons.rocket,
  }) {
    AppLogger.info(
      'Coming Soon shown for: $featureName',
      tag: AppLogTags.mainShellPage,
    );

    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (context) => _ComingSoonContent(
        featureName: featureName,
        description: description,
        icon: icon,
      ),
    );
  }
}

class _ComingSoonContent extends StatelessWidget {

  const _ComingSoonContent({
    required this.featureName,
    this.description,
    required this.icon,
  });
  final String featureName;
  final String? description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final desc =
        description ??
        "We're working hard to bring you $featureName. "
            'Stay tuned for updates!';

    return Container(
      margin: const EdgeInsets.all(AppDimensions.paddingLG),
      padding: const EdgeInsets.all(AppDimensions.paddingHero),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusShell),
        boxShadow: const [AppShadows.ghost],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: AppDimensions.switchWidth,
            height: AppDimensions.paddingXS,
            margin: const EdgeInsets.only(bottom: AppDimensions.paddingXXL),
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
            ),
          ),
          // Animated icon circle
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: AppDurations.animationSlow,
            curve: AppDurations.curveEaseOutBack,
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Container(
              width: AppDimensions.avatarProfile,
              height: AppDimensions.avatarProfile,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primaryFixed, AppColors.primaryFixedDim],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(
                      alpha: AppDimensions.opacitySubtle,
                    ),
                    blurRadius: AppDimensions.blurRadiusLG,
                    spreadRadius: AppDimensions.switchPadding,
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: AppDimensions.iconHero,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXXL),
          // "Coming Soon" badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.chipPaddingHorizontalLG,
              vertical: AppDimensions.chipPaddingVerticalLG,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryContainer],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            ),
            child: Text(
              AppStrings.comingSoon,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.white,
                letterSpacing: AppDimensions.letterSpacingWide,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          // Feature name
          Text(
            featureName,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          // Description
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingXL,
            ),
            child: Text(
              desc,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
                height: AppDimensions.lineHeightRelaxed,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXXL),
          // Feature chips
          Wrap(
            spacing: AppDimensions.paddingSM,
            runSpacing: AppDimensions.paddingSM,
            alignment: WrapAlignment.center,
            children: [
              _buildFeatureChip(LucideIcons.zap, AppStrings.comingSoonChip1),
              _buildFeatureChip(LucideIcons.bell, AppStrings.comingSoonChip2),
              _buildFeatureChip(
                LucideIcons.sparkles,
                AppStrings.comingSoonChip3,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingXXL),
          // Close button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingLG,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                ),
                textStyle: AppTextStyles.labelLarge,
              ),
              child: const Text(AppStrings.gotIt),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(IconData chipIcon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.chipPaddingHorizontal,
        vertical: AppDimensions.chipPaddingVertical,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(chipIcon, size: AppDimensions.iconSM, color: AppColors.primary),
          const SizedBox(width: AppDimensions.paddingXS),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
