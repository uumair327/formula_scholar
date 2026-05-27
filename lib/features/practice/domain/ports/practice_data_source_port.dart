import '../entities/quiz_answer_record.dart';
import '../entities/quiz_question.dart';
import '../entities/quiz_result.dart';

/// Port: Driven port for quiz question data.
abstract interface class PracticeDataSourcePort {
  Future<List<QuizQuestion>> getQuestions({
    required String boardId,
    required String gradeId,
    String? subjectId,
    String? categoryId,
  });

  Future<void> recordQuizCompletion({
    required String boardId,
    required String gradeId,
    required int earnedPoints,
    required int answeredQuestions,
  });

  Future<void> saveAnswerRecords(List<QuizAnswerRecord> records);

  Future<void> saveQuizResult(QuizResult result);

  Future<List<QuizResult>> getQuizResults({int limit = 20});

  Future<List<QuizResult>> getRecentQuizResults({int limit = 5});
}
