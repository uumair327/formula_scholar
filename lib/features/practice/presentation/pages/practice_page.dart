import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/shared.dart';
import '../../../auth/auth.dart';
import '../cubit/practice_cubit.dart';
import '../cubit/practice_state.dart';
import '../widgets/widgets.dart';

/// Practice page — routes between pre-filter, quiz, and completion states.
class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  void _loadSubjects() {
    final curr = context.read<CurriculumCubit>().state.curriculum;
    if (curr != null) {
      context.read<PracticeCubit>().loadSubjects(curr.boardId, curr.gradeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CurriculumCubit, CurriculumState>(
      listenWhen: (prev, curr) => prev.curriculum != curr.curriculum,
      listener: (context, state) {
        final curr = state.curriculum;
        if (curr != null) {
          context.read<PracticeCubit>().loadSubjects(curr.boardId, curr.gradeId);
          context.read<PracticeCubit>().resetQuizWithCurriculum(curr.boardId, curr.gradeId);
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        buildWhen: (prev, curr) => prev.user != curr.user,
        builder: (context, authState) {
          return BlocBuilder<PracticeCubit, PracticeState>(
            buildWhen: (prev, curr) =>
                prev.status != curr.status ||
                prev.questions != curr.questions ||
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
                      message: context.localizedError(
                        fallback: state.errorMessage,
                      ),
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
      ),
    );
  }
}
