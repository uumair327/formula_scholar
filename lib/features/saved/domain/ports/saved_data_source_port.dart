import '../entities/bookmarked_formula.dart';

/// Port: Driven port for bookmark data.
abstract interface class SavedDataSourcePort {
  Future<List<BookmarkedFormula>> getBookmarks();
  Future<void> removeBookmark(String formulaId);
}
