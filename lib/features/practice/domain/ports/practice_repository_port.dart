import '../../../../core/error/result.dart';
import '../entities/quiz_question.dart';

/// Port: Defines the contract for practice quiz data access.
abstract interface class PracticeRepositoryPort {
  Future<Result<List<QuizQuestion>>> getQuestions();
}
