import 'package:flutter_test/flutter_test.dart';

import 'package:formula_scholar/core/error/failures.dart';
import 'package:formula_scholar/core/error/result.dart';
import 'package:formula_scholar/features/practice/domain/domain.dart';

void main() {
  group('GetRecentQuizResultsUseCase', () {
    test('returns quiz results from repository', () async {
      final repository = _FakePracticeRepository();
      final useCase = GetRecentQuizResultsUseCase(repository: repository);
      final results = [
        const QuizResult(
          id: 'r1',
          boardId: 'cbse',
          gradeId: 'class_9',
          totalQuestions: 10,
          correctCount: 8,
          incorrectCount: 2,
          totalPoints: 80,
          maxPoints: 100,
        ),
      ];
      repository.getResult = Success<List<QuizResult>>(results);

      final result = await useCase(limit: 10);

      expect(result, isA<Success<List<QuizResult>>>());
      expect(repository.getCallCount, 1);
      expect(repository.lastLimit, 10);
      final data = (result as Success<List<QuizResult>>).data;
      expect(data.length, 1);
      expect(data.first.id, 'r1');
    });

    test('returns Error when repository fails', () async {
      final repository = _FakePracticeRepository()
        ..getResult = const Error<List<QuizResult>>(
          UnexpectedFailure(message: 'fetch failed'),
        );
      final useCase = GetRecentQuizResultsUseCase(repository: repository);

      final result = await useCase(limit: 5);

      expect(result, isA<Error<List<QuizResult>>>());
    });
  });
}

class _FakePracticeRepository implements PracticeRepositoryPort {
  int getCallCount = 0;
  int? lastLimit;
  Result<List<QuizResult>> getResult = const Success<List<QuizResult>>(<QuizResult>[]);

  @override
  Future<Result<List<QuizResult>>> getQuizResults({int limit = 20}) async {
    getCallCount++;
    lastLimit = limit;
    return getResult;
  }

  @override
  Future<Result<List<QuizResult>>> getRecentQuizResults({int limit = 5}) async {
    getCallCount++;
    lastLimit = limit;
    return getResult;
  }

  @override
  Future<Result<List<QuizQuestion>>> getQuestions({
    required String curriculumKey,
    String? subjectId,
    String? categoryId,
  }) async {
    return const Success<List<QuizQuestion>>(<QuizQuestion>[]);
  }

  @override
  Future<Result<void>> recordQuizCompletion({
    required String curriculumKey,
    required int earnedPoints,
    required int answeredQuestions,
  }) async {
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> saveAnswerRecords(List<QuizAnswerRecord> records) async {
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> saveQuizResult(QuizResult result) async {
    return const Success<void>(null);
  }
}
