import '../entities/bookmarked_formula.dart';
import '../entities/bookmarked_chapter.dart';
import '../entities/saved_note.dart';
import '../entities/saved_query.dart';

/// Port: Driven port for bookmark data.
abstract interface class SavedDataSourcePort {
  Future<List<BookmarkedFormula>> getBookmarks({
    required String curriculumKey,
    SavedQuery query = const SavedQuery(),
  });
  Future<List<BookmarkedChapter>> getSavedChapters({
    required String curriculumKey,
    SavedQuery query = const SavedQuery(),
  });
  Future<List<SavedNote>> getSavedNotes({
    required String curriculumKey,
    SavedQuery query = const SavedQuery(),
  });
  Future<void> removeBookmark(String formulaId);
  Future<void> removeSavedChapter({
    required String curriculumKey,
    required String subjectId,
    required String chapterId,
  });
}
