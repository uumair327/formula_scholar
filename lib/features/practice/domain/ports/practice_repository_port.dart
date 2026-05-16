import '../../../../core/error/result.dart';
import '../entities/quiz_answer_record.dart';
import '../entities/quiz_question.dart';

/// Port: Defines the contract for practice quiz data access.
///
/// Accepts curriculum identifiers to scope questions to the
/// user's selected board and grade.
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

  /// Persists per-question answer records for weak-area analysis.
  Future<Result<void>> saveAnswerRecords(List<QuizAnswerRecord> records);
}
