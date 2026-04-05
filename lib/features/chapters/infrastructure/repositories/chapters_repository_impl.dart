import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Concrete implementation of [ChaptersRepositoryPort].
///
/// Delegates to [ChaptersDataSourcePort] and wraps results in [Result].
/// The adapter can be swapped (local → API) without touching this class.
@LazySingleton(as: ChaptersRepositoryPort)
class ChaptersRepositoryImpl implements ChaptersRepositoryPort {
  final ChaptersDataSourcePort _dataSource;

  const ChaptersRepositoryImpl({required ChaptersDataSourcePort dataSource})
    : _dataSource = dataSource;

  @override
  Future<Result<List<Chapter>>> getChapters(String subjectId) async {
    AppLogger.trace(
      'getChapters($subjectId) called',
      tag: AppLogTags.chaptersRepo,
    );
    try {
      final result = await _dataSource.getChapters(subjectId);
      AppLogger.info(
        'getChapters($subjectId) succeeded: ${result.length} chapters',
        tag: AppLogTags.chaptersRepo,
      );
      return Success(result);
    } catch (e, stackTrace) {
      AppLogger.error(
        'getChapters($subjectId) failed',
        tag: AppLogTags.chaptersRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(
        CacheFailure(
          message: 'Failed to load chapters for $subjectId',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
