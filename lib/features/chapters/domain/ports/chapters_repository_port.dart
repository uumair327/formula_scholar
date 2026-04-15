import '../../../../core/error/result.dart';
import '../entities/chapter.dart';
import '../entities/mastery_tool.dart';

/// Port: Primary hexagonal port for chapter data access.
///
/// Uses [Result] return type for typed error handling.
/// The [subjectId] parameter drives subject-specific content.
abstract interface class ChaptersRepositoryPort {
  /// Fetches chapters for the given [subjectId].
  Future<Result<List<Chapter>>> getChapters(
    String subjectId, {
    required String curriculumKey,
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
