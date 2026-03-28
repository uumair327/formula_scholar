import '../../../../core/error/result.dart';
import '../entities/formula.dart';

/// Port: Defines the contract for algebra formula data access.
///
/// Primary hexagonal port — the interface that use cases depend on.
/// Returns [Result] to enforce typed error handling at the boundary.
abstract interface class AlgebraRepositoryPort {
  /// Fetches all formula sections with their formulas.
  Future<Result<List<FormulaSection>>> getFormulaSections();
}
