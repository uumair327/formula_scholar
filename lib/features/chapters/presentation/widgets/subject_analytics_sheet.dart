import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';

/// A premium, polished bottom sheet presenting subject-specific analytics.
class SubjectAnalyticsSheet extends StatelessWidget {
  const SubjectAnalyticsSheet({
    super.key,
    required this.subjectName,
    required this.progressPercent,
    required this.completedFormulas,
    required this.totalFormulas,
    required this.grade,
    this.currentStreak,
  });
  final String subjectName;
  final int progressPercent;
  final int completedFormulas;
  final int totalFormulas;
  final String grade;
  final int? currentStreak;

  /// Displays the analytics sheet.
  static void show(
    BuildContext context, {
    required String subjectName,
    required int progressPercent,
    required int completedFormulas,
    required int totalFormulas,
    required String grade,
    int? currentStreak,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => SubjectAnalyticsSheet(
        subjectName: subjectName,
        progressPercent: progressPercent,
        completedFormulas: completedFormulas,
        totalFormulas: totalFormulas,
        grade: grade,
        currentStreak: currentStreak,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusXXL),
          topRight: Radius.circular(AppDimensions.radiusXXL),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXXL,
        vertical: AppDimensions.paddingLG,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: AppDimensions.avatarMD,
                height: AppDimensions.borderWidthThick,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXXL),
            Row(
              children: [
                AppIconCircle(
                  icon: LucideIcons.barChart3,
                  size: AppDimensions.avatarHero,
                  backgroundColor: colorScheme.primaryContainer,
                  iconColor: colorScheme.primary,
                  iconSize: AppDimensions.iconXL,
                ),
                const SizedBox(width: AppDimensions.paddingLG),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$subjectName Analytics',
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingXXS),
                      Text(
                        'Your mastery metrics for $grade',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingXXL),
            _buildStatCard(
              context: context,
              title: 'Mastery Progress',
              value: '$progressPercent%',
              icon: LucideIcons.target,
              color: AppColors.primary,
              child: ProgressBar(
                percentage: progressPercent.toDouble(),
                barColor: AppColors.primary,
                backgroundColor: colorScheme.surfaceContainerHighest,
                height: AppDimensions.progressBarMD,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context: context,
                    title: 'Formulas Mastered',
                    value: '$completedFormulas / $totalFormulas',
                    icon: LucideIcons.checkCircle2,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingLG),
                Expanded(
                  child: _buildStatCard(
                    context: context,
                    title: 'Current Streak',
                    value: currentStreak == null
                        ? 'Not available'
                        : '$currentStreak Days',
                    icon: LucideIcons.flame,
                    color: AppColors.orange500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingXL),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(LucideIcons.check, size: AppDimensions.iconSM),
                label: const Text('Close Details'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.surfaceContainerHigh,
                  foregroundColor: colorScheme.onSurface,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingXXL,
                    vertical: AppDimensions.paddingMD,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMD),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    Widget? child,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: AppDimensions.iconSM, color: color),
              const SizedBox(width: AppDimensions.paddingSM),
              Text(
                title,
                style: AppTextStyles.labelMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (child != null) ...[
            const SizedBox(height: AppDimensions.paddingMD),
            child,
          ],
        ],
      ),
    );
  }
}
