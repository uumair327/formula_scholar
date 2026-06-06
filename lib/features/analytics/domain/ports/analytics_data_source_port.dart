import '../entities/analytics_data.dart';
import '../entities/growth_metrics.dart';

abstract interface class AnalyticsDataSourcePort {
  Future<AnalyticsData> fetchAnalytics();

  Future<GrowthMetrics> fetchGrowthMetrics();
}
