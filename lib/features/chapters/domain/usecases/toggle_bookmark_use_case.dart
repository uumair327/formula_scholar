import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/formula.dart';
import '../ports/formulas_repository_port.dart';

/// Use case for toggling a formula's bookmark status.
@injectable
class ToggleBookmarkUseCase {
  final FormulasRepositoryPort _repository;

  const ToggleBookmarkUseCase({required FormulasRepositoryPort repository})
    : _repository = repository;

  Future<Result<void>> call(Formula formula, String subjectName, {required String curriculumKey}) {
    return _repository.toggleBookmark(formula, subjectName, curriculumKey: curriculumKey);
  }
}
