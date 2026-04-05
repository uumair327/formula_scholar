import '../entities/formula.dart';

/// Port: Driven port for formula data.
///
/// Any backend adapter (local, API, Firebase) must implement this.
/// The combination of [subjectId] and [chapterId] makes retrieval
/// chapter-specific within a subject.
abstract interface class FormulasDataSourcePort {
  /// Fetches all formulas for the given [chapterId] within [subjectId].
  Future<List<Formula>> getFormulas(String subjectId, String chapterId);

  /// Toggles the bookmark status of a formula for the current user.
  Future<void> toggleBookmark(Formula formula, String subjectName);
}
