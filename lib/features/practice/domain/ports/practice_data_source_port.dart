import '../entities/quiz_question.dart';

/// Port: Driven port for quiz question data.
abstract interface class PracticeDataSourcePort {
  Future<List<QuizQuestion>> getQuestions();
}
