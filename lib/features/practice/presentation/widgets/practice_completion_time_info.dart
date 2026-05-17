import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/practice_state.dart';

class TimeInfo extends StatelessWidget {
  const TimeInfo({super.key, required this.state});
  final PracticeState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final total = state.totalSeconds;
    final taken = total - state.remainingSeconds;
    final mins = (taken ~/ 60).toString().padLeft(2, '0');
    final secs = (taken % 60).toString().padLeft(2, '0');

    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.clock, size: AppDimensions.iconMD,
              color: colorScheme.outline),
          const SizedBox(width: AppDimensions.paddingSM),
          Text(
            '$mins:$secs',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: AppDimensions.paddingXS),
          Text(
            AppStrings.timeTaken,
            style: AppTextStyles.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
