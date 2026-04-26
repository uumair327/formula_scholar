import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/subject.dart';
import '../ports/dashboard_repository_port.dart';

/// Fetches the list of available subjects.
///
/// Single-responsibility use case following SOLID principles.
@injectable
class GetSubjectsUseCase {
  const GetSubjectsUseCase({required DashboardRepositoryPort repository})
    : _repository = repository;
  final DashboardRepositoryPort _repository;

  /// Executes the use case.
  Future<Result<List<Subject>>> call(String boardId, String gradeId) {
    AppLogger.trace(
      'GetSubjectsUseCase called for $boardId, $gradeId',
      tag: AppLogTags.dashboardUseCase,
    );
    return _repository.getSubjects(boardId, gradeId);
  }
}
