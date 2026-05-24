import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../domain/entities/quiz_result.dart';
import '../../domain/usecases/get_recent_quiz_results_use_case.dart';

enum PracticeHistoryStatus { initial, loading, loaded, error }

class PracticeHistoryState extends Equatable {
  const PracticeHistoryState({
    this.status = PracticeHistoryStatus.initial,
    this.results = const [],
    this.errorMessage,
  });

  final PracticeHistoryStatus status;
  final List<QuizResult> results;
  final String? errorMessage;

  PracticeHistoryState copyWith({
    PracticeHistoryStatus? status,
    List<QuizResult>? results,
    String? errorMessage,
  }) =>
      PracticeHistoryState(
        status: status ?? this.status,
        results: results ?? this.results,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [status, results, errorMessage];
}

@injectable
class PracticeHistoryCubit extends Cubit<PracticeHistoryState>
    with CubitFailureLogger<PracticeHistoryState> {
  PracticeHistoryCubit({
    required GetRecentQuizResultsUseCase getRecentQuizResults,
  }) : _getRecentQuizResults = getRecentQuizResults,
       super(const PracticeHistoryState());

  final GetRecentQuizResultsUseCase _getRecentQuizResults;

  @override
  String get logTag => AppLogTags.practiceHistoryCubit;

  Future<void> loadHistory({int limit = 50}) async {
    emit(state.copyWith(status: PracticeHistoryStatus.loading));

    final result = await _getRecentQuizResults(limit: limit);
    switch (result) {
      case Success(:final data):
        emit(state.copyWith(
          status: PracticeHistoryStatus.loaded,
          results: data,
        ));
      case Error(:final failure):
        logFailure('loadHistory', failure);
        emit(state.copyWith(
          status: PracticeHistoryStatus.error,
          errorMessage: failure.message,
        ));
    }
  }
}
