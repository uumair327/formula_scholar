import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';

import '../cubit/practice_cubit.dart';
import '../cubit/practice_state.dart';
import 'practice_quiz_header.dart';
import 'practice_quiz_next_button.dart';
import 'practice_quiz_options_list.dart';
import 'practice_quiz_progress.dart';
import 'practice_quiz_question_card.dart';
import 'practice_quiz_toasts.dart';

/// In-progress quiz screen composed of extracted sub-widgets.
class PracticeQuizScreen extends StatelessWidget {
  const PracticeQuizScreen({super.key, required this.photoUrl});
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PracticeCubit, PracticeState>(
      builder: (context, state) {
        final colorScheme = Theme.of(context).colorScheme;
        final question = state.currentQuestion;
        if (question == null) return const SizedBox.shrink();

        return Scaffold(
          body: Stack(
            children: [
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
              SafeArea(
                child: Column(
                  children: [
                    QuizHeader(photoUrl: photoUrl),
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
                            key: ValueKey('quiz_q_${question.id}'),
                            children: [
                              const SizedBox(height: AppDimensions.paddingLG),
                              QuizProgressSection(state: state),
                              const SizedBox(height: AppDimensions.paddingXXL),
                              QuizQuestionCard(question: question),
                              const SizedBox(height: AppDimensions.paddingXXL),
                              QuizOptionsList(state: state, question: question),
                              // Extra padding so the floating Next button doesn't overlap options
                              SizedBox(
                                height: state.showResult
                                    ? AppDimensions.bottomNavPadding + 80
                                    : AppDimensions.bottomNavPadding,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (state.showResult && state.isCorrect) const QuizSuccessToast(),
              if (state.showResult && !state.isCorrect)
                const QuizWrongAnswerToast(),
              if (state.showResult) QuizNextButton(state: state),
            ],
          ),
        );
      },
    );
  }
}
