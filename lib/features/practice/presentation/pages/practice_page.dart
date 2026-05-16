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
class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  bool _isTimed = false;
  int? _timedDuration;

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
            final colorScheme = Theme.of(context).colorScheme;
            if (state.status == PracticeStatus.initial) {
              return _buildPreFilterScreen(context, authState);
            }

            if (state.status == PracticeStatus.loading) {
              return const Scaffold(body: PracticeShimmer());
            }

            if (state.status == PracticeStatus.error) {
              return Scaffold(
                body: AppErrorState(
                  message: state.errorMessage,
                  onRetry: () {
                    final curr = context
                        .read<CurriculumCubit>()
                        .state
                        .curriculum;
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
            if (state.totalQuestions == 0 || question == null) {
              return _buildEmptyState(context, authState);
            }
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
                        color: colorScheme.primaryContainer.withValues(
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
                        color: colorScheme.secondaryContainer.withValues(
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
                          child: RefreshIndicator(
                            onRefresh: () async {
                              final curr = context
                                  .read<CurriculumCubit>()
                                  .state
                                  .curriculum;
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
                                  _buildProgressSection(context, state),
                                  const SizedBox(
                                    height: AppDimensions.paddingXXL,
                                  ),
                                  _buildQuestionCard(context, question),
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
                  if (state.showResult) _buildNextButton(context, state),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPreFilterScreen(BuildContext context, AuthState authState) {
    final colorScheme = Theme.of(context).colorScheme;
    final photoUrl = authState.user?.photoUrl ?? '';
    final subjectState = context.watch<SubjectSelectionCubit>().state;
    final curriculumState = context.watch<CurriculumCubit>().state;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, photoUrl),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingXXL),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Ready to Practice?',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingLG),
                      Text(
                        'Select a subject to focus your quiz, or test your overall knowledge.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingXXL),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Choose Subject',
                              style: AppTextStyles.titleMedium,
                            ),
                            const SizedBox(height: AppDimensions.paddingMD),
                            Wrap(
                              spacing: AppDimensions.paddingSM,
                              runSpacing: AppDimensions.paddingSM,
                              children: [
                                ChoiceChip(
                                  label: const Text('All Subjects'),
                                  selected: true,
                                  onSelected: (_) {
                                    if (curriculumState.hasSelection) {
                                      context.read<PracticeCubit>().loadQuestions(
                                        boardId: curriculumState.boardId!,
                                        gradeId: curriculumState.gradeId!,
                                        timedMode: _isTimed,
                                        durationSeconds: _timedDuration,
                                      );
                                    }
                                  },
                                ),
                                ...subjectState.availableSubjects.map((subject) {
                                  return ChoiceChip(
                                    label: Text(subject.name),
                                    selected: false,
                                    onSelected: (_) {
                                      if (curriculumState.hasSelection) {
                                        context.read<PracticeCubit>().loadQuestions(
                                          boardId: curriculumState.boardId!,
                                          gradeId: curriculumState.gradeId!,
                                          subjectId: subject.category,
                                          timedMode: _isTimed,
                                          durationSeconds: _timedDuration,
                                        );
                                      }
                                    },
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingLG),
                      AppCard(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Timed Mode',
                                    style: AppTextStyles.titleSmall.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: AppDimensions.paddingXXS),
                                  Text(
                                    'Set a time limit for the quiz',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _isTimed,
                              onChanged: (v) {
                                setState(() => _isTimed = v);
                                if (!v) _timedDuration = null;
                              },
                            ),
                          ],
                        ),
                      ),
                      if (_isTimed) ...[
                        const SizedBox(height: AppDimensions.paddingSM),
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Duration',
                                style: AppTextStyles.titleSmall.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingMD),
                              Wrap(
                                spacing: AppDimensions.paddingSM,
                                runSpacing: AppDimensions.paddingSM,
                                children: [5, 10, 15, 30, 60].map((mins) {
                                  return ChoiceChip(
                                    label: Text('$mins min'),
                                    selected: _timedDuration == mins * 60,
                                    onSelected: (_) {
                                      setState(() => _timedDuration = mins * 60);
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AuthState authState) {
    final colorScheme = Theme.of(context).colorScheme;
    final photoUrl = authState.user?.photoUrl ?? '';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, photoUrl),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingXXL),
                  child: AppCard(
                    padding: const EdgeInsets.all(AppDimensions.paddingXXL),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: AppDimensions.imageXL,
                          height: AppDimensions.imageXL,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            LucideIcons.bookOpen,
                            size: AppDimensions.imageLG,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingXXL),
                        Text(
                          AppStrings.practiceNoQuestionsTitle,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headlineSmall.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingSM),
                        Text(
                          AppStrings.practiceNoQuestionsDesc,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingXXL),
                        Wrap(
                          spacing: AppDimensions.paddingMD,
                          runSpacing: AppDimensions.paddingMD,
                          alignment: WrapAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                final curr = context
                                    .read<CurriculumCubit>()
                                    .state
                                    .curriculum;
                                if (curr != null) {
                                  context.read<PracticeCubit>().loadQuestions(
                                    boardId: curr.boardId,
                                    gradeId: curr.gradeId,
                                  );
                                }
                              },
                              child: const Text(AppStrings.retry),
                            ),
                            OutlinedButton(
                              onPressed: () => StatefulNavigationShell.of(
                                context,
                              ).goBranch(1),
                              child: const Text(AppStrings.browseChapters),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String photoUrl) {
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
          GestureDetector(
            onTap: () => context.go(AppRoutes.profilePath),
            behavior: HitTestBehavior.opaque,
            child: photoUrl.isNotEmpty
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
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context, PracticeState state) {
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

  Widget _buildQuestionCard(BuildContext context, QuizQuestion question) {
    final colorScheme = Theme.of(context).colorScheme;

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

  Widget _buildOptions(
    BuildContext context,
    PracticeState state,
    QuizQuestion question,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > AppDimensions.breakpointMedium;
        final options = question.options.map((option) {
          final isSelected = state.selectedOptionId == option.id;
          final isCorrect = option.id == question.correctOptionId;
          final showCorrectState = state.showResult && isSelected && isCorrect;
          final showWrongState = state.showResult && isSelected && !isCorrect;
          // Also highlight the actual correct answer when wrong was selected.
          final showCorrectHint =
              state.showResult && !state.isCorrect && isCorrect;

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
                        fontWeight:
                            showCorrectState ||
                                showWrongState ||
                                showCorrectHint
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
                    Icon(
                      LucideIcons.checkCircle2,
                      size: AppDimensions.iconLG,
                      color: colorScheme.secondary,
                    ),
                  if (showWrongState)
                    Icon(
                      LucideIcons.xCircle,
                      size: AppDimensions.iconLG,
                      color: colorScheme.error,
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

  Widget _buildWrongAnswerToast(BuildContext context) {
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
    final colorScheme = Theme.of(context).colorScheme;

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
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.trophy,
                    size: AppDimensions.imageLG,
                    color: colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingHero),
                Text(
                  AppStrings.quizCompleteTitle,
                  style: AppTextStyles.headlineLarge.copyWith(
                    fontWeight: FontWeight.w900,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSM),
                Text(
                  AppStrings.quizCompleteDesc,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: colorScheme.onSurfaceVariant,
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
                        color: colorScheme.secondary,
                      ),
                      _ScoreStat(
                        icon: LucideIcons.checkCircle2,
                        value: '${state.totalQuestions}',
                        label: AppStrings.practiceQuestionLabel,
                        color: colorScheme.primary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingHero),
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
