import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../auth/auth.dart';
import '../../domain/domain.dart';
import '../cubit/practice_cubit.dart';
import '../cubit/practice_state.dart';

/// Practice quiz page matching the React prototype.
class PracticePage extends StatelessWidget {
  const PracticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (prev, curr) => prev.user != curr.user,
      builder: (context, authState) {
        return BlocBuilder<PracticeCubit, PracticeState>(
          buildWhen: (prev, curr) =>
              prev.status != curr.status ||
              prev.currentIndex != curr.currentIndex ||
              prev.selectedOptionId != curr.selectedOptionId ||
              prev.showResult != curr.showResult,
          builder: (context, state) {
            if (state.status == PracticeStatus.loading ||
                state.status == PracticeStatus.initial) {
              return const Scaffold(body: AppLoadingState());
            }

            if (state.status == PracticeStatus.error) {
              return Scaffold(
                body: AppErrorState(
                  message: state.errorMessage,
                  onRetry: () {
                    final curr = context.read<CurriculumCubit>().state.curriculum;
                    if (curr != null) {
                      context.read<PracticeCubit>().loadQuestions(
                        boardId: curr.boardId,
                        gradeId: curr.gradeId,
                      );
                    }
                  },
                ),
              );
            }

            if (state.status == PracticeStatus.completed) {
              return _buildCompletionScreen(context, state, authState);
            }
            final question = state.currentQuestion;
            if (question == null) return const SizedBox.shrink();
            final photoUrl = authState.user?.photoUrl ?? '';

            return Scaffold(
              body: Stack(
                children: [
                  // Background decorative blurs.
                  Positioned(
                    top:
                        MediaQuery.of(context).size.height *
                        AppDimensions.decorativePositionFraction,
                    right: -AppDimensions.decorativeCircleTiny,
                    child: Container(
                      width: AppDimensions.decorativeBlurLG,
                      height: AppDimensions.decorativeBlurLG,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer.withValues(
                          alpha: AppDimensions.opacityFaint,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom:
                        MediaQuery.of(context).size.height *
                        AppDimensions.decorativePositionFraction,
                    left: -AppDimensions.decorativeCircleTiny,
                    child: Container(
                      width: AppDimensions.decorativeBlurLG,
                      height: AppDimensions.decorativeBlurLG,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer.withValues(
                          alpha: AppDimensions.opacityFaint,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  // Main content.
                  SafeArea(
                    child: Column(
                      children: [
                        // Header.
                        _buildHeader(context, photoUrl),
                        // Scrollable content.
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingXXL,
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: AppDimensions.paddingLG),
                                _buildProgressSection(state),
                                const SizedBox(
                                  height: AppDimensions.paddingXXL,
                                ),
                                _buildQuestionCard(question),
                                const SizedBox(
                                  height: AppDimensions.paddingXXL,
                                ),
                                _buildOptions(context, state, question),
                                const SizedBox(
                                  height: AppDimensions.bottomNavPadding,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Success toast.
                  if (state.showResult && state.isCorrect)
                    _buildSuccessToast(context),

                  // Wrong-answer toast.
                  if (state.showResult && !state.isCorrect)
                    _buildWrongAnswerToast(context),

                  // Next / Finish button.
                  if (state.showResult)
                    _buildNextButton(context, state),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, String photoUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXXL,
        vertical: AppDimensions.paddingSM,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(LucideIcons.x, size: AppDimensions.iconLG),
          ),
          const SizedBox(width: AppDimensions.paddingMD),
          Text(
            AppStrings.formulaFlow,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: AppDimensions.letterSpacingTight,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => context.go(AppRoutes.profilePath),
            behavior: HitTestBehavior.opaque,
            child: photoUrl.isNotEmpty
                ? AppAvatar(
                    imageUrl: photoUrl,
                    size: AppDimensions.avatarSM,
                    fallbackIcon: LucideIcons.userCircle,
                    fallbackIconColor: AppColors.primary,
                  )
                : const Icon(
                    LucideIcons.userCircle,
                    size: AppDimensions.iconLG,
                    color: AppColors.primary,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(PracticeState state) {
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
                    color: AppColors.primary,
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
                const Icon(
                  LucideIcons.star,
                  size: AppDimensions.iconSM,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: AppDimensions.paddingXS),
                Text(
                  '${state.totalPoints} ${AppStrings.ptsLabel}',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.secondary,
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

  Widget _buildQuestionCard(QuizQuestion question) {
    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.paddingHero),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Background question image.
          Positioned(
            top: 0,
            right: 0,
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
          // Content.
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.badgePaddingHorizontal,
                  vertical: AppDimensions.badgePaddingVertical,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                ),
                child: Text(
                  question.category,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.onPrimaryFixedVariant,
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

  Widget _buildOptions(
    BuildContext context,
    PracticeState state,
    QuizQuestion question,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > AppDimensions.breakpointMedium;
        final options = question.options.map((option) {
          final isSelected = state.selectedOptionId == option.id;
          final isCorrect = option.id == question.correctOptionId;
          final showCorrectState = state.showResult && isSelected && isCorrect;
          final showWrongState = state.showResult && isSelected && !isCorrect;
          // Also highlight the actual correct answer when wrong was selected.
          final showCorrectHint = state.showResult && !state.isCorrect && isCorrect;

          return GestureDetector(
            onTap: () => context.read<PracticeCubit>().selectOption(option.id),
            child: AnimatedContainer(
              duration: AppDurations.animationDefault,
              padding: const EdgeInsets.all(AppDimensions.paddingXXL),
              decoration: BoxDecoration(
                color: showCorrectState || showCorrectHint
                    ? AppColors.secondaryContainer.withValues(
                        alpha: AppDimensions.opacitySubtle,
                      )
                    : showWrongState
                        ? AppColors.error.withValues(
                            alpha: AppDimensions.opacityFaint,
                          )
                        : AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                border: Border.all(
                  color: showCorrectState || showCorrectHint
                      ? AppColors.secondary
                      : showWrongState
                          ? AppColors.error
                          : AppColors.transparent,
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
                          ? AppColors.secondary
                          : showWrongState
                              ? AppColors.error
                              : AppColors.surfaceContainerHigh,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      option.id,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: showCorrectState || showCorrectHint || showWrongState
                            ? AppColors.onSecondary
                            : AppColors.outline,
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
                            ? AppColors.onSecondaryContainer
                            : showWrongState
                                ? AppColors.error
                                : null,
                      ),
                    ),
                  ),
                  if (showCorrectState || showCorrectHint)
                    const Icon(
                      LucideIcons.checkCircle2,
                      size: AppDimensions.iconLG,
                      color: AppColors.secondary,
                    ),
                  if (showWrongState)
                    const Icon(
                      LucideIcons.xCircle,
                      size: AppDimensions.iconLG,
                      color: AppColors.error,
                    ),
                ],
              ),
            ),
          );
        }).toList();

        if (isWide) {
          return Wrap(
            spacing: AppDimensions.paddingLG,
            runSpacing: AppDimensions.paddingLG,
            children: options
                .map(
                  (o) => SizedBox(
                    width: (constraints.maxWidth - AppDimensions.paddingLG) / 2,
                    child: o,
                  ),
                )
                .toList(),
          );
        }
        return Column(
          children: options
              .map(
                (o) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppDimensions.paddingLG,
                  ),
                  child: o,
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildSuccessToast(BuildContext context) {
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
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
            boxShadow: const [AppShadows.medium],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingXS),
                decoration: BoxDecoration(
                  color: AppColors.onSecondary.withValues(
                    alpha: AppDimensions.opacitySubtle,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.partyPopper,
                  size: AppDimensions.iconMD,
                  color: AppColors.onSecondary,
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
                      color: AppColors.onSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    AppStrings.masteryLevelIncreasing,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.onSecondary.withValues(
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

  Widget _buildWrongAnswerToast(BuildContext context) {
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
            color: AppColors.error,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
            boxShadow: const [AppShadows.medium],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingXS),
                decoration: BoxDecoration(
                  color: AppColors.onError.withValues(
                    alpha: AppDimensions.opacitySubtle,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.xCircle,
                  size: AppDimensions.iconMD,
                  color: AppColors.onError,
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
                      color: AppColors.onError,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    AppStrings.tryNextTime,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.onError.withValues(
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

  Widget _buildNextButton(BuildContext context, PracticeState state) {
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

  Widget _buildCompletionScreen(
    BuildContext context,
    PracticeState state,
    AuthState authState,
  ) {
    final photoUrl = authState.user?.photoUrl ?? '';
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingHero),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: AppDimensions.imageXL,
                  height: AppDimensions.imageXL,
                  decoration: const BoxDecoration(
                    color: AppColors.secondaryFixed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.trophy,
                    size: AppDimensions.imageLG,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingHero),
                Text(
                  AppStrings.quizCompleteTitle,
                  style: AppTextStyles.headlineLarge.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSM),
                Text(
                  AppStrings.quizCompleteDesc,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingHero),
                // Score card
                AppCard(
                  padding: const EdgeInsets.all(AppDimensions.paddingXXL),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ScoreStat(
                        icon: LucideIcons.star,
                        value: '${state.totalPoints}',
                        label: AppStrings.ptsLabel,
                        color: AppColors.secondary,
                      ),
                      _ScoreStat(
                        icon: LucideIcons.checkCircle2,
                        value: '${state.totalQuestions}',
                        label: AppStrings.practiceQuestionLabel,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingHero),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () =>
                        context.read<PracticeCubit>().resetQuiz(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small stat display used in the completion screen.
class _ScoreStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _ScoreStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
            color: AppColors.outline,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
