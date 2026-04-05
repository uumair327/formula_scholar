import '../../../../core/error/result.dart';
import '../entities/bookmarked_formula.dart';

/// Port: Defines the contract for saved/bookmarked formula access.
abstract interface class SavedRepositoryPort {
  Future<Result<List<BookmarkedFormula>>> getBookmarks();
  Future<Result<void>> removeBookmark(String formulaId);
}
