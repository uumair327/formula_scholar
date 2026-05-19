import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/analytics_data.dart';
import '../ports/analytics_repository_port.dart';

@injectable
class GetAnalyticsDataUseCase {
  const GetAnalyticsDataUseCase({required AnalyticsRepositoryPort repository})
    : _repository = repository;

  final AnalyticsRepositoryPort _repository;

  Future<Result<AnalyticsData>> call() {
    AppLogger.trace('GetAnalyticsDataUseCase called', tag: AppLogTags.analyticsUseCase);
    return _repository.getAnalytics();
  }
}
