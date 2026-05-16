import '../entities/formula.dart';
import '../entities/formula_note.dart';

/// Port: Driven port for formula data.
///
/// Any backend adapter (local, API, Firebase) must implement this.
/// The combination of [subjectId] and [chapterId] makes retrieval
/// chapter-specific within a subject.
abstract interface class FormulasDataSourcePort {
  /// Fetches all formulas for the given [chapterId] within [subjectId].
  Future<List<Formula>> getFormulas(
    String subjectId,
    String chapterId, {
    String? curriculumKey,
  });

  /// Toggles the bookmark status of a formula for the current user.
  Future<void> toggleBookmark(
    Formula formula,
    String subjectName, {
    required String curriculumKey,
  });

  /// Marks chapter as started for the authenticated user.
  Future<void> markChapterStarted(
    String subjectId,
    String chapterId, {
    required String chapterName,
    required int totalFormulas,
  });

  /// Persists formula mastery state and aggregates chapter progress.
  Future<void> toggleFormulaMastery(
    String subjectId,
    String chapterId,
    String formulaId, {
    required bool isMastered,
    required int totalFormulas,
    required String chapterName,
  });

  /// Loads the user's note for a given formula.
  Future<FormulaNote?> getFormulaNote(String formulaId);

  /// Saves (creates or updates) the user's note for a formula.
  Future<void> saveFormulaNote(FormulaNote note);

  /// Deletes the user's note for a formula.
  Future<void> deleteFormulaNote(String formulaId);
}
