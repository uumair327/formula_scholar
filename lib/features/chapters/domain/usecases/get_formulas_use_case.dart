import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/formula.dart';
import '../ports/formulas_repository_port.dart';

/// Fetches formulas for a given chapter within a subject.
///
/// Single-responsibility use case following SOLID principles.
@injectable
class GetFormulasUseCase {

  const GetFormulasUseCase({required FormulasRepositoryPort repository})
    : _repository = repository;
  final FormulasRepositoryPort _repository;

  /// Executes the use case.
  Future<Result<List<Formula>>> call(String subjectId, String chapterId, {String? curriculumKey}) {
    AppLogger.trace(
      'GetFormulasUseCase called for subject=$subjectId, chapter=$chapterId',
      tag: AppLogTags.formulasUseCase,
    );
    return _repository.getFormulas(subjectId, chapterId, curriculumKey: curriculumKey);
  }
}
