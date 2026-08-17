import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';
import '../entities/growth_metrics.dart';
import '../ports/analytics_repository_port.dart';

@injectable
class GetGrowthMetricsUseCase {
  const GetGrowthMetricsUseCase(this._repository);

  final AnalyticsRepositoryPort _repository;

  Future<Result<GrowthMetrics>> call() {
    return _repository.getGrowthMetrics();
  }
}
