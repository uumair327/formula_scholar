import '../../../../core/error/result.dart';
import '../entities/formula.dart';
import '../entities/formula_note.dart';

/// Port: Primary hexagonal port for formula data access.
///
/// Uses [Result] return type for typed error handling.
abstract interface class FormulasRepositoryPort {
  /// Fetches formulas for the given [chapterId] within [subjectId].
  Future<Result<List<Formula>>> getFormulas(
    String subjectId,
    String chapterId, {
    String? curriculumKey,
  });

  /// Toggles the bookmark status of a formula.
  Future<Result<void>> toggleBookmark(
    Formula formula,
    String subjectName, {
    required String curriculumKey,
  });

  /// Marks a chapter as started for the active user.
  Future<Result<void>> markChapterStarted(
    String subjectId,
    String chapterId, {
    required String chapterName,
    required int totalFormulas,
  });

  /// Toggles mastery for a single formula and updates chapter aggregates.
  Future<Result<void>> toggleFormulaMastery(
    String subjectId,
    String chapterId,
    String formulaId, {
    required bool isMastered,
    required int totalFormulas,
    required String chapterName,
  });

  /// Loads the user's note for a given formula.
  Future<Result<FormulaNote?>> getFormulaNote(String formulaId);

  /// Saves (creates or updates) the user's note for a formula.
  Future<Result<void>> saveFormulaNote(FormulaNote note);

  /// Deletes the user's note for a formula.
  Future<Result<void>> deleteFormulaNote(String formulaId);
}
