import '../../../../core/error/result.dart';
import '../entities/analytics_data.dart';
import '../entities/growth_metrics.dart';

abstract interface class AnalyticsRepositoryPort {
  Future<Result<AnalyticsData>> getAnalytics();

  Future<Result<GrowthMetrics>> getGrowthMetrics();
}
