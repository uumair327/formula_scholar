import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../ports/study_planner_port.dart';

@injectable
class DeletePlanUseCase {
  const DeletePlanUseCase({required StudyPlannerPort port}) : _port = port;

  final StudyPlannerPort _port;

  Future<Result<void>> call({required String userId, required String planId}) async {
    try {
      await _port.deletePlan(userId: userId, planId: planId);
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }
}
