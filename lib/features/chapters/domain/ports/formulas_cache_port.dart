import '../entities/formula.dart';

/// Cache port for offline-first formula data access.
///
/// Follows the same pattern as [ChaptersCachePort] and [DashboardCachePort].
/// Implementations store/retrieve formulas from local storage (e.g. Hive)
/// so the app works offline for the formulas browsing flow.
abstract interface class FormulasCachePort {
  /// Persists formulas for a specific chapter into local cache.
  Future<void> cacheFormulas(
    String subjectId,
    String chapterId,
    String curriculumKey,
    List<Formula> formulas,
  );

  /// Retrieves cached formulas for a chapter. Returns empty list if none.
  Future<List<Formula>> getFormulas(
    String subjectId,
    String chapterId,
    String curriculumKey,
  );
}
