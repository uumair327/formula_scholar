import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../ports/practice_repository_port.dart';

/// Records quiz completion for analytics and profile progression.
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
  }) {
    AppLogger.trace(
      'RecordQuizCompletionUseCase called (board=$boardId, grade=$gradeId, points=$earnedPoints)',
      tag: AppLogTags.practiceUseCase,
    );

    return _repository.recordQuizCompletion(
      boardId: boardId,
      gradeId: gradeId,
      earnedPoints: earnedPoints,
      answeredQuestions: answeredQuestions,
    );
  }
}
