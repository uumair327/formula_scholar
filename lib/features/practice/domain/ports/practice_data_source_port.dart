import '../entities/quiz_answer_record.dart';
import '../entities/quiz_question.dart';

/// Port: Driven port for quiz question data.
///
/// Accepts curriculum identifiers to scope questions to the
/// user's selected board and grade.
abstract interface class PracticeDataSourcePort {
  Future<List<QuizQuestion>> getQuestions({
    required String boardId,
    required String gradeId,
    String? subjectId,
  });

  /// Persists quiz completion analytics for the active user.
  Future<void> recordQuizCompletion({
    required String boardId,
    required String gradeId,
    required int earnedPoints,
    required int answeredQuestions,
  });

  /// Persists per-question answer records for weak-area analysis.
  Future<void> saveAnswerRecords(List<QuizAnswerRecord> records);
}
