import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/quiz_result.dart';
import '../ports/practice_repository_port.dart';

/// Fetches recent quiz results for the practice history view.
@injectable
class GetRecentQuizResultsUseCase {
  const GetRecentQuizResultsUseCase({required PracticeRepositoryPort repository})
    : _repository = repository;
  final PracticeRepositoryPort _repository;

  Future<Result<List<QuizResult>>> call({int limit = 20}) {
    AppLogger.trace(
      'GetRecentQuizResultsUseCase called (limit=$limit)',
      tag: AppLogTags.practiceUseCase,
    );
    return _repository.getQuizResults(limit: limit);
  }
}
