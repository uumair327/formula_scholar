import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../ports/study_planner_repository_port.dart';

@injectable
class DeletePlanUseCase {
  const DeletePlanUseCase({required StudyPlannerRepositoryPort repository})
    : _repository = repository;

  final StudyPlannerRepositoryPort _repository;

  Future<Result<void>> call({
    required String userId,
    required String planId,
  }) async {
    try {
      await _repository.deletePlan(userId: userId, planId: planId);
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }
}
