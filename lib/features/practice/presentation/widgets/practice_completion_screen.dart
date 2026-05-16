import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/practice_cubit.dart';
import '../cubit/practice_state.dart';

/// Enhanced quiz completion screen with per-category breakdown,
/// star rating, timer info, and retry-incorrect button.
class PracticeCompletionScreen extends StatelessWidget {
  const PracticeCompletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PracticeCubit>().state;
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
                _ScoreSummaryCard(state: state),
                const SizedBox(height: AppDimensions.paddingLG),
                if (state.answerRecords.isNotEmpty)
                  _CategoryBreakdown(state: state),
                const SizedBox(height: AppDimensions.paddingLG),
                if (state.timedMode)
                  _TimeInfo(state: state),
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

class _ScoreSummaryCard extends StatelessWidget {
  const _ScoreSummaryCard({required this.state});
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

class _CategoryBreakdown extends StatelessWidget {
  const _CategoryBreakdown({required this.state});
  final PracticeState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final categories = <String, _CatStats>{};

    for (final r in state.answerRecords) {
      categories.putIfAbsent(r.category, () => _CatStats());
      categories[r.category]!.total++;
      if (r.isCorrect) categories[r.category]!.correct++;
    }

    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.perCategory,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          ...categories.entries.map((entry) {
            final pct = entry.value.total > 0
                ? (entry.value.correct / entry.value.total) * 100
                : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.paddingMD),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      entry.key,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingMD),
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                      child: LinearProgressIndicator(
                        value: pct / 100,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        color: pct >= 80
                            ? colorScheme.secondary
                            : pct >= 50
                                ? colorScheme.tertiary
                                : colorScheme.error,
                        minHeight: AppDimensions.progressBarSM,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingMD),
                  SizedBox(
                    width: 36,
                    child: Text(
                      '${pct.round()}%',
                      textAlign: TextAlign.end,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CatStats {
  int total = 0;
  int correct = 0;
}

class _TimeInfo extends StatelessWidget {
  const _TimeInfo({required this.state});
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
