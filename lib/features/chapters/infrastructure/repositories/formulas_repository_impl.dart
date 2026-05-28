import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

/// Concrete implementation of [FormulasRepositoryPort].
///
/// Uses [safeOperation] for DRY error handling with [FormulasCachePort]
/// fallback for offline-first behaviour when the backend is unreachable.
@LazySingleton(as: FormulasRepositoryPort)
class FormulasRepositoryImpl implements FormulasRepositoryPort {
  const FormulasRepositoryImpl({
    required FormulasDataSourcePort dataSource,
    required FormulasCachePort cache,
  }) : _dataSource = dataSource,
       _cache = cache;

  final FormulasDataSourcePort _dataSource;
  final FormulasCachePort _cache;

  @override
  Future<Result<List<Formula>>> getFormulas(
    String subjectId,
    String chapterId, {
    String? curriculumKey,
  }) async {
    final key = curriculumKey ?? '';
    AppLogger.trace(
      'getFormulas($subjectId, $chapterId) called',
      tag: AppLogTags.formulasRepo,
    );

    return safeOperation(
      tag: AppLogTags.formulasRepo,
      operation: 'getFormulas($subjectId, $chapterId, curriculum=$key)',
      execute: () async {
        final result = await _dataSource.getFormulas(
          subjectId,
          chapterId,
          curriculumKey: curriculumKey,
        );
        await _cache.cacheFormulas(subjectId, chapterId, key, result);
        return result;
      },
      fallback: () async {
        final cached = await _cache.getFormulas(subjectId, chapterId, key);
        return cached.isNotEmpty ? cached : null;
      },
    );
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

  @override
  Future<Result<FormulaNote?>> getFormulaNote(String formulaId) async {
    try {
      final note = await _dataSource.getFormulaNote(formulaId);
      return Success(note);
    } catch (e, stackTrace) {
      AppLogger.error(
        'getFormulaNote failed',
        tag: AppLogTags.formulasRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(
        CacheFailure(
          message: 'Failed to load formula note',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void>> saveFormulaNote(FormulaNote note) async {
    try {
      await _dataSource.saveFormulaNote(note);
      return const Success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'saveFormulaNote failed',
        tag: AppLogTags.formulasRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(
        CacheFailure(
          message: 'Failed to save formula note',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void>> deleteFormulaNote(String formulaId) async {
    try {
      await _dataSource.deleteFormulaNote(formulaId);
      return const Success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'deleteFormulaNote failed',
        tag: AppLogTags.formulasRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(
        CacheFailure(
          message: 'Failed to delete formula note',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
