import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Concrete implementation of [FormulasRepositoryPort].
///
/// Delegates to [FormulasDataSourcePort] and wraps results in [Result].
@LazySingleton(as: FormulasRepositoryPort)
class FormulasRepositoryImpl implements FormulasRepositoryPort {
  final FormulasDataSourcePort _dataSource;

  const FormulasRepositoryImpl({required FormulasDataSourcePort dataSource})
    : _dataSource = dataSource;

  @override
  Future<Result<List<Formula>>> getFormulas(
    String subjectId,
    String chapterId,
  ) async {
    AppLogger.trace(
      'getFormulas($subjectId, $chapterId) called',
      tag: AppLogTags.formulasRepo,
    );
    try {
      final result = await _dataSource.getFormulas(subjectId, chapterId);
      AppLogger.info(
        'getFormulas($subjectId, $chapterId) succeeded: ${result.length} formulas',
        tag: AppLogTags.formulasRepo,
      );
      return Success(result);
    } catch (e, stackTrace) {
      AppLogger.error(
        'getFormulas($subjectId, $chapterId) failed',
        tag: AppLogTags.formulasRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(
        CacheFailure(
          message: 'Failed to load formulas for $chapterId',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void>> toggleBookmark(Formula formula, String subjectName) async {
    try {
      await _dataSource.toggleBookmark(formula, subjectName);
      return const Success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'toggleBookmark failed',
        tag: AppLogTags.formulasRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(
        CacheFailure(
          message: 'Failed to bookmark formula',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
