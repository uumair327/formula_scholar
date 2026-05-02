import '../../../../core/error/result.dart';
import '../entities/chapter.dart';
import '../entities/mastery_tool.dart';

/// Sort order for chapter queries (server-side authority).
enum ChaptersSortOrder { name, updated, custom }

/// Port: Primary hexagonal port for chapter data access.
///
/// Uses [Result] return type for typed error handling.
/// The [subjectId] parameter drives subject-specific content.
/// Sorting is server-side authoritative per golden rules.
abstract interface class ChaptersRepositoryPort {
  /// Fetches chapters for the given [subjectId].
  ///
  /// [sortBy] specifies the Firestore field to sort by (default: 'name').
  /// [sortDesc] specifies sort direction (default: false = ascending).
  Future<Result<List<Chapter>>> getChapters(
    String subjectId, {
    required String curriculumKey,
    String searchQuery = '',
    String sortBy = 'name',
    bool sortDesc = false,
  });

  /// Fetches backend-configured mastery tools for a subject.
  Future<Result<List<MasteryTool>>> getMasteryTools(String subjectId);

  /// Toggles the saved/bookmarked status of a chapter.
  ///
  /// Stores the saved state in Firestore under the user's curriculum.
  /// [chapter] is the chapter to toggle.
  /// [subjectName] is the subject the chapter belongs to.
  /// [subjectId] is the subject document id for strict scoping.
  /// [curriculumKey] is the user's curriculum identifier (boardId_gradeId).
  Future<Result<void>> toggleChapterBookmark(
    Chapter chapter,
    String subjectName, {
    required String subjectId,
    required String curriculumKey,
  });

  /// Returns whether a chapter is currently bookmarked/saved
  /// for the provided curriculum scope.
  Future<Result<bool>> isChapterBookmarked(
    String chapterId, {
    required String subjectId,
    required String curriculumKey,
  });
}
