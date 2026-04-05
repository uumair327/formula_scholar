import '../entities/chapter.dart';

/// Port: Driven port for chapter data.
///
/// Any backend adapter (local, API, Firebase) must implement this.
/// The [subjectId] parameter makes data retrieval subject-aware.
abstract interface class ChaptersDataSourcePort {
  /// Fetches chapters/topics for the given [subjectId].
  Future<List<Chapter>> getChapters(String subjectId);
}
