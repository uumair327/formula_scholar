import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../ports/profile_repository_port.dart';

/// Use case for updating the user's study goal.
@injectable
class UpdateStudyGoalUseCase {
  final ProfileRepositoryPort _repository;

  const UpdateStudyGoalUseCase({required ProfileRepositoryPort repository})
    : _repository = repository;

  Future<Result<void>> call(String studyGoalId) {
    AppLogger.trace('UpdateStudyGoalUseCase called', tag: AppLogTags.profileUseCase);
    return _repository.updateStudyGoal(studyGoalId);
  }
}
