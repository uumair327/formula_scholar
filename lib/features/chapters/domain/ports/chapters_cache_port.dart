import '../entities/chapter.dart';

/// Cache port for offline-first chapter data access.
///
/// Mirrors the [DashboardCachePort] pattern — implementations store/retrieve
/// chapters from local storage (e.g. Hive) so the app works offline.
abstract interface class ChaptersCachePort {
  /// Persists chapters for a specific subject into local cache.
  Future<void> cacheChapters(String subjectId, List<Chapter> chapters);

  /// Retrieves cached chapters for a subject. Returns empty list if none.
  Future<List<Chapter>> getChapters(String subjectId);
}
