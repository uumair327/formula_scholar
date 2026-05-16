import '../../../../core/core.dart';
import '../entities/formula_note.dart';
import '../ports/formulas_repository_port.dart';

/// Saves (creates or updates) the user's note for a formula.
class SaveFormulaNoteUseCase {
  const SaveFormulaNoteUseCase(this._repository);

  final FormulasRepositoryPort _repository;

  Future<Result<void>> call(FormulaNote note) =>
      _repository.saveFormulaNote(note);
}
