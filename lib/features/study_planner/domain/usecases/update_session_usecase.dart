import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../ports/study_planner_repository_port.dart';

@injectable
class UpdateSessionUseCase {
  const UpdateSessionUseCase(
      {required StudyPlannerRepositoryPort repository})
      : _repository = repository;

  final StudyPlannerRepositoryPort _repository;

  Future<Result<void>> call({
    required String userId,
    required String planId,
    required String sessionId,
    DocumentReference? transactionRef,
  }) async {
    try {
      await _repository.updateSessionStatus(
        userId: userId,
        planId: planId,
        sessionId: sessionId,
        transactionRef: transactionRef,
      );
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }
}
