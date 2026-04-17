import '../entities/bookmarked_formula.dart';
import '../entities/bookmarked_chapter.dart';
import '../entities/saved_note.dart';

/// Cache port for offline-first bookmarks access.
abstract interface class SavedCachePort {
  /// Persists bookmarks into local cache.
  Future<void> cacheBookmarks(List<BookmarkedFormula> bookmarks);

  /// Persists saved chapters into local cache.
  Future<void> cacheSavedChapters(List<BookmarkedChapter> chapters);

  /// Persists saved notes into local cache.
  Future<void> cacheSavedNotes(List<SavedNote> notes);

  /// Retrieves cached bookmarks. Returns empty list if none.
  Future<List<BookmarkedFormula>> getBookmarks();

  /// Retrieves cached saved chapters. Returns empty list if none.
  Future<List<BookmarkedChapter>> getSavedChapters();

  /// Retrieves cached saved notes. Returns empty list if none.
  Future<List<SavedNote>> getSavedNotes();
}
