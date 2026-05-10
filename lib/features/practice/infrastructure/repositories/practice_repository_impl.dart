import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

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
  }) {
    return safeOperation(
      tag: AppLogTags.practiceRepo,
      operation: 'getQuestions(board=$boardId, grade=$gradeId, subject=$subjectId)',
      execute: () async {
        final result = await _dataSource.getQuestions(
          boardId: boardId,
          gradeId: gradeId,
          subjectId: subjectId,
        );
        await _cache.cacheQuestions(boardId, gradeId, subjectId, result);
        return result;
      },
      fallback: () async {
        final cached = await _cache.getQuestions(boardId, gradeId, subjectId);
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
      operation: 'recordQuizCompletion(board=$boardId, grade=$gradeId, points=$earnedPoints)',
      execute: () => _dataSource.recordQuizCompletion(
        boardId: boardId,
        gradeId: gradeId,
        earnedPoints: earnedPoints,
        answeredQuestions: answeredQuestions,
      ),
    );
  }
}
