import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';

/// Progress stats grid – displays stat cards.
///
/// Matches the React `ProgressStats` component.
class ProgressStatsWidget extends StatelessWidget {
  final List<ProfileStat> stats;

  const ProgressStatsWidget({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        AppSectionTitle(
          title: AppStrings.myProgress,
          actionLabel: AppStrings.viewHistory,
          onAction: () {
            AppLogger.debug(
              'View History tapped',
              tag: AppLogTags.progressStatsWidget,
            );
          },
        ),
        const SizedBox(height: AppDimensions.paddingLG),
        // Stats grid
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > AppDimensions.breakpointMedium;
            if (isWide) {
              return Row(
                children: stats.asMap().entries.map((entry) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: entry.key > 0 ? AppDimensions.paddingMD : 0,
                      ),
                      child: _buildStatCard(entry.value, entry.key),
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
                      Expanded(child: _buildStatCard(stats[0], 0)),
                    const SizedBox(width: AppDimensions.paddingMD),
                    if (stats.length > 1)
                      Expanded(child: _buildStatCard(stats[1], 1)),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                if (stats.length > 2) _buildStatCard(stats[2], 2),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatCard(ProfileStat stat, int index) {
    final iconData = _getStatIcon(stat.iconName);
    final iconBgColor = _getIconBgColor(index);
    final iconColor = _getIconColor(index);
    final hasBorder = index == 1; // streak card has bottom border

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
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
          Text(
            stat.label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.outline,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
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
