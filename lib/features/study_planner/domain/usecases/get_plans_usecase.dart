import 'package:injectable/injectable.dart';

import '../entities/study_plan.dart';
import '../ports/study_planner_repository_port.dart';

@injectable
class GetPlansUseCase {
  const GetPlansUseCase({required StudyPlannerRepositoryPort repository})
      : _repository = repository;

  final StudyPlannerRepositoryPort _repository;

  Stream<List<StudyPlan>> call(String userId) =>
      _repository.watchPlans(userId);
}
