import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/entities/quiz_result.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({super.key, required this.result});
  final QuizResult result;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pct = result.scorePercent.round();
    final stars = result.starRating;
    final dateStr = _formatDate(result.completedAt);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingMD),
      child: AppCard(
        padding: const EdgeInsets.all(AppDimensions.paddingLG),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ...List.generate(5, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 1),
                          child: Icon(
                            i < stars ? LucideIcons.star : LucideIcons.star,
                            size: AppDimensions.iconSM,
                            color: i < stars
                                ? colorScheme.secondary
                                : colorScheme.outlineVariant,
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.paddingSM),
                  Text(
                    '$pct% ${AppStrings.scoreLabel}',
                    style: AppTextStyles.titleLarge.copyWith(
                      fontWeight: FontWeight.w800,
                      color: pct >= 80
                          ? colorScheme.secondary
                          : pct >= 50
                              ? colorScheme.tertiary
                              : colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingXS),
                  Text(
                    '${result.correctCount}/${result.totalQuestions} ${AppStrings.correctLabel}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  dateStr,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colorScheme.outline,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXS),
                Text(
                  '+${result.totalPoints} ${AppStrings.ptsLabel}',
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return AppStrings.today;
    if (diff.inDays == 1) return AppStrings.yesterday;
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }
}
