import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/achievement.dart';
import '../ports/achievement_repository_port.dart';

@injectable
class GetAchievementsUseCase {
  const GetAchievementsUseCase({required AchievementRepositoryPort repository})
    : _repository = repository;

  final AchievementRepositoryPort _repository;

  Future<Result<List<Achievement>>> call() {
    AppLogger.trace(
      'GetAchievementsUseCase called',
      tag: AppLogTags.achievementsUseCase,
    );
    return _repository.getAchievements();
  }
}
