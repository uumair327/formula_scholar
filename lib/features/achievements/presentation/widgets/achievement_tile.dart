import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../domain/entities/achievement.dart';
import '../cubit/achievements_cubit.dart';

class AchievementTile extends StatelessWidget {
  const AchievementTile({super.key, required this.achievement});

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isUnlocked = achievement.isUnlocked;

    return Card(
      color: isUnlocked ? null : colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Row(
          children: [
            _badgeIcon(context),
            const SizedBox(width: AppDimensions.paddingMD),
            Expanded(child: _infoColumn(context)),
            _tierBadge(),
          ],
        ),
      ),
    );
  }

  Widget _badgeIcon(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isUnlocked = achievement.isUnlocked;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isUnlocked
            ? _tierColor().withValues(alpha: 0.15)
            : colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: Icon(
        AchievementsCubit.iconFor(achievement.id),
        color: isUnlocked
            ? _tierColor()
            : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        size: 24,
      ),
    );
  }

  Widget _infoColumn(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isUnlocked = achievement.isUnlocked;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          achievement.title,
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: isUnlocked ? null : colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          achievement.description,
          style: AppTextStyles.bodySmall.copyWith(
            color: isUnlocked
                ? colorScheme.onSurfaceVariant
                : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
        ),
        if (!isUnlocked && achievement.target > 1) ...[
          const SizedBox(height: AppDimensions.paddingSM),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
            child: LinearProgressIndicator(
              value: achievement.progressFraction,
              minHeight: 4,
              backgroundColor: colorScheme.surfaceContainerHighest,
            ),
          ),
          Text(
            '${achievement.progress} / ${achievement.target}',
            style: AppTextStyles.overline.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        if (isUnlocked && achievement.unlockedAt != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              'Earned ${_formatDate(achievement.unlockedAt!)}',
              style: AppTextStyles.overline.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _tierBadge() {
    final color = _tierColor();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSM,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
      ),
      child: Text(
        achievement.tier.name.toUpperCase(),
        style: AppTextStyles.overline.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 9,
        ),
      ),
    );
  }

  Color _tierColor() {
    switch (achievement.tier) {
      case AchievementTier.bronze:
        return AppColors.tierBronze;
      case AchievementTier.silver:
        return AppColors.tierSilver;
      case AchievementTier.gold:
        return AppColors.tierGold;
      case AchievementTier.diamond:
        return AppColors.tierDiamond;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
