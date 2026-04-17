import '../entities/bookmarked_formula.dart';
import '../entities/bookmarked_chapter.dart';
import '../entities/saved_note.dart';

/// Port: Driven port for bookmark data.
abstract interface class SavedDataSourcePort {
  Future<List<BookmarkedFormula>> getBookmarks({required String curriculumKey});
  Future<List<BookmarkedChapter>> getSavedChapters({
    required String curriculumKey,
  });
  Future<List<SavedNote>> getSavedNotes({required String curriculumKey});
  Future<void> removeBookmark(String formulaId);
  Future<void> removeSavedChapter({
    required String curriculumKey,
    required String subjectId,
    required String chapterId,
  });
}
