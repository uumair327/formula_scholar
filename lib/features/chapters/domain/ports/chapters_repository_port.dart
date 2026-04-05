import '../../../../core/error/result.dart';
import '../entities/chapter.dart';

/// Port: Primary hexagonal port for chapter data access.
///
/// Uses [Result] return type for typed error handling.
/// The [subjectId] parameter drives subject-specific content.
abstract interface class ChaptersRepositoryPort {
  /// Fetches chapters for the given [subjectId].
  Future<Result<List<Chapter>>> getChapters(String subjectId);
}
