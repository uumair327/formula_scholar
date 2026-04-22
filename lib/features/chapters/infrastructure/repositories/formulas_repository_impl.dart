import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Concrete implementation of [FormulasRepositoryPort].
///
/// Delegates to [FormulasDataSourcePort] and wraps results in [Result].
@LazySingleton(as: FormulasRepositoryPort)
class FormulasRepositoryImpl implements FormulasRepositoryPort {
  const FormulasRepositoryImpl({required FormulasDataSourcePort dataSource})
    : _dataSource = dataSource;

  final FormulasDataSourcePort _dataSource;

  @override
  Future<Result<List<Formula>>> getFormulas(
    String subjectId,
    String chapterId, {
    String? curriculumKey,
  }) async {
    AppLogger.trace(
      'getFormulas($subjectId, $chapterId) called',
      tag: AppLogTags.formulasRepo,
    );
    try {
      final result = await _dataSource.getFormulas(subjectId, chapterId, curriculumKey: curriculumKey);
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
  Future<Result<void>> toggleBookmark(
    Formula formula,
    String subjectName, {
    required String curriculumKey,
  }) async {
    try {
      await _dataSource.toggleBookmark(
        formula,
        subjectName,
        curriculumKey: curriculumKey,
      );
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

  @override
  Future<Result<void>> markChapterStarted(
    String subjectId,
    String chapterId, {
    required String chapterName,
    required int totalFormulas,
  }) async {
    try {
      await _dataSource.markChapterStarted(
        subjectId,
        chapterId,
        chapterName: chapterName,
        totalFormulas: totalFormulas,
      );
      return const Success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'markChapterStarted failed',
        tag: AppLogTags.formulasRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(
        CacheFailure(
          message: 'Failed to update chapter start status',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void>> toggleFormulaMastery(
    String subjectId,
    String chapterId,
    String formulaId, {
    required bool isMastered,
    required int totalFormulas,
    required String chapterName,
  }) async {
    try {
      await _dataSource.toggleFormulaMastery(
        subjectId,
        chapterId,
        formulaId,
        isMastered: isMastered,
        totalFormulas: totalFormulas,
        chapterName: chapterName,
      );
      return const Success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'toggleFormulaMastery failed',
        tag: AppLogTags.formulasRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(
        CacheFailure(
          message: 'Failed to update mastery progress',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
