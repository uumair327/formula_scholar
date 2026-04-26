import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Concrete implementation of [PracticeRepositoryPort].
///
/// Uses [safeOperation] for DRY error handling.
/// Practice questions are relatively static content and could benefit
/// from a cache port in the future for offline quiz access.
@LazySingleton(as: PracticeRepositoryPort)
class PracticeRepositoryImpl implements PracticeRepositoryPort {
  const PracticeRepositoryImpl({required PracticeDataSourcePort dataSource})
    : _dataSource = dataSource;
  final PracticeDataSourcePort _dataSource;

  @override
  Future<Result<List<QuizQuestion>>> getQuestions({
    required String boardId,
    required String gradeId,
  }) {
    return safeOperation(
      tag: AppLogTags.practiceRepo,
      operation: 'getQuestions(board=$boardId, grade=$gradeId)',
      execute: () =>
          _dataSource.getQuestions(boardId: boardId, gradeId: gradeId),
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
}
