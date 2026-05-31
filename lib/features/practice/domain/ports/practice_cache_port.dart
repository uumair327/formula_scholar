import '../entities/quiz_question.dart';

/// Cache port for offline-first practice/quiz data access.
///
/// Follows the same pattern as [DashboardCachePort] and [ChaptersCachePort].
/// Implementations store/retrieve quiz questions from local storage (e.g. Hive)
/// so the app works offline for the practice/quiz flow.
abstract interface class PracticeCachePort {
  /// Persists quiz questions for a specific board/grade into local cache.
  Future<void> cacheQuestions(
    String curriculumKey,
    String? subjectId,
    String? categoryId,
    List<QuizQuestion> questions,
  );

  /// Retrieves cached quiz questions for a board/grade. Returns empty list if none.
  Future<List<QuizQuestion>> getQuestions(
    String curriculumKey,
    String? subjectId,
    String? categoryId,
  );
}
