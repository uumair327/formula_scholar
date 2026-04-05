import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/chapter.dart';
import '../ports/chapters_repository_port.dart';

/// Fetches chapters for a given subject.
///
/// Single-responsibility use case following SOLID principles.
/// The [subjectId] parameter makes this use case fully generic –
/// the same use case serves Geometry, Algebra, Physics, etc.
@injectable
class GetChaptersUseCase {
  final ChaptersRepositoryPort _repository;

  const GetChaptersUseCase({required ChaptersRepositoryPort repository})
    : _repository = repository;

  /// Executes the use case for the given [subjectId].
  Future<Result<List<Chapter>>> call(String subjectId) {
    AppLogger.trace(
      'GetChaptersUseCase called for subject=$subjectId',
      tag: AppLogTags.chaptersCubit,
    );
    return _repository.getChapters(subjectId);
  }
}
