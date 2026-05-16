import '../../../../core/error/result.dart';
import '../entities/quiz_answer_record.dart';
import '../entities/quiz_question.dart';
import '../entities/quiz_result.dart';

/// Port: Defines the contract for practice quiz data access.
abstract interface class PracticeRepositoryPort {
  Future<Result<List<QuizQuestion>>> getQuestions({
    required String boardId,
    required String gradeId,
    String? subjectId,
  });

  Future<Result<void>> recordQuizCompletion({
    required String boardId,
    required String gradeId,
    required int earnedPoints,
    required int answeredQuestions,
  });

  Future<Result<void>> saveAnswerRecords(List<QuizAnswerRecord> records);

  Future<Result<void>> saveQuizResult(QuizResult result);

  Future<Result<List<QuizResult>>> getQuizResults({int limit = 20});

  Future<Result<List<QuizResult>>> getRecentQuizResults({int limit = 5});
}
