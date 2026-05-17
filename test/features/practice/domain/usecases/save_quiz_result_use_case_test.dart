import 'package:flutter_test/flutter_test.dart';

import 'package:formula_scholar/core/error/failures.dart';
import 'package:formula_scholar/core/error/result.dart';
import 'package:formula_scholar/features/practice/domain/domain.dart';

void main() {
  group('SaveQuizResultUseCase', () {
    test('delegates save to repository', () async {
      final repository = _FakePracticeRepository();
      final useCase = SaveQuizResultUseCase(repository: repository);
      const result = QuizResult(
        id: 'test_1',
        boardId: 'cbse',
        gradeId: 'class_9',
        totalQuestions: 5,
        correctCount: 4,
        incorrectCount: 1,
        totalPoints: 40,
        maxPoints: 50,
      );

      final response = await useCase(result);

      expect(response, isA<Success<void>>());
      expect(repository.saveCallCount, 1);
      expect(repository.lastSaved?.id, 'test_1');
    });

    test('returns Error when repository fails', () async {
      final repository = _FakePracticeRepository()
        ..saveResult = const Error<void>(
          UnexpectedFailure(message: 'save failed'),
        );
      final useCase = SaveQuizResultUseCase(repository: repository);
      const result = QuizResult(
        id: 'test_2',
        boardId: 'cbse',
        gradeId: 'class_9',
        totalQuestions: 3,
        correctCount: 2,
        incorrectCount: 1,
        totalPoints: 20,
        maxPoints: 30,
      );

      final response = await useCase(result);

      expect(response, isA<Error<void>>());
    });
  });
}

class _FakePracticeRepository implements PracticeRepositoryPort {
  int saveCallCount = 0;
  QuizResult? lastSaved;
  Result<void> saveResult = const Success<void>(null);

  @override
  Future<Result<void>> saveQuizResult(QuizResult result) async {
    saveCallCount++;
    lastSaved = result;
    return saveResult;
  }

  @override
  Future<Result<List<QuizQuestion>>> getQuestions({
    required String boardId,
    required String gradeId,
    String? subjectId,
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
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> saveAnswerRecords(List<QuizAnswerRecord> records) async {
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
