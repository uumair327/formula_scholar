import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../ports/dashboard_repository_port.dart';
import '../entities/study_progress.dart';

/// Fetches the user's overall study progress.
///
/// Single-responsibility use case following SOLID principles.
/// Cubits call this instead of the repository directly.
@injectable
class GetStudyProgressUseCase {
  final DashboardRepositoryPort _repository;

  const GetStudyProgressUseCase({required DashboardRepositoryPort repository})
    : _repository = repository;

  /// Executes the use case.
  Future<Result<StudyProgress>> call() {
    AppLogger.trace(
      'GetStudyProgressUseCase called',
      tag: AppLogTags.dashboardUseCase,
    );
    return _repository.getStudyProgress();
  }
}
