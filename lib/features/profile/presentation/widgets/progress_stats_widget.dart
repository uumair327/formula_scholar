import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

import 'profile_insights_sheet.dart';

/// Progress stats grid – displays stat cards.
///
/// Follows premium design system with uniform card borders,
/// harmonious translucent accents, and responsive layout.
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
          onAction: () => _openInsights(context),
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
                if (stats.length > 2) ...[
                  const SizedBox(height: AppDimensions.paddingMD),
                  Row(
                    children: [
                      Expanded(child: _buildStatCard(context, stats[2], 2)),
                    ],
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  void _openInsights(BuildContext context) {
    AppLogger.debug(
      'View History tapped',
      tag: AppLogTags.progressStatsWidget,
    );
    ProfileInsightsSheet.show(
      context,
      displayName: displayName,
      stats: stats,
    );
  }

  Widget _buildStatCard(BuildContext context, ProfileStat stat, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconData = _getStatIcon(stat.iconName);
    final accentColor = _getAccentColor(index);

    return AppCard(
      boxShadow: const [AppShadows.subtle],
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      border: Border.all(
        color: colorScheme.outlineVariant.withValues(
          alpha: AppDimensions.opacityFaint,
        ),
      ),
      onTap: () => _openInsights(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIconCircle(
            icon: iconData,
            backgroundColor: accentColor.withValues(
              alpha: AppDimensions.opacityFaint,
            ),
            iconColor: accentColor,
            size: AppDimensions.avatarMD,
            iconSize: AppDimensions.iconDefault,
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          Text(
            stat.value,
            style: AppTextStyles.displayLarge.copyWith(
              fontSize: AppDimensions.fontSizeDisplay,
              fontWeight: FontWeight.w800,
              height: AppDimensions.lineHeightTight,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXXS),
          Text(
            _resolveStatLabel(context, stat.id, stat.label),
            style: AppTextStyles.labelSmall.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
        return LucideIcons.functionSquare;
      case 'fire':
        return LucideIcons.flame;
      case 'stars':
        return LucideIcons.sparkles;
      default:
        return LucideIcons.barChart3;
    }
  }

  Color _getAccentColor(int index) {
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
