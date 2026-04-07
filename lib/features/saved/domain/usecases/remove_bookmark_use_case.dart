import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../domain.dart';

/// Use case to remove a bookmarked formula.
@injectable
class RemoveBookmarkUseCase {
  final SavedRepositoryPort _repository;

  RemoveBookmarkUseCase(this._repository);

  Future<Result<void>> call(String formulaId) {
    return _repository.removeBookmark(formulaId);
  }
}
