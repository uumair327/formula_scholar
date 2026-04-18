import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/bookmarked_formula.dart';
import '../ports/saved_repository_port.dart';

/// Fetches saved/bookmarked formulas.
@injectable
class GetBookmarksUseCase {

  const GetBookmarksUseCase({required SavedRepositoryPort repository})
    : _repository = repository;
  final SavedRepositoryPort _repository;

  Future<Result<List<BookmarkedFormula>>> call({required String curriculumKey}) {
    AppLogger.trace('GetBookmarksUseCase called', tag: AppLogTags.savedUseCase);
    return _repository.getBookmarks(curriculumKey: curriculumKey);
  }
}
