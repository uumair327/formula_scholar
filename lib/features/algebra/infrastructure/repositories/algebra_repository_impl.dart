import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Concrete implementation of [AlgebraRepositoryPort].
///
/// Delegates to [AlgebraDataSourcePort] and wraps results in [Result].
@LazySingleton(as: AlgebraRepositoryPort)
class AlgebraRepositoryImpl implements AlgebraRepositoryPort {
  final AlgebraDataSourcePort _dataSource;

  const AlgebraRepositoryImpl({
    required AlgebraDataSourcePort dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<Result<List<FormulaSection>>> getFormulaSections() async {
    AppLogger.trace(
      'getFormulaSections() called',
      tag: AppLogTags.algebraRepo,
    );
    try {
      final result = await _dataSource.getFormulaSections();
      final totalFormulas =
          result.fold<int>(0, (sum, s) => sum + s.formulas.length);
      AppLogger.info(
        'getFormulaSections() succeeded: '
        '${result.length} sections, $totalFormulas formulas',
        tag: AppLogTags.algebraRepo,
      );
      return Success(result);
    } catch (e, stackTrace) {
      AppLogger.error(
        'getFormulaSections() failed',
        tag: AppLogTags.algebraRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(CacheFailure(
        message: 'Failed to load formula sections',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }
}
