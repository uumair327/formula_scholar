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
      repository = PracticeRepositoryImpl(dataSource: dataSource);
    });

    test('forwards quiz completion payload to data source', () async {
      final result = await repository.recordQuizCompletion(
        boardId: 'cbse',
        gradeId: 'class_9',
        earnedPoints: 20,
        answeredQuestions: 2,
      );

      expect(result, isA<Success<void>>());
      expect(dataSource.recordCallCount, 1);
      expect(dataSource.lastBoardId, 'cbse');
      expect(dataSource.lastGradeId, 'class_9');
      expect(dataSource.lastEarnedPoints, 20);
      expect(dataSource.lastAnsweredQuestions, 2);
    });
  });
}

class _FakePracticeDataSource implements PracticeDataSourcePort {
  int recordCallCount = 0;
  String? lastBoardId;
  String? lastGradeId;
  int? lastEarnedPoints;
  int? lastAnsweredQuestions;

  @override
  Future<List<QuizQuestion>> getQuestions({
    required String boardId,
    required String gradeId,
    String? subjectId,
  }) async {
    return const <QuizQuestion>[];
  }

  @override
  Future<void> recordQuizCompletion({
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
  }
}
