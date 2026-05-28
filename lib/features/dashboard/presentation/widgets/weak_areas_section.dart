import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

/// Displays weak-area recommendations derived from quiz answer history.
class WeakAreasSection extends StatelessWidget {
  const WeakAreasSection({super.key, required this.weakAreas});
  final List<WeakArea> weakAreas;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (weakAreas.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMD),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withValues(
                  alpha: AppDimensions.opacityFaint,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
              ),
              child: Icon(
                LucideIcons.trendingUp,
                size: AppDimensions.iconMD,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingLG),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Focus Areas',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXS),
                Text(
                  'Practice these subjects to improve',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.paddingLG),
        ...weakAreas.map(
          (area) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.paddingMD),
            child: _WeakAreaTile(area: area),
          ),
        ),
      ],
    );
  }
}

class _WeakAreaTile extends StatelessWidget {
  const _WeakAreaTile({required this.area});
  final WeakArea area;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final weakness = area.weaknessScore.round();
    final isWeak = weakness >= 50;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isWeak
                ? colorScheme.errorContainer.withValues(alpha: 0.1)
                : colorScheme.tertiaryContainer.withValues(alpha: 0.1),
            colorScheme.surfaceContainerLowest,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(
          color: isWeak
              ? colorScheme.error.withValues(alpha: 0.2)
              : colorScheme.tertiary.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: const [AppShadows.soft],
      ),
      child: Row(
        children: [
          Container(
            width: AppDimensions.avatarMD,
            height: AppDimensions.avatarMD,
            decoration: BoxDecoration(
              color: isWeak
                  ? colorScheme.errorContainer.withValues(
                      alpha: AppDimensions.opacityLight,
                    )
                  : colorScheme.tertiaryContainer.withValues(
                      alpha: AppDimensions.opacityLight,
                    ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
            ),
            child: Icon(
              isWeak ? LucideIcons.alertTriangle : LucideIcons.checkCircle2,
              size: AppDimensions.iconMD,
              color: isWeak ? colorScheme.error : colorScheme.tertiary,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingLG),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  area.subjectName.isNotEmpty
                      ? area.subjectName
                      : area.category,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXS),
                Row(
                  children: [
                    Text(
                      '${area.correctAttempts}/${area.totalAttempts} correct',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$weakness%',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isWeak
                            ? colorScheme.error
                            : colorScheme.tertiary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingSM),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                  child: LinearProgressIndicator(
                    value: area.weaknessScore / 100,
                    backgroundColor: isWeak
                        ? colorScheme.errorContainer.withValues(alpha: 0.3)
                        : colorScheme.tertiaryContainer.withValues(alpha: 0.3),
                    color: isWeak ? colorScheme.error : colorScheme.tertiary,
                    minHeight: AppDimensions.progressBarSM,
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
