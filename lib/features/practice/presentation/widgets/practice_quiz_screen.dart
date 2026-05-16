import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';
import '../cubit/practice_cubit.dart';
import '../cubit/practice_state.dart';

/// Full in-progress quiz screen with header, question, options, toasts, next button.
class PracticeQuizScreen extends StatelessWidget {
  const PracticeQuizScreen({
    super.key,
    required this.photoUrl,
  });
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PracticeCubit>().state;
    final colorScheme = Theme.of(context).colorScheme;
    final question = state.currentQuestion;
    if (question == null) return const SizedBox.shrink();

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height *
                AppDimensions.decorativePositionFraction,
            right: -AppDimensions.decorativeCircleTiny,
            child: Container(
              width: AppDimensions.decorativeBlurLG,
              height: AppDimensions.decorativeBlurLG,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(
                  alpha: AppDimensions.opacityFaint,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height *
                AppDimensions.decorativePositionFraction,
            left: -AppDimensions.decorativeCircleTiny,
            child: Container(
              width: AppDimensions.decorativeBlurLG,
              height: AppDimensions.decorativeBlurLG,
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withValues(
                  alpha: AppDimensions.opacityFaint,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _QuizHeader(photoUrl: photoUrl),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      final curr = context.read<CurriculumCubit>().state.curriculum;
                      if (curr != null) {
                        await context.read<PracticeCubit>().loadQuestions(
                          boardId: curr.boardId,
                          gradeId: curr.gradeId,
                          subjectId: state.subjectId,
                        );
                      }
                    },
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingXXL,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: AppDimensions.paddingLG),
                          _ProgressSection(state: state),
                          const SizedBox(height: AppDimensions.paddingXXL),
                          _QuestionCard(question: question),
                          const SizedBox(height: AppDimensions.paddingXXL),
                          _OptionsList(state: state, question: question),
                          const SizedBox(height: AppDimensions.bottomNavPadding),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (state.showResult && state.isCorrect)
            _SuccessToast(),
          if (state.showResult && !state.isCorrect)
            _WrongAnswerToast(),
          if (state.showResult)
            _NextButton(state: state),
        ],
      ),
    );
  }
}

class _QuizHeader extends StatelessWidget {
  const _QuizHeader({required this.photoUrl});
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXXL,
        vertical: AppDimensions.paddingSM,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => StatefulNavigationShell.of(context).goBranch(1),
            icon: const Icon(LucideIcons.x, size: AppDimensions.iconLG),
          ),
          const SizedBox(width: AppDimensions.paddingMD),
          Text(
            AppStrings.formulaFlow,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: AppDimensions.letterSpacingTight,
              color: colorScheme.primary,
            ),
          ),
          const Spacer(),
          photoUrl.isNotEmpty
              ? AppAvatar(
                  imageUrl: photoUrl,
                  size: AppDimensions.avatarSM,
                  fallbackIcon: LucideIcons.userCircle,
                  fallbackIconColor: colorScheme.primary,
                )
              : Icon(
                  LucideIcons.userCircle,
                  size: AppDimensions.iconLG,
                  color: colorScheme.primary,
                ),
        ],
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({required this.state});
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

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.question});
  final QuizQuestion question;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.paddingHero),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            top: 0, right: 0,
            width: AppDimensions.imageXL,
            height: AppDimensions.imageXL,
            child: Opacity(
              opacity: AppDimensions.opacityFaint,
              child: CachedNetworkImage(
                imageUrl: question.imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => const SizedBox(),
                errorWidget: (context, url, error) => const SizedBox(),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.badgePaddingHorizontal,
                  vertical: AppDimensions.badgePaddingVertical,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                ),
                child: Text(
                  question.category,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                    letterSpacing: AppDimensions.letterSpacingWide,
                    fontSize: AppDimensions.fontSizeXS,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              Text(
                question.questionText,
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  height: AppDimensions.lineHeightRelaxed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OptionsList extends StatelessWidget {
  const _OptionsList({required this.state, required this.question});
  final PracticeState state;
  final QuizQuestion question;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > AppDimensions.breakpointMedium;
        final options = question.options.map((option) {
          final isSelected = state.selectedOptionId == option.id;
          final isCorrect = option.id == question.correctOptionId;
          final showCorrectState = state.showResult && isSelected && isCorrect;
          final showWrongState = state.showResult && isSelected && !isCorrect;
          final showCorrectHint = state.showResult && !state.isCorrect && isCorrect;

          return GestureDetector(
            onTap: () => context.read<PracticeCubit>().selectOption(option.id),
            child: AnimatedContainer(
              duration: AppDurations.animationDefault,
              padding: const EdgeInsets.all(AppDimensions.paddingXXL),
              decoration: BoxDecoration(
                color: showCorrectState || showCorrectHint
                    ? colorScheme.secondaryContainer.withValues(
                        alpha: AppDimensions.opacitySubtle,
                      )
                    : showWrongState
                    ? colorScheme.error.withValues(
                        alpha: AppDimensions.opacityFaint,
                      )
                    : colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                border: Border.all(
                  color: showCorrectState || showCorrectHint
                      ? colorScheme.secondary
                      : showWrongState
                      ? colorScheme.error
                      : Colors.transparent,
                  width: AppDimensions.borderWidth,
                ),
                boxShadow: const [AppShadows.ghost],
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: AppDurations.animationDefault,
                    width: AppDimensions.avatarLG,
                    height: AppDimensions.avatarLG,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: showCorrectState || showCorrectHint
                          ? colorScheme.secondary
                          : showWrongState
                          ? colorScheme.error
                          : colorScheme.surfaceContainerHigh,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      option.id,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: showCorrectState || showCorrectHint
                            ? colorScheme.onSecondary
                            : showWrongState
                            ? colorScheme.onError
                            : colorScheme.outline,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingLG),
                  Expanded(
                    child: Text(
                      option.text,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: showCorrectState || showWrongState || showCorrectHint
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: showCorrectState || showCorrectHint
                            ? colorScheme.onSecondaryContainer
                            : showWrongState
                            ? colorScheme.error
                            : null,
                      ),
                    ),
                  ),
                  if (showCorrectState || showCorrectHint)
                    Icon(LucideIcons.checkCircle2,
                        size: AppDimensions.iconLG,
                        color: colorScheme.secondary),
                  if (showWrongState)
                    Icon(LucideIcons.xCircle,
                        size: AppDimensions.iconLG,
                        color: colorScheme.error),
                ],
              ),
            ),
          );
        }).toList();

        if (isWide) {
          return Wrap(
            spacing: AppDimensions.paddingLG,
            runSpacing: AppDimensions.paddingLG,
            children: options.map((o) => SizedBox(
              width: (constraints.maxWidth - AppDimensions.paddingLG) / 2,
              child: o,
            )).toList(),
          );
        }
        return Column(
          children: options.map((o) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.paddingLG),
            child: o,
          )).toList(),
        );
      },
    );
  }
}

