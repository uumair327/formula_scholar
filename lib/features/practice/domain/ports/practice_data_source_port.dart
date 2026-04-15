import '../entities/quiz_question.dart';

/// Port: Driven port for quiz question data.
///
/// Accepts curriculum identifiers to scope questions to the
/// user's selected board and grade.
abstract interface class PracticeDataSourcePort {
  Future<List<QuizQuestion>> getQuestions({
    required String boardId,
    required String gradeId,
  });
}
