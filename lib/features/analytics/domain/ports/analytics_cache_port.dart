import '../entities/analytics_data.dart';

abstract interface class AnalyticsCachePort {
  Future<void> cacheAnalytics(AnalyticsData data);

  Future<AnalyticsData?> getCachedAnalytics();
}