class _SuccessToast extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Positioned(
      bottom: AppDimensions.bottomNavPadding + AppDimensions.paddingXL,
      left: AppDimensions.paddingXXL,
      right: AppDimensions.paddingXXL,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingHero,
            vertical: AppDimensions.paddingLG,
          ),
          decoration: BoxDecoration(
            color: colorScheme.secondary,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
            boxShadow: const [AppShadows.medium],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingXS),
                decoration: BoxDecoration(
                  color: colorScheme.onSecondary.withValues(
                    alpha: AppDimensions.opacitySubtle,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.partyPopper,
                  size: AppDimensions.iconMD,
                  color: colorScheme.onSecondary,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingLG),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${AppStrings.correct} ${AppStrings.plusPointsTemplate}',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: colorScheme.onSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    AppStrings.masteryLevelIncreasing,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: colorScheme.onSecondary.withValues(
                        alpha: AppDimensions.opacityHigh,
                      ),
                      fontWeight: FontWeight.w700,
                      letterSpacing: AppDimensions.letterSpacingWide,
                      fontSize: AppDimensions.fontSizeXS,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WrongAnswerToast extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Positioned(
      bottom: AppDimensions.bottomNavPadding + AppDimensions.paddingXL,
      left: AppDimensions.paddingXXL,
      right: AppDimensions.paddingXXL,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingHero,
            vertical: AppDimensions.paddingLG,
          ),
          decoration: BoxDecoration(
            color: colorScheme.error,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
            boxShadow: const [AppShadows.medium],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingXS),
                decoration: BoxDecoration(
                  color: colorScheme.onError.withValues(
                    alpha: AppDimensions.opacitySubtle,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.xCircle,
                  size: AppDimensions.iconMD,
                  color: colorScheme.onError,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingLG),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.wrongAnswer,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: colorScheme.onError,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    AppStrings.tryNextTime,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: colorScheme.onError.withValues(
                        alpha: AppDimensions.opacityHigh,
                      ),
                      fontWeight: FontWeight.w700,
                      letterSpacing: AppDimensions.letterSpacingWide,
                      fontSize: AppDimensions.fontSizeXS,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({required this.state});
  final PracticeState state;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: AppDimensions.paddingLG,
      left: AppDimensions.paddingXXL,
      right: AppDimensions.paddingXXL,
      child: SafeArea(
        child: FilledButton(
          onPressed: () => context.read<PracticeCubit>().nextQuestion(),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.paddingLG,
            ),
            shape: const StadiumBorder(),
          ),
          child: Text(
            state.isLastQuestion
                ? AppStrings.quizCompleteTitle
                : AppStrings.nextQuestion,
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
