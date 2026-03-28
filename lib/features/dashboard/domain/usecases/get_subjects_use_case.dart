import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/subject.dart';
import '../ports/dashboard_repository_port.dart';

/// Fetches the list of available subjects.
///
/// Single-responsibility use case following SOLID principles.
@injectable
class GetSubjectsUseCase {
  final DashboardRepositoryPort _repository;

  const GetSubjectsUseCase({
    required DashboardRepositoryPort repository,
  }) : _repository = repository;

  /// Executes the use case.
  Future<Result<List<Subject>>> call() {
    AppLogger.trace(
      'GetSubjectsUseCase called',
      tag: AppLogTags.dashboardCubit,
    );
    return _repository.getSubjects();
  }
}
