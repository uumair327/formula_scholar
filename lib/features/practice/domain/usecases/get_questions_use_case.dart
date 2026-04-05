import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/quiz_question.dart';
import '../ports/practice_repository_port.dart';

/// Fetches quiz questions for the practice session.
@injectable
class GetQuestionsUseCase {
  final PracticeRepositoryPort _repository;

  const GetQuestionsUseCase({required PracticeRepositoryPort repository})
    : _repository = repository;

  Future<Result<List<QuizQuestion>>> call() {
    AppLogger.trace(
      'GetQuestionsUseCase called',
      tag: AppLogTags.practiceCubit,
    );
    return _repository.getQuestions();
  }
}
