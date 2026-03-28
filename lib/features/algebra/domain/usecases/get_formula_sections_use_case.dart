import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/formula.dart';
import '../ports/algebra_repository_port.dart';

/// Fetches all formula sections.
///
/// Single-responsibility use case following SOLID principles.
@injectable
class GetFormulaSectionsUseCase {
  final AlgebraRepositoryPort _repository;

  const GetFormulaSectionsUseCase({
    required AlgebraRepositoryPort repository,
  }) : _repository = repository;

  /// Executes the use case.
  Future<Result<List<FormulaSection>>> call() {
    AppLogger.trace(
      'GetFormulaSectionsUseCase called',
      tag: AppLogTags.algebraCubit,
    );
    return _repository.getFormulaSections();
  }
}
