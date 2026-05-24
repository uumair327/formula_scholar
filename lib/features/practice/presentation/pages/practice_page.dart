import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/shared.dart';
import '../../../auth/auth.dart';
import '../cubit/practice_cubit.dart';
import '../cubit/practice_state.dart';
import '../widgets/widgets.dart';

/// Practice page — routes between pre-filter, quiz, and completion states.
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
            switch (state.status) {
              case PracticeStatus.initial:
                return PracticePreFilter(
                  isTimed: state.selectedTimedMode,
                  timedDuration: state.selectedTimedDurationSeconds,
                  onTimedChanged: context.read<PracticeCubit>().setTimedMode,
                  onDurationChanged: context
                      .read<PracticeCubit>()
                      .setTimedDuration,
                );
              case PracticeStatus.loading:
                return const Scaffold(body: PracticeShimmer());
              case PracticeStatus.error:
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
              case PracticeStatus.completed:
                return const PracticeCompletionScreen();
              case PracticeStatus.loaded:
                final question = state.currentQuestion;
                if (state.totalQuestions == 0 || question == null) {
                  return PracticeEmptyState(
                    photoUrl: authState.user?.photoUrl ?? '',
                  );
                }
                return PracticeQuizScreen(
                  photoUrl: authState.user?.photoUrl ?? '',
                );
            }
          },
        );
      },
    );
  }
}
