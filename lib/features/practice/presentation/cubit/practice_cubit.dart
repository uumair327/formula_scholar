import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';
import '../../../achievements/domain/domain.dart';
import '../../../dashboard/domain/domain.dart';
import 'practice_state.dart';

@injectable
class PracticeCubit extends Cubit<PracticeState>
    with CubitFailureLogger<PracticeState> {
  PracticeCubit({
    required GetQuestionsUseCase getQuestions,
    required GetSubjectsUseCase getSubjects,
    required RecordQuizCompletionUseCase recordQuizCompletion,
    required SaveQuizResultUseCase saveQuizResult,
    required ActivityRefreshCubit activityRefreshCubit,
  }) : _getQuestions = getQuestions,
       _getSubjects = getSubjects,
       _recordQuizCompletion = recordQuizCompletion,
       _saveQuizResult = saveQuizResult,
       _activityRefreshCubit = activityRefreshCubit,
       super(const PracticeState());

  final GetQuestionsUseCase _getQuestions;
  final GetSubjectsUseCase _getSubjects;
  final RecordQuizCompletionUseCase _recordQuizCompletion;
  final SaveQuizResultUseCase _saveQuizResult;
  final ActivityRefreshCubit _activityRefreshCubit;
  Timer? _timer;
  String? _quizId;

  static String _generateId() =>
      'quiz_${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}';

  @override
  String get logTag => AppLogTags.practiceCubit;

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Future<void> loadSubjects(String boardId, String gradeId) async {
    if (state.isLoadingSubjects) return;

    emit(state.copyWith(isLoadingSubjects: true));

    final result = await _getSubjects(boardId, gradeId);

    switch (result) {
      case Success(:final data):
        final subjects = data
            .map(
              (s) => SelectedSubject(
                id: s.id,
                name: s.name,
                category: s.category,
                description: s.description,
                iconName: s.iconName,
                subtitle: s.subtitle ?? '',
              ),
            )
            .toList();

        emit(
          state.copyWith(availableSubjects: subjects, isLoadingSubjects: false),
        );
      case Error(:final failure):
        logFailure('loadSubjects', failure);
        emit(
          state.copyWith(
            isLoadingSubjects: false,
            errorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> loadQuestions({
    required String boardId,
    required String gradeId,
    String? subjectId,
    bool timedMode = false,
    int? durationSeconds,
    List<String>? questionIds,
  }) async {
    _timer?.cancel();
    _quizId = _generateId();
    emit(
      state.copyWith(
        status: PracticeStatus.loading,
        boardId: boardId,
        gradeId: gradeId,
        subjectId: subjectId,
        timedMode: timedMode,
        timerStatus: TimerStatus.idle,
        answerRecords: const [],
        quizStartTime: DateTime.now(),
      ),
    );

    final subject = state.availableSubjects
        .where((s) => s.id == subjectId)
        .firstOrNull;
    final categoryId = subject?.category;

    final result = await _getQuestions(
      boardId: boardId,
      gradeId: gradeId,
      subjectId: subjectId,
      categoryId: categoryId,
    );

    switch (result) {
      case Success(:final data):
        var questions = data;
        if (questionIds != null && questionIds.isNotEmpty) {
          questions = data.where((q) => questionIds.contains(q.id)).toList();
          if (questions.isEmpty) {
            questions = data;
          }
        }
        final totalSecs = durationSeconds ?? defaultTimeLimit(questions.length);
        emit(
          state.copyWith(
            status: PracticeStatus.loaded,
            questions: questions,
            totalSeconds: totalSecs,
            remainingSeconds: timedMode ? totalSecs : 0,
            timerStatus: timedMode ? TimerStatus.running : TimerStatus.idle,
          ),
        );
        if (timedMode) {
          _startTimer();
        }
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

  void setTimedMode(bool value) {
    emit(
      state.copyWith(
        selectedTimedMode: value,
        selectedTimedDurationSeconds: value
            ? state.selectedTimedDurationSeconds
            : null,
      ),
    );
  }

  void setTimedDuration(int? value) {
    emit(state.copyWith(selectedTimedDurationSeconds: value));
  }

  void selectOption(String optionId) {
    if (state.selectedOptionId != null) {
      return;
    }
    final question = state.currentQuestion;
    if (question == null) {
      return;
    }

    final isCorrect = optionId == question.correctOptionId;
    final newPoints = isCorrect
        ? state.totalPoints + question.points
        : state.totalPoints;

    final record = QuizAnswerRecord(
      questionId: question.id,
      category: question.category,
      topic: question.topic,
      selectedOptionId: optionId,
      correctOptionId: question.correctOptionId,
      isCorrect: isCorrect,
    );

    AppLogger.debug(
      'Option selected: $optionId (correct: $isCorrect)',
      tag: AppLogTags.practiceCubit,
    );

    emit(
      state.copyWith(
        selectedOptionId: optionId,
        showResult: true,
        totalPoints: newPoints,
        answerRecords: [...state.answerRecords, record],
      ),
    );
  }

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
    await _persistQuiz();
    AppLogger.info(
      'Quiz completed — ${state.totalPoints} points, ${state.correctCount}/${state.totalQuestions} correct',
      tag: AppLogTags.practiceCubit,
    );
    emit(state.copyWith(status: PracticeStatus.completed, showResult: false));
  }

  void onTimerExpired() {
    AppLogger.info(
      'Timer expired — auto-submitting quiz',
      tag: AppLogTags.practiceCubit,
    );
    emit(state.copyWith(timerStatus: TimerStatus.expired));
    _finishQuiz();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.showResult) return;

      if (state.remainingSeconds <= 1) {
        _timer?.cancel();
        onTimerExpired();
      } else {
        emit(state.copyWith(remainingSeconds: state.remainingSeconds - 1));
      }
    });
  }

  Future<void> _persistQuiz() async {
    final boardId = state.boardId;
    final gradeId = state.gradeId;
    if (boardId == null || gradeId == null) {
      return;
    }

    await _recordQuizCompletion(
      boardId: boardId,
      gradeId: gradeId,
      earnedPoints: state.totalPoints,
      answeredQuestions: state.totalQuestions,
      answerRecords: List.of(state.answerRecords),
    );
    final quizResult = QuizResult(
      id: _quizId ?? _generateId(),
      boardId: boardId,
      gradeId: gradeId,
      subjectId: state.subjectId,
      totalQuestions: state.totalQuestions,
      correctCount: state.correctCount,
      incorrectCount: state.incorrectCount,
      totalPoints: state.totalPoints,
      maxPoints: state.maxPoints,
      timedMode: state.timedMode,
      timeTakenSeconds: state.timeTakenSeconds,
      answers: List.of(state.answerRecords),
      completedAt: DateTime.now(),
    );
    final saveResult = await _saveQuizResult(quizResult);
    if (saveResult is Error<void>) {
      logFailure('saveQuizResult', saveResult.failure);
    }
    _activityRefreshCubit.notifyProgressUpdated();
    unawaited(_reportAchievementProgress());
  }

  Future<void> _reportAchievementProgress() async {
    try {
      final useCase = getIt<ReportAchievementProgressUseCase>();
      final correct = state.correctCount;
      await useCase('first_mastered', correct);
      await useCase('ten_mastered', correct);
      await useCase('fifty_mastered', correct);
    } catch (_) {
      AppLogger.warning(
        'Failed to report achievement progress',
        tag: AppLogTags.practiceCubit,
      );
    }
  }

  void retryIncorrect() {
    final ids = state.incorrectQuestionIds;
    if (ids.isEmpty) {
      return;
    }
    final boardId = state.boardId;
    final gradeId = state.gradeId;
    if (boardId == null || gradeId == null) {
      return;
    }
    loadQuestions(
      boardId: boardId,
      gradeId: gradeId,
      subjectId: state.subjectId,
      questionIds: ids,
    );
  }

  void resetQuiz() {
    _timer?.cancel();
    final bId = state.boardId;
    final gId = state.gradeId;

    // Clear subjectId so the user can pick a different subject.
    // We emit initial but DO NOT call loadQuestions.
    // This allows PracticePreFilter to be shown again!
    emit(
      state.copyWith(
        status: PracticeStatus.initial,
        boardId: bId,
        gradeId: gId,
        subjectId: null,
      ),
    );
  }

  void resetQuizWithCurriculum(String boardId, String gradeId) {
    _timer?.cancel();
    emit(
      state.copyWith(
        status: PracticeStatus.initial,
        boardId: boardId,
        gradeId: gradeId,
        subjectId: null,
        questions: const [],
        currentIndex: 0,
        selectedOptionId: null,
        showResult: false,
        totalPoints: 0,
        answerRecords: const [],
      ),
    );
  }
}
