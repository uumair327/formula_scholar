import '../entities/analytics_data.dart';

abstract interface class AnalyticsDataSourcePort {
  Future<AnalyticsData> fetchAnalytics();
}
