import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/scheduled_session.dart';
import '../ports/study_planner_repository_port.dart';

@injectable
class UpdateSessionUseCase {
  const UpdateSessionUseCase({required StudyPlannerRepositoryPort repository})
    : _repository = repository;

  final StudyPlannerRepositoryPort _repository;

  Future<Result<void>> call({
    required String userId,
    required String planId,
    required String sessionId,
    SessionStatus? status,
  }) async {
    try {
      await _repository.updateSessionStatus(
        userId: userId,
        planId: planId,
        sessionId: sessionId,
        status: status,
      );
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }
}
