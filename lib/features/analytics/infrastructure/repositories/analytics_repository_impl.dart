import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

@LazySingleton(as: AnalyticsRepositoryPort)
class AnalyticsRepositoryImpl implements AnalyticsRepositoryPort {
  const AnalyticsRepositoryImpl({
    required AnalyticsDataSourcePort dataSource,
    required AnalyticsCachePort cache,
  }) : _dataSource = dataSource,
       _cache = cache;

  final AnalyticsDataSourcePort _dataSource;
  final AnalyticsCachePort _cache;

  @override
  Future<Result<AnalyticsData>> getAnalytics() {
    return safeOperation(
      tag: AppLogTags.analyticsRepo,
      operation: 'getAnalytics',
      execute: () async {
        final data = await _dataSource.fetchAnalytics();
        await _cache.cacheAnalytics(data);
        return data;
      },
      fallback: () => _cache.getCachedAnalytics(),
    );
  }
}
