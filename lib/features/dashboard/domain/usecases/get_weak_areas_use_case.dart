import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/weak_area.dart';
import '../ports/dashboard_repository_port.dart';

/// Aggregates quiz answer records into weak-area recommendations.
@injectable
class GetWeakAreasUseCase {
  const GetWeakAreasUseCase({
    required DashboardRepositoryPort repository,
  }) : _repository = repository;

  final DashboardRepositoryPort _repository;

  Future<Result<List<WeakArea>>> call() {
    AppLogger.trace(
      'GetWeakAreasUseCase called',
      tag: AppLogTags.dashboardUseCase,
    );
    return _repository.getWeakAreas();
  }
}
