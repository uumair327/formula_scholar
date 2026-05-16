import 'dart:async';

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
  Timer? _timer;
  final List<QuizAnswerRecord> _answerRecords = [];

  @override
  String get logTag => AppLogTags.practiceCubit;

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  /// Loads quiz questions.
  Future<void> loadQuestions({
    required String boardId,
    required String gradeId,
    String? subjectId,
    bool timedMode = false,
    int? durationSeconds,
  }) async {
    AppLogger.info('Loading practice questions', tag: AppLogTags.practiceCubit);
    _timer?.cancel();
    emit(
      state.copyWith(
        status: PracticeStatus.loading,
        boardId: boardId,
        gradeId: gradeId,
        subjectId: subjectId,
        timedMode: timedMode,
        timerStatus: TimerStatus.idle,
      ),
    );

    final result = await _getQuestions(
      boardId: boardId,
      gradeId: gradeId,
      subjectId: subjectId,
    );

    switch (result) {
      case Success(:final data):
        AppLogger.info(
          'Loaded ${data.length} questions',
          tag: AppLogTags.practiceCubit,
        );
        final totalSecs = durationSeconds ?? defaultTimeLimit(data.length);
        emit(state.copyWith(
          status: PracticeStatus.loaded,
          questions: data,
          totalSeconds: totalSecs,
          remainingSeconds: timedMode ? totalSecs : 0,
          timerStatus: timedMode ? TimerStatus.running : TimerStatus.idle,
        ));
        if (timedMode) _startTimer();
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
    if (state.selectedOptionId != null) return;

    final question = state.currentQuestion;
    if (question == null) return;

    final isCorrect = optionId == question.correctOptionId;
    final newPoints = isCorrect
        ? state.totalPoints + question.points
        : state.totalPoints;

    _answerRecords.add(QuizAnswerRecord(
      questionId: question.id,
      category: question.category,
      topic: question.topic,
      selectedOptionId: optionId,
      correctOptionId: question.correctOptionId,
      isCorrect: isCorrect,
    ));

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
      await _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    _timer?.cancel();
    await _persistQuizCompletion();
    _answerRecords.clear();
    AppLogger.info(
      'Quiz completed — ${state.totalPoints} total points',
      tag: AppLogTags.practiceCubit,
    );
    emit(state.copyWith(
      status: PracticeStatus.completed,
      showResult: false,
      timerStatus: TimerStatus.idle,
    ));
  }

  /// Called when the timer expires — auto-submits the quiz.
  void onTimerExpired() {
    AppLogger.info('Timer expired — auto-submitting quiz', tag: AppLogTags.practiceCubit);
    emit(state.copyWith(timerStatus: TimerStatus.expired));
    _finishQuiz();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remainingSeconds <= 1) {
        _timer?.cancel();
        onTimerExpired();
      } else {
        emit(state.copyWith(remainingSeconds: state.remainingSeconds - 1));
      }
    });
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
      answerRecords: List.of(_answerRecords),
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
    _timer?.cancel();
    _answerRecords.clear();
    final boardId = state.boardId;
    final gradeId = state.gradeId;
    final subjectId = state.subjectId;
    emit(
      PracticeState(
        status: PracticeStatus.initial,
        boardId: boardId,
        gradeId: gradeId,
        subjectId: subjectId,
      ),
    );
    if (boardId != null && gradeId != null) {
      loadQuestions(
        boardId: boardId,
        gradeId: gradeId,
        subjectId: subjectId,
      );
    }
  }
}
