library;

import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../ports/formulas_repository_port.dart';

@injectable
class ToggleMasteryUseCase {
  const ToggleMasteryUseCase(this._repository);

  final FormulasRepositoryPort _repository;

  Future<Result<void>> call({
    required String subjectId,
    required String chapterId,
    required String formulaId,
    required bool isMastered,
    required int totalFormulas,
    required String chapterName,
  }) {
    return _repository.toggleFormulaMastery(
      subjectId,
      chapterId,
      formulaId,
      isMastered: isMastered,
      totalFormulas: totalFormulas,
      chapterName: chapterName,
    );
  }
}
