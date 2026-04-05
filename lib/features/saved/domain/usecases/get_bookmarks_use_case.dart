import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/bookmarked_formula.dart';
import '../ports/saved_repository_port.dart';

/// Fetches saved/bookmarked formulas.
@injectable
class GetBookmarksUseCase {
  final SavedRepositoryPort _repository;

  const GetBookmarksUseCase({required SavedRepositoryPort repository})
    : _repository = repository;

  Future<Result<List<BookmarkedFormula>>> call() {
    AppLogger.trace('GetBookmarksUseCase called', tag: AppLogTags.savedCubit);
    return _repository.getBookmarks();
  }
}
