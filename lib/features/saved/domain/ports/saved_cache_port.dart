import '../entities/bookmarked_formula.dart';

/// Cache port for offline-first bookmarks access.
abstract interface class SavedCachePort {
  /// Persists bookmarks into local cache.
  Future<void> cacheBookmarks(List<BookmarkedFormula> bookmarks);

  /// Retrieves cached bookmarks. Returns empty list if none.
  Future<List<BookmarkedFormula>> getBookmarks();
}
