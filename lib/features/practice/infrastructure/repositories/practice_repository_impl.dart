import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

/// Concrete implementation of [PracticeRepositoryPort].
///
/// Uses [safeOperation] for DRY error handling with [PracticeCachePort]
/// fallback for offline-first behaviour when the backend is unreachable.
@LazySingleton(as: PracticeRepositoryPort)
class PracticeRepositoryImpl implements PracticeRepositoryPort {
  const PracticeRepositoryImpl({
    required PracticeDataSourcePort dataSource,
    required PracticeCachePort cache,
  }) : _dataSource = dataSource,
       _cache = cache;

  final PracticeDataSourcePort _dataSource;
  final PracticeCachePort _cache;

  @override
  Future<Result<List<QuizQuestion>>> getQuestions({
    required String boardId,
    required String gradeId,
    String? subjectId,
    String? categoryId,
  }) {
    return safeOperation(
      tag: AppLogTags.practiceRepo,
      operation:
          'getQuestions(board=$boardId, grade=$gradeId, subject=$subjectId)',
      execute: () async {
        final result = await _dataSource.getQuestions(
          boardId: boardId,
          gradeId: gradeId,
          subjectId: subjectId,
          categoryId: categoryId,
        );
        await _cache.cacheQuestions(
          boardId,
          gradeId,
          subjectId,
          categoryId,
          result,
        );
        return result;
      },
      fallback: () async {
        final cached = await _cache.getQuestions(
          boardId,
          gradeId,
          subjectId,
          categoryId,
        );
        return cached.isNotEmpty ? cached : null;
      },
    );
  }

  @override
  Future<Result<void>> recordQuizCompletion({
    required String boardId,
    required String gradeId,
    required int earnedPoints,
    required int answeredQuestions,
  }) {
    return safeOperation(
      tag: AppLogTags.practiceRepo,
      operation:
          'recordQuizCompletion(board=$boardId, grade=$gradeId, points=$earnedPoints)',
      execute: () => _dataSource.recordQuizCompletion(
        boardId: boardId,
        gradeId: gradeId,
        earnedPoints: earnedPoints,
        answeredQuestions: answeredQuestions,
      ),
    );
  }

  @override
  Future<Result<void>> saveAnswerRecords(List<QuizAnswerRecord> records) {
    return safeOperation(
      tag: AppLogTags.practiceRepo,
      operation: 'saveAnswerRecords(${records.length} records)',
      execute: () => _dataSource.saveAnswerRecords(records),
    );
  }

  @override
  Future<Result<void>> saveQuizResult(QuizResult result) {
    return safeOperation(
      tag: AppLogTags.practiceRepo,
      operation: 'saveQuizResult(${result.id})',
      execute: () => _dataSource.saveQuizResult(result),
    );
  }

  @override
  Future<Result<List<QuizResult>>> getQuizResults({int limit = 20}) {
    return safeOperation(
      tag: AppLogTags.practiceRepo,
      operation: 'getQuizResults(limit=$limit)',
      execute: () => _dataSource.getQuizResults(limit: limit),
    );
  }

  @override
  Future<Result<List<QuizResult>>> getRecentQuizResults({int limit = 5}) {
    return safeOperation(
      tag: AppLogTags.practiceRepo,
      operation: 'getRecentQuizResults(limit=$limit)',
      execute: () => _dataSource.getRecentQuizResults(limit: limit),
    );
  }
}
