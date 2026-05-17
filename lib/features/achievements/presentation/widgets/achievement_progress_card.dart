import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../cubit/achievements_state.dart';

class AchievementProgressCard extends StatelessWidget {
  const AchievementProgressCard({super.key, required this.state});

  final AchievementsState state;

  @override
  Widget build(BuildContext context) {
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
}
