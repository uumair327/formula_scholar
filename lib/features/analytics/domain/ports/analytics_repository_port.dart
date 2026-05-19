import '../../../../core/error/result.dart';
import '../entities/analytics_data.dart';

abstract interface class AnalyticsRepositoryPort {
  Future<Result<AnalyticsData>> getAnalytics();
}
