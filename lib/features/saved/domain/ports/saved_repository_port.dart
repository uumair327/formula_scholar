import '../../../../core/error/result.dart';
import '../entities/bookmarked_chapter.dart';
import '../entities/bookmarked_formula.dart';
import '../entities/saved_note.dart';
import '../entities/saved_query.dart';

/// Port: Defines the contract for saved/bookmarked formula access.
abstract interface class SavedRepositoryPort {
  Future<Result<List<BookmarkedFormula>>> getBookmarks({
    required String curriculumKey,
    SavedQuery query = const SavedQuery(),
  });
  Future<Result<List<BookmarkedChapter>>> getSavedChapters({
    required String curriculumKey,
    SavedQuery query = const SavedQuery(),
  });
  Future<Result<List<SavedNote>>> getSavedNotes({
    required String curriculumKey,
    SavedQuery query = const SavedQuery(),
  });
  Future<Result<void>> removeBookmark(String formulaId);
  Future<Result<void>> removeSavedChapter({
    required String curriculumKey,
    required String subjectId,
    required String chapterId,
  });
  Future<Result<void>> addNote(SavedNote note);
  Future<Result<void>> updateNote(SavedNote note);
  Future<Result<void>> deleteNote(String noteId);
}
