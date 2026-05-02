import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/chapter.dart';
import '../ports/chapters_repository_port.dart';

/// Fetches chapters for a given subject.
///
/// Single-responsibility use case following SOLID principles.
/// The [subjectId] parameter makes this use case fully generic –
/// the same use case serves Geometry, Algebra, Physics, etc.
/// Sorting is server-side authoritative per golden rules.
@injectable
class GetChaptersUseCase {
  const GetChaptersUseCase({required ChaptersRepositoryPort repository})
    : _repository = repository;
  final ChaptersRepositoryPort _repository;

  /// Executes the use case for the given [subjectId].
  ///
  /// [sortBy] specifies Firestore field to sort by (default: 'name').
  /// [sortDesc] specifies sort direction (default: false = ascending).
  Future<Result<List<Chapter>>> call(
    String subjectId, {
    required String curriculumKey,
    String searchQuery = '',
    String sortBy = 'name',
    bool sortDesc = false,
  }) {
    AppLogger.trace(
      'GetChaptersUseCase called for subject=$subjectId, curriculum=$curriculumKey, sortBy=$sortBy, sortDesc=$sortDesc',
      tag: AppLogTags.chaptersUseCase,
    );
    return _repository.getChapters(
      subjectId,
      curriculumKey: curriculumKey,
      searchQuery: searchQuery,
      sortBy: sortBy,
      sortDesc: sortDesc,
    );
  }
}
