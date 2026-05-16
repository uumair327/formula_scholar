import '../../../../core/core.dart';
import '../ports/formulas_repository_port.dart';

/// Deletes the user's note for a formula.
class DeleteFormulaNoteUseCase {
  const DeleteFormulaNoteUseCase(this._repository);

  final FormulasRepositoryPort _repository;

  Future<Result<void>> call(String formulaId) =>
      _repository.deleteFormulaNote(formulaId);
}
