import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../ports/achievement_repository_port.dart';

@injectable
class ReportAchievementProgressUseCase {
  const ReportAchievementProgressUseCase({
    required AchievementRepositoryPort repository,
  }) : _repository = repository;

  final AchievementRepositoryPort _repository;

  Future<Result<void>> call(String achievementId, int increment) {
    AppLogger.trace(
      'ReportAchievementProgressUseCase called (id=$achievementId, inc=$increment)',
      tag: AppLogTags.achievementsUseCase,
    );
    return _repository.reportProgress(achievementId, increment);
  }
}
