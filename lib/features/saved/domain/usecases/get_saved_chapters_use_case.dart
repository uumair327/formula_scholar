import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/bookmarked_chapter.dart';
import '../ports/saved_repository_port.dart';

/// Fetches saved chapters for the active curriculum.
@injectable
class GetSavedChaptersUseCase {
  final SavedRepositoryPort _repository;

  const GetSavedChaptersUseCase({required SavedRepositoryPort repository})
    : _repository = repository;

  Future<Result<List<BookmarkedChapter>>> call({
    required String curriculumKey,
  }) {
    AppLogger.trace(
      'GetSavedChaptersUseCase called',
      tag: AppLogTags.savedUseCase,
    );
    return _repository.getSavedChapters(curriculumKey: curriculumKey);
  }
}
