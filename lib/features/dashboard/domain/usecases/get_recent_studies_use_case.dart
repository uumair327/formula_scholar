import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/recent_study.dart';
import '../ports/dashboard_repository_port.dart';

/// Fetches recent study activity.
///
/// Single-responsibility use case following SOLID principles.
@injectable
class GetRecentStudiesUseCase {
  final DashboardRepositoryPort _repository;

  const GetRecentStudiesUseCase({required DashboardRepositoryPort repository})
    : _repository = repository;

  /// Executes the use case.
  Future<Result<List<RecentStudy>>> call() {
    AppLogger.trace(
      'GetRecentStudiesUseCase called',
      tag: AppLogTags.dashboardUseCase,
    );
    return _repository.getRecentStudies();
  }
}
