import '../entities/formula.dart';

/// Port: Defines the contract that any backend adapter must implement
/// for algebra formula data.
///
/// Driven port (secondary) in hexagonal terminology.
/// Implementations:
/// - [AlgebraLocalAdapter] — hardcoded formula data
/// - (future) Firebase/Supabase/REST adapters
abstract interface class AlgebraDataSourcePort {
  /// Fetches all formula sections with their formulas.
  Future<List<FormulaSection>> getFormulaSections();
}
