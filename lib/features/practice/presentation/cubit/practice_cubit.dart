import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import 'practice_state.dart';

/// Cubit managing the Practice quiz screen's state.
///
/// Uses [CubitFailureLogger] mixin to eliminate error logging boilerplate.
@injectable
class PracticeCubit extends Cubit<PracticeState>
    with CubitFailureLogger<PracticeState> {
  final GetQuestionsUseCase _getQuestions;

  @override
  String get logTag => AppLogTags.practiceCubit;

  PracticeCubit({required GetQuestionsUseCase getQuestions})
    : _getQuestions = getQuestions,
      super(const PracticeState());

  /// Loads quiz questions.
  Future<void> loadQuestions() async {
    AppLogger.info('Loading practice questions', tag: AppLogTags.practiceCubit);
    emit(state.copyWith(status: PracticeStatus.loading));

    final result = await _getQuestions();

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

  /// Moves to the next question.
  void nextQuestion() {
    if (state.currentIndex < state.totalQuestions - 1) {
      emit(
        state.copyWith(currentIndex: state.currentIndex + 1, showResult: false),
      );
    }
  }
}
