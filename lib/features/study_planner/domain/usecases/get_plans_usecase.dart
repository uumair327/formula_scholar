import 'package:injectable/injectable.dart';

import '../entities/study_plan.dart';
import '../ports/study_planner_port.dart';

@injectable
class GetPlansUseCase {
  const GetPlansUseCase({required StudyPlannerPort port}) : _port = port;

  final StudyPlannerPort _port;

  Stream<List<StudyPlan>> call(String userId) => _port.watchPlans(userId);
}
