import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';
import 'practice_state.dart';

/// Cubit managing the Practice quiz screen's state.
///
/// Uses [CubitFailureLogger] mixin to eliminate error logging boilerplate.
@injectable
class PracticeCubit extends Cubit<PracticeState>
    with CubitFailureLogger<PracticeState> {

  PracticeCubit({
    required GetQuestionsUseCase getQuestions,
    required RecordQuizCompletionUseCase recordQuizCompletion,
    required ActivityRefreshCubit activityRefreshCubit,
  }) : _getQuestions = getQuestions,
       _recordQuizCompletion = recordQuizCompletion,
       _activityRefreshCubit = activityRefreshCubit,
       super(const PracticeState());
  final GetQuestionsUseCase _getQuestions;
  final RecordQuizCompletionUseCase _recordQuizCompletion;
  final ActivityRefreshCubit _activityRefreshCubit;

  @override
  String get logTag => AppLogTags.practiceCubit;

  /// Loads quiz questions.
  Future<void> loadQuestions({
    required String boardId,
    required String gradeId,
  }) async {
    AppLogger.info('Loading practice questions', tag: AppLogTags.practiceCubit);
    emit(
      state.copyWith(
        status: PracticeStatus.loading,
        boardId: boardId,
        gradeId: gradeId,
      ),
    );

    final result = await _getQuestions(boardId: boardId, gradeId: gradeId);

    switch (result) {
      case Success(:final data):
        AppLogger.info(
          'Loaded ${data.length} questions',
          tag: AppLogTags.practiceCubit,
        );
        emit(state.copyWith(status: PracticeStatus.loaded, questions: data));
      case Error(:final failure):
        logFailure('practice questions', failure);
        emit(
          state.copyWith(
            status: PracticeStatus.error,
            errorMessage: failure.message,
          ),
        );
    }
  }

  /// Selects an answer option.
  void selectOption(String optionId) {
    if (state.selectedOptionId != null) return; // Already answered.

    final isCorrect = optionId == state.currentQuestion?.correctOptionId;
    final newPoints = isCorrect
        ? state.totalPoints + (state.currentQuestion?.points ?? 0)
        : state.totalPoints;

    AppLogger.debug(
      'Option selected: $optionId (correct: $isCorrect)',
      tag: AppLogTags.practiceCubit,
    );

    emit(
      state.copyWith(
        selectedOptionId: optionId,
        showResult: true,
        totalPoints: newPoints,
      ),
    );
  }

  /// Moves to the next question, or completes the quiz if on the last one.
  Future<void> nextQuestion() async {
    if (state.currentIndex < state.totalQuestions - 1) {
      emit(
        state.copyWith(
          currentIndex: state.currentIndex + 1,
          selectedOptionId: null,
          showResult: false,
        ),
      );
    } else {
      // All questions answered — mark quiz as completed.
      await _persistQuizCompletion();
      AppLogger.info(
        'Quiz completed — ${state.totalPoints} total points',
        tag: AppLogTags.practiceCubit,
      );
      emit(state.copyWith(status: PracticeStatus.completed, showResult: false));
    }
  }

  Future<void> _persistQuizCompletion() async {
    final boardId = state.boardId;
    final gradeId = state.gradeId;
    if (boardId == null || gradeId == null) {
      AppLogger.warning(
        'Skipping quiz completion persistence due to missing board/grade context',
        tag: AppLogTags.practiceCubit,
      );
      return;
    }

    final result = await _recordQuizCompletion(
      boardId: boardId,
      gradeId: gradeId,
      earnedPoints: state.totalPoints,
      answeredQuestions: state.totalQuestions,
    );

    if (result is Error<void>) {
      logFailure('recordQuizCompletion', result.failure);
      return;
    }

    _activityRefreshCubit.notifyProgressUpdated();
  }

  /// Resets the quiz for a replay.
  void resetQuiz() {
    AppLogger.info('Quiz reset requested', tag: AppLogTags.practiceCubit);
    final boardId = state.boardId;
    final gradeId = state.gradeId;
    emit(
      PracticeState(
        status: PracticeStatus.initial,
        boardId: boardId,
        gradeId: gradeId,
      ),
    );
    if (boardId != null && gradeId != null) {
      loadQuestions(boardId: boardId, gradeId: gradeId);
    }
  }
}
