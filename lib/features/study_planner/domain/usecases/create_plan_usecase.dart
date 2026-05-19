import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/study_plan.dart';
import '../ports/study_planner_repository_port.dart';

@injectable
class CreatePlanUseCase {
  const CreatePlanUseCase({required StudyPlannerRepositoryPort repository})
      : _repository = repository;

  final StudyPlannerRepositoryPort _repository;

  Future<Result<void>> call({required String userId, required StudyPlan plan}) async {
    try {
      await _repository.createPlan(userId: userId, plan: plan);
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }
}
