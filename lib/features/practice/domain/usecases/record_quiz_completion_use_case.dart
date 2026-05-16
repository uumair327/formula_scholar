import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/quiz_answer_record.dart';
import '../ports/practice_repository_port.dart';

/// Records quiz completion for analytics and weak-area tracking.
@injectable
class RecordQuizCompletionUseCase {
  const RecordQuizCompletionUseCase({
    required PracticeRepositoryPort repository,
  }) : _repository = repository;

  final PracticeRepositoryPort _repository;

  Future<Result<void>> call({
    required String boardId,
    required String gradeId,
    required int earnedPoints,
    required int answeredQuestions,
    List<QuizAnswerRecord> answerRecords = const [],
  }) async {
    AppLogger.trace(
      'RecordQuizCompletionUseCase called (board=$boardId, grade=$gradeId, points=$earnedPoints)',
      tag: AppLogTags.practiceUseCase,
    );

    final completionResult = await _repository.recordQuizCompletion(
      boardId: boardId,
      gradeId: gradeId,
      earnedPoints: earnedPoints,
      answeredQuestions: answeredQuestions,
    );

    if (completionResult is Error<void>) return completionResult;

    if (answerRecords.isNotEmpty) {
      return _repository.saveAnswerRecords(answerRecords);
    }

    return completionResult;
  }
}
