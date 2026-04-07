import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/formula.dart';
import '../ports/formulas_repository_port.dart';

/// Fetches formulas for a given chapter within a subject.
///
/// Single-responsibility use case following SOLID principles.
@injectable
class GetFormulasUseCase {
  final FormulasRepositoryPort _repository;

  const GetFormulasUseCase({required FormulasRepositoryPort repository})
    : _repository = repository;

  /// Executes the use case.
  Future<Result<List<Formula>>> call(String subjectId, String chapterId) {
    AppLogger.trace(
      'GetFormulasUseCase called for subject=$subjectId, chapter=$chapterId',
      tag: AppLogTags.formulasUseCase,
    );
    return _repository.getFormulas(subjectId, chapterId);
  }
}
