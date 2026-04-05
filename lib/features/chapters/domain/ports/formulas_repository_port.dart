import '../../../../core/error/result.dart';
import '../entities/formula.dart';

/// Port: Primary hexagonal port for formula data access.
///
/// Uses [Result] return type for typed error handling.
abstract interface class FormulasRepositoryPort {
  /// Fetches formulas for the given [chapterId] within [subjectId].
  Future<Result<List<Formula>>> getFormulas(String subjectId, String chapterId);

  /// Toggles the bookmark status of a formula.
  Future<Result<void>> toggleBookmark(Formula formula, String subjectName);
}
