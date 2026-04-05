import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Concrete implementation of [PracticeRepositoryPort].
@LazySingleton(as: PracticeRepositoryPort)
class PracticeRepositoryImpl implements PracticeRepositoryPort {
  final PracticeDataSourcePort _dataSource;

  const PracticeRepositoryImpl({required PracticeDataSourcePort dataSource})
    : _dataSource = dataSource;

  @override
  Future<Result<List<QuizQuestion>>> getQuestions() async {
    AppLogger.trace('getQuestions() called', tag: AppLogTags.practiceRepo);
    try {
      final result = await _dataSource.getQuestions();
      AppLogger.info(
        'getQuestions() succeeded: ${result.length} questions',
        tag: AppLogTags.practiceRepo,
      );
      return Success(result);
    } catch (e, stackTrace) {
      AppLogger.error(
        'getQuestions() failed',
        tag: AppLogTags.practiceRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(
        CacheFailure(
          message: 'Failed to load practice questions',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
