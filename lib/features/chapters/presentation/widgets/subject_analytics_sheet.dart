import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';

/// A premium, polished bottom sheet presenting subject-specific analytics.
class SubjectAnalyticsSheet extends StatelessWidget {
  final String subjectName;
  final int progressPercent;
  final int completedFormulas;
  final int totalFormulas;
  final String grade;

  const SubjectAnalyticsSheet({
    super.key,
    required this.subjectName,
    required this.progressPercent,
    required this.completedFormulas,
    required this.totalFormulas,
    required this.grade,
  });

  /// Displays the analytics sheet.
  static void show(
    BuildContext context, {
    required String subjectName,
    required int progressPercent,
    required int completedFormulas,
    required int totalFormulas,
    required String grade,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
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
                  color: AppColors.surfaceContainerHigh,
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
                        '$subjectName Analytics',
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingXXS),
                      Text(
                        'Your mastery metrics for $grade',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingXXL),
            _buildStatCard(
              title: 'Mastery Progress',
              value: '$progressPercent%',
              icon: LucideIcons.target,
              color: AppColors.primary,
              child: ProgressBar(
                percentage: progressPercent.toDouble(),
                barColor: AppColors.primary,
                backgroundColor: AppColors.surfaceContainerHighest,
                height: AppDimensions.progressBarMD,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Formulas Mastered',
                    value: '$completedFormulas / $totalFormulas',
                    icon: LucideIcons.checkCircle2,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingLG),
                Expanded(
                  child: _buildStatCard(
                    title: 'Current Streak',
                    value: '3 Days',
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
                  backgroundColor: AppColors.surfaceContainerHigh,
                  foregroundColor: AppColors.onSurface,
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
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    Widget? child,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(
          color: color.withOpacity(0.1),
        ),
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
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.onSurface,
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
