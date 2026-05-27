import 'package:flutter_test/flutter_test.dart';

import 'package:formula_scholar/core/error/failures.dart';
import 'package:formula_scholar/core/error/result.dart';
import 'package:formula_scholar/features/practice/domain/domain.dart';

void main() {
  group('RecordQuizCompletionUseCase', () {
    test('delegates completion tracking to repository', () async {
      final repository = _FakePracticeRepository();
      final useCase = RecordQuizCompletionUseCase(repository: repository);

      final result = await useCase(
        boardId: 'cbse',
        gradeId: 'class_9',
        earnedPoints: 30,
        answeredQuestions: 3,
      );

      expect(result, isA<Success<void>>());
      expect(repository.recordCallCount, 1);
      expect(repository.lastBoardId, 'cbse');
      expect(repository.lastGradeId, 'class_9');
      expect(repository.lastEarnedPoints, 30);
      expect(repository.lastAnsweredQuestions, 3);
    });

    test('returns Error when repository fails', () async {
      final repository = _FakePracticeRepository()
        ..recordResult = const Error<void>(
          UnexpectedFailure(message: 'tracking failed'),
        );
      final useCase = RecordQuizCompletionUseCase(repository: repository);

      final result = await useCase(
        boardId: 'cbse',
        gradeId: 'class_9',
        earnedPoints: 10,
        answeredQuestions: 1,
      );

      expect(result, isA<Error<void>>());
    });
  });
}

class _FakePracticeRepository implements PracticeRepositoryPort {
  int recordCallCount = 0;
  String? lastBoardId;
  String? lastGradeId;
  int? lastEarnedPoints;
  int? lastAnsweredQuestions;

  Result<void> recordResult = const Success<void>(null);

  @override
  Future<Result<List<QuizQuestion>>> getQuestions({
    required String boardId,
    required String gradeId,
    String? subjectId,
    String? categoryId,
  }) async {
    return const Success<List<QuizQuestion>>(<QuizQuestion>[]);
  }

  @override
  Future<Result<void>> recordQuizCompletion({
    required String boardId,
    required String gradeId,
    required int earnedPoints,
    required int answeredQuestions,
  }) async {
    recordCallCount += 1;
    lastBoardId = boardId;
    lastGradeId = gradeId;
    lastEarnedPoints = earnedPoints;
    lastAnsweredQuestions = answeredQuestions;
    return recordResult;
  }

  @override
  Future<Result<void>> saveAnswerRecords(List<QuizAnswerRecord> records) async {
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> saveQuizResult(QuizResult result) async {
    return const Success<void>(null);
  }

  @override
  Future<Result<List<QuizResult>>> getQuizResults({int limit = 20}) async {
    return const Success<List<QuizResult>>(<QuizResult>[]);
  }

  @override
  Future<Result<List<QuizResult>>> getRecentQuizResults({int limit = 5}) async {
    return const Success<List<QuizResult>>(<QuizResult>[]);
  }
}
