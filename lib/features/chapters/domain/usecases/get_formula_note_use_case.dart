import '../../../../core/core.dart';
import '../entities/formula_note.dart';
import '../ports/formulas_repository_port.dart';

/// Loads the user's note for a given formula.
class GetFormulaNoteUseCase {
  const GetFormulaNoteUseCase(this._repository);

  final FormulasRepositoryPort _repository;

  Future<Result<FormulaNote?>> call(String formulaId) =>
      _repository.getFormulaNote(formulaId);
}
