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

    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(AppDimensions.paddingLG),
      padding: const EdgeInsets.all(AppDimensions.paddingHero),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
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
              color: colorScheme.outlineVariant,
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
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primaryFixed,
                    colorScheme.primaryFixedDim,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(
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
                color: colorScheme.primary,
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
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.primaryContainer],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            ),
            child: Text(
              context.l10n.comingSoon,
              style: AppTextStyles.labelSmall.copyWith(
                color: colorScheme.onPrimary,
                letterSpacing: AppDimensions.letterSpacingWide,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          // Feature name
          Text(
            featureName,
            style: AppTextStyles.headlineSmall.copyWith(
              color: colorScheme.onSurface,
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
                color: colorScheme.onSurfaceVariant,
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
              _buildFeatureChip(
                colorScheme,
                LucideIcons.zap,
                context.l10n.comingSoonChip1,
              ),
              _buildFeatureChip(
                colorScheme,
                LucideIcons.bell,
                context.l10n.comingSoonChip2,
              ),
              _buildFeatureChip(
                colorScheme,
                LucideIcons.sparkles,
                context.l10n.comingSoonChip3,
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
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingLG,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                ),
                textStyle: AppTextStyles.labelLarge,
              ),
              child: Text(context.l10n.gotIt),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(
    ColorScheme colorScheme,
    IconData chipIcon,
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.chipPaddingHorizontal,
        vertical: AppDimensions.chipPaddingVertical,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            chipIcon,
            size: AppDimensions.iconSM,
            color: colorScheme.primary,
          ),
          const SizedBox(width: AppDimensions.paddingXS),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
