import 'package:flutter/material.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

import 'profile_insights_sheet.dart';

/// Progress stats grid – displays stat cards.
///
/// Matches the React `ProgressStats` component.
class ProgressStatsWidget extends StatelessWidget {
  const ProgressStatsWidget({
    super.key,
    required this.stats,
    this.displayName = '',
  });
  final List<ProfileStat> stats;
  final String displayName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        AppSectionTitle(
          title: context.l10n.myProgress,
          actionLabel: context.l10n.viewHistory,
          onAction: () {
            AppLogger.debug(
              'View History tapped',
              tag: AppLogTags.progressStatsWidget,
            );
            ProfileInsightsSheet.show(
              context,
              displayName: displayName,
              stats: stats,
            );
          },
        ),
        const SizedBox(height: AppDimensions.paddingLG),
        // Stats grid
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide =
                constraints.maxWidth > AppDimensions.breakpointMedium;
            if (isWide) {
              return Row(
                children: stats.asMap().entries.map((entry) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: entry.key > 0 ? AppDimensions.paddingMD : 0,
                      ),
                      child: _buildStatCard(context, entry.value, entry.key),
                    ),
                  );
                }).toList(),
              );
            }
            return Column(
              children: [
                Row(
                  children: [
                    if (stats.isNotEmpty)
                      Expanded(child: _buildStatCard(context, stats[0], 0)),
                    const SizedBox(width: AppDimensions.paddingMD),
                    if (stats.length > 1)
                      Expanded(child: _buildStatCard(context, stats[1], 1)),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                if (stats.length > 2)
                  Row(
                    children: [
                      Expanded(child: _buildStatCard(context, stats[2], 2)),
                    ],
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, ProfileStat stat, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconData = _getStatIcon(stat.iconName);
    final iconBgColor = _getIconBgColor(index);
    final iconColor = _getIconColor(index);
    final hasBorder = index == 1; // streak card has bottom border

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: hasBorder
            ? const Border(
                bottom: BorderSide(
                  color: AppColors.secondaryFixedDim,
                  width: AppDimensions.borderWidthThick,
                ),
              )
            : null,
        boxShadow: const [AppShadows.ghost],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconCircle(
            icon: iconData,
            backgroundColor: iconBgColor,
            iconColor: iconColor,
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          Text(
            stat.value,
            style: AppTextStyles.displayLarge.copyWith(
              fontSize: AppDimensions.fontSizeDisplay,
              fontWeight: FontWeight.w800,
              height: AppDimensions.lineHeightTight,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          AppText(
            _resolveStatLabel(context, stat.id, stat.label),
            style: AppTextStyles.labelSmall.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _resolveStatLabel(BuildContext context, String id, String fallback) {
    return switch (id) {
      'formulas' => context.l10n.formulasMastered,
      'streak' => context.l10n.daysStreak,
      'points' => context.l10n.totalPoints,
      _ => fallback,
    };
  }

  IconData _getStatIcon(String iconName) {
    switch (iconName) {
      case 'functions':
        return Icons.functions;
      case 'fire':
        return Icons.local_fire_department;
      case 'stars':
        return Icons.stars;
      default:
        return Icons.analytics;
    }
  }

  Color _getIconBgColor(int index) {
    switch (index) {
      case 0:
        return AppColors.primaryFixed;
      case 1:
        return AppColors.secondaryFixed;
      case 2:
        return AppColors.tertiaryFixed;
      default:
        return AppColors.primaryFixed;
    }
  }

  Color _getIconColor(int index) {
    switch (index) {
      case 0:
        return AppColors.primary;
      case 1:
        return AppColors.secondary;
      case 2:
        return AppColors.tertiary;
      default:
        return AppColors.primary;
    }
  }
}
