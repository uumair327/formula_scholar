import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/practice_state.dart';

class QuizProgressSection extends StatelessWidget {
  const QuizProgressSection({super.key, required this.state});
  final PracticeState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final timerColor = state.isTimerWarning
        ? colorScheme.error
        : colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppStrings.practiceQuestionLabel} ${state.currentIndex + 1} ${AppStrings.ofLabel} ${state.totalQuestions}',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: AppDimensions.letterSpacingWide,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXS),
                Text(
                  state.currentQuestion?.topic ?? '',
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (state.timedMode) ...[
                  Icon(
                    state.timerStatus == TimerStatus.expired
                        ? LucideIcons.clock
                        : state.isTimerWarning
                            ? LucideIcons.alertTriangle
                            : LucideIcons.timer,
                    size: AppDimensions.iconSM,
                    color: timerColor,
                  ),
                  const SizedBox(width: AppDimensions.paddingXS),
                  Text(
                    state.formattedRemaining,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: timerColor,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingLG),
                ],
                Icon(
                  LucideIcons.star,
                  size: AppDimensions.iconSM,
                  color: colorScheme.secondary,
                ),
                const SizedBox(width: AppDimensions.paddingXS),
                Text(
                  '${state.totalPoints} ${AppStrings.ptsLabel}',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.paddingLG),
        ProgressBar(
          percentage: state.progress * 100,
          height: AppDimensions.progressBarLG,
        ),
      ],
    );
  }
}
