import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../cubit/practice_cubit.dart';
import '../cubit/practice_state.dart';
import 'practice_completion_category_breakdown.dart';
import 'practice_completion_score_summary.dart';
import 'practice_completion_time_info.dart';

/// Enhanced quiz completion screen with per-category breakdown,
/// star rating, timer info, and retry-incorrect button.
class PracticeCompletionScreen extends StatelessWidget {
  const PracticeCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PracticeCubit, PracticeState>(
      builder: (context, state) {
    final colorScheme = Theme.of(context).colorScheme;
    final pct = state.scorePercent.round();
    final stars = state.starRating;
    final hasIncorrect = state.incorrectCount > 0;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingHero),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTrophyIcon(context),
                const SizedBox(height: AppDimensions.paddingXL),
                _buildStarRating(context, stars),
                const SizedBox(height: AppDimensions.paddingSM),
                Text(
                  AppStrings.quizCompleteTitle,
                  style: AppTextStyles.headlineLarge.copyWith(
                    fontWeight: FontWeight.w900,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSM),
                if (state.timerStatus == TimerStatus.expired) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingMD,
                      vertical: AppDimensions.paddingXS,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                    ),
                    child: Text(
                      'Time\'s Up!',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: colorScheme.onErrorContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingMD),
                ],
                Text(
                  '$pct% ${AppStrings.scoreLabel}',
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: pct >= 80
                        ? colorScheme.secondary
                        : pct >= 50
                            ? colorScheme.tertiary
                            : colorScheme.error,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                Text(
                  AppStrings.quizCompleteDesc,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXL),
                ScoreSummaryCard(state: state),
                const SizedBox(height: AppDimensions.paddingLG),
                if (state.answerRecords.isNotEmpty)
                  CategoryBreakdown(state: state),
                const SizedBox(height: AppDimensions.paddingLG),
                if (state.timedMode)
                  TimeInfo(state: state),
                const SizedBox(height: AppDimensions.paddingXL),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => context.read<PracticeCubit>().resetQuiz(),
                    icon: const Icon(LucideIcons.refreshCw),
                    label: Text(
                      AppStrings.playAgain,
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.paddingLG,
                      ),
                      shape: const StadiumBorder(),
                    ),
                  ),
                ),
                if (hasIncorrect) ...[
                  const SizedBox(height: AppDimensions.paddingMD),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          context.read<PracticeCubit>().retryIncorrect(),
                      icon: const Icon(LucideIcons.refreshCcw),
                      label: Text(
                        AppStrings.retryIncorrect,
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.paddingLG,
                        ),
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppDimensions.paddingMD),
                TextButton(
                  onPressed: () =>
                      StatefulNavigationShell.of(context).goBranch(0),
                  child: Text(
                    AppStrings.backToDashboard,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    },
    );
  }

  Widget _buildTrophyIcon(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: AppDimensions.imageXL,
      height: AppDimensions.imageXL,
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(
        LucideIcons.trophy,
        size: AppDimensions.imageLG,
        color: colorScheme.secondary,
      ),
    );
  }

  Widget _buildStarRating(BuildContext context, int stars) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            i < stars ? LucideIcons.star : LucideIcons.star,
            size: AppDimensions.iconLG,
            color: i < stars ? colorScheme.secondary : colorScheme.outlineVariant,
          ),
        );
      }),
    );
  }
}
