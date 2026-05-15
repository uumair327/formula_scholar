import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../domain/entities/achievement.dart';
import '../cubit/achievements_cubit.dart';
import '../cubit/achievements_state.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        centerTitle: true,
      ),
      body: BlocBuilder<AchievementsCubit, AchievementsState>(
        builder: (context, state) {
          final unlocked = state.unlocked;
          final locked = state.locked;

          return ListView(
            padding: const EdgeInsets.all(AppDimensions.paddingMD),
            children: [
              _buildProgressCard(context, state),
              const SizedBox(height: AppDimensions.paddingLG),
              if (unlocked.isNotEmpty) ...[
                Text(
                  'Unlocked (${unlocked.length})',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSM),
                ...unlocked.map((a) => _buildAchievementTile(context, a)),
                const SizedBox(height: AppDimensions.paddingLG),
              ],
              if (locked.isNotEmpty) ...[
                Text(
                  'Locked (${locked.length})',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSM),
                ...locked.map((a) => _buildAchievementTile(context, a)),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, AchievementsState state) {
    final colorScheme = Theme.of(context).colorScheme;
    final fraction = state.totalAchievements > 0
        ? state.totalUnlocked / state.totalAchievements
        : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLG),
        child: Column(
          children: [
            Row(
              children: [
                Icon(LucideIcons.trophy, color: colorScheme.primary),
                const SizedBox(width: AppDimensions.paddingSM),
                Text(
                  '${state.totalUnlocked} / ${state.totalAchievements}',
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 10,
                backgroundColor: colorScheme.surfaceContainerLow,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementTile(BuildContext context, Achievement achievement) {
    final colorScheme = Theme.of(context).colorScheme;
    final isUnlocked = achievement.isUnlocked;

    return Card(
      color: isUnlocked ? null : colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Row(
          children: [
            _buildBadgeIcon(context, achievement),
            const SizedBox(width: AppDimensions.paddingMD),
            Expanded(
              child: Column(
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
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSM,
                      ),
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
              ),
            ),
            _buildTierBadge(achievement.tier),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeIcon(BuildContext context, Achievement achievement) {
    final colorScheme = Theme.of(context).colorScheme;
    final isUnlocked = achievement.isUnlocked;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isUnlocked
            ? _tierColor(achievement.tier).withValues(alpha: 0.15)
            : colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: Icon(
        IconData(achievement.iconCodePoint, fontFamily: 'MaterialIcons'),
        color: isUnlocked
            ? _tierColor(achievement.tier)
            : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        size: 24,
      ),
    );
  }

  Widget _buildTierBadge(AchievementTier tier) {
    final color = _tierColor(tier);
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
        tier.name.toUpperCase(),
        style: AppTextStyles.overline.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 9,
        ),
      ),
    );
  }

  Color _tierColor(AchievementTier tier) {
    switch (tier) {
      case AchievementTier.bronze:
        return const Color(0xFFCD7F32);
      case AchievementTier.silver:
        return const Color(0xFFC0C0C0);
      case AchievementTier.gold:
        return const Color(0xFFFFD700);
      case AchievementTier.diamond:
        return const Color(0xFF00CED1);
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
