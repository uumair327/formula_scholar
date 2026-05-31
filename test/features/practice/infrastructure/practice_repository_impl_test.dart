import 'package:flutter_test/flutter_test.dart';

import 'package:formula_scholar/core/error/result.dart';
import 'package:formula_scholar/features/practice/domain/domain.dart';
import 'package:formula_scholar/features/practice/infrastructure/repositories/practice_repository_impl.dart';

void main() {
  group('PracticeRepositoryImpl', () {
    late _FakePracticeDataSource dataSource;
    late PracticeRepositoryPort repository;

    setUp(() {
      dataSource = _FakePracticeDataSource();
      repository = PracticeRepositoryImpl(dataSource: dataSource, cache: _FakePracticeCache());
    });

    test('forwards quiz completion payload to data source', () async {
      final result = await repository.recordQuizCompletion(
        curriculumKey: 'cbse_class_9',
        earnedPoints: 20,
        answeredQuestions: 2,
      );

      expect(result, isA<Success<void>>());
      expect(dataSource.recordCallCount, 1);
      expect(dataSource.lastCurriculumKey, 'cbse_class_9');
      expect(dataSource.lastEarnedPoints, 20);
      expect(dataSource.lastAnsweredQuestions, 2);
    });
  });
}

class _FakePracticeDataSource implements PracticeDataSourcePort {
  int recordCallCount = 0;
  String? lastCurriculumKey;
  int? lastEarnedPoints;
  int? lastAnsweredQuestions;

  @override
  Future<List<QuizQuestion>> getQuestions({
    required String curriculumKey,
    String? subjectId,
    String? categoryId,
  }) async {
    return const <QuizQuestion>[];
  }

  @override
  Future<void> recordQuizCompletion({
    required String curriculumKey,
    required int earnedPoints,
    required int answeredQuestions,
  }) async {
    recordCallCount += 1;
    lastCurriculumKey = curriculumKey;
    lastEarnedPoints = earnedPoints;
    lastAnsweredQuestions = answeredQuestions;
  }

  @override
  Future<void> saveAnswerRecords(List<QuizAnswerRecord> records) async {}

  @override
  Future<void> saveQuizResult(QuizResult result) async {}

  @override
  Future<List<QuizResult>> getQuizResults({int limit = 20}) async {
    return const <QuizResult>[];
  }

  @override
  Future<List<QuizResult>> getRecentQuizResults({int limit = 5}) async {
    return const <QuizResult>[];
  }
}

class _FakePracticeCache implements PracticeCachePort {
  @override
  Future<void> cacheQuestions(
    String curriculumKey,
    String? subjectId,
    String? categoryId,
    List<QuizQuestion> questions,
  ) async {}

  @override
  Future<List<QuizQuestion>> getQuestions(
    String curriculumKey,
    String? subjectId,
    String? categoryId,
  ) async {
    return const <QuizQuestion>[];
  }
}
