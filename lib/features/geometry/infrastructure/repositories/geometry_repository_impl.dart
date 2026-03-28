import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Concrete implementation of [GeometryRepositoryPort].
///
/// Delegates to [GeometryDataSourcePort] and wraps results in [Result].
@LazySingleton(as: GeometryRepositoryPort)
class GeometryRepositoryImpl implements GeometryRepositoryPort {
  final GeometryDataSourcePort _dataSource;

  const GeometryRepositoryImpl({
    required GeometryDataSourcePort dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<Result<List<GeometryTopic>>> getTopics() async {
    AppLogger.trace('getTopics() called', tag: AppLogTags.geometryRepo);
    try {
      final result = await _dataSource.getTopics();
      AppLogger.info(
        'getTopics() succeeded: ${result.length} topics',
        tag: AppLogTags.geometryRepo,
      );
      return Success(result);
    } catch (e, stackTrace) {
      AppLogger.error(
        'getTopics() failed',
        tag: AppLogTags.geometryRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(CacheFailure(
        message: 'Failed to load geometry topics',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }
}
