import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/quiz_question.dart';
import '../ports/practice_repository_port.dart';

/// Fetches quiz questions for the practice session,
/// scoped to the user's selected curriculum (board + grade).
@injectable
class GetQuestionsUseCase {
  final PracticeRepositoryPort _repository;

  const GetQuestionsUseCase({required PracticeRepositoryPort repository})
    : _repository = repository;

  Future<Result<List<QuizQuestion>>> call({
    required String boardId,
    required String gradeId,
  }) {
    AppLogger.trace(
      'GetQuestionsUseCase called (board=$boardId, grade=$gradeId)',
      tag: AppLogTags.practiceUseCase,
    );
    return _repository.getQuestions(boardId: boardId, gradeId: gradeId);
  }
}
