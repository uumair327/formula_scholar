import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/quiz_result.dart';
import '../ports/practice_repository_port.dart';

/// Persists a completed quiz result for history and analytics.
@injectable
class SaveQuizResultUseCase {
  const SaveQuizResultUseCase({required PracticeRepositoryPort repository})
    : _repository = repository;
  final PracticeRepositoryPort _repository;

  Future<Result<void>> call(QuizResult result) {
    AppLogger.trace(
      'SaveQuizResultUseCase called (id=${result.id})',
      tag: AppLogTags.practiceUseCase,
    );
    return _repository.saveQuizResult(result);
  }
}
