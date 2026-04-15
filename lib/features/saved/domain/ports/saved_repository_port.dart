import '../../../../core/error/result.dart';
import '../entities/bookmarked_chapter.dart';
import '../entities/bookmarked_formula.dart';

/// Port: Defines the contract for saved/bookmarked formula access.
abstract interface class SavedRepositoryPort {
  Future<Result<List<BookmarkedFormula>>> getBookmarks({
    required String curriculumKey,
  });
  Future<Result<List<BookmarkedChapter>>> getSavedChapters({
    required String curriculumKey,
  });
  Future<Result<void>> removeBookmark(String formulaId);
  Future<Result<void>> removeSavedChapter({
    required String curriculumKey,
    required String subjectId,
    required String chapterId,
  });
}
