import '../entities/chapter.dart';
import '../entities/mastery_tool.dart';

/// Port: Driven port for chapter data.
///
/// Any backend adapter (local, API, Firebase) must implement this.
/// The [subjectId] parameter makes data retrieval subject-aware.
abstract interface class ChaptersDataSourcePort {
  /// Fetches chapters/topics for the given [subjectId].
  Future<List<Chapter>> getChapters(String subjectId, String curriculumKey);

  /// Fetches backend-configured mastery tools for [subjectId].
  Future<List<MasteryTool>> getMasteryTools(String subjectId);

  /// Toggles the saved/bookmarked status of a chapter.
  ///
  /// Stores the saved state in Firestore under the user's curriculum.
  Future<void> toggleChapterBookmark(
    Chapter chapter,
    String subjectName,
    String subjectId,
    String curriculumKey,
  );

  /// Returns whether [chapterId] is saved for [curriculumKey].
  Future<bool> isChapterBookmarked(
    String chapterId,
    String subjectId,
    String curriculumKey,
  );
}
