import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/practice_state.dart';

class ScoreSummaryCard extends StatelessWidget {
  const ScoreSummaryCard({super.key, required this.state});
  final PracticeState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ScoreStat(
            icon: LucideIcons.checkCircle2,
            value: '${state.correctCount}',
            label: AppStrings.correctLabel,
            color: colorScheme.secondary,
          ),
          Container(
            width: AppDimensions.dividerHeight,
            height: AppDimensions.avatarMD,
            color: colorScheme.surfaceContainerHighest,
          ),
          _ScoreStat(
            icon: LucideIcons.xCircle,
            value: '${state.incorrectCount}',
            label: AppStrings.incorrectLabel,
            color: colorScheme.error,
          ),
          Container(
            width: AppDimensions.dividerHeight,
            height: AppDimensions.avatarMD,
            color: colorScheme.surfaceContainerHighest,
          ),
          _ScoreStat(
            icon: LucideIcons.star,
            value: '${state.totalPoints}',
            label: AppStrings.ptsLabel,
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _ScoreStat extends StatelessWidget {
  const _ScoreStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Icon(icon, size: AppDimensions.iconLG, color: color),
        const SizedBox(height: AppDimensions.paddingSM),
        Text(
          value,
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: colorScheme.outline,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
