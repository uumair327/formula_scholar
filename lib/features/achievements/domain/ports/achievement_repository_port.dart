import '../../../../core/error/result.dart';
import '../entities/achievement.dart';

abstract interface class AchievementRepositoryPort {
  Future<Result<List<Achievement>>> getAchievements();

  Future<Result<void>> reportProgress(String achievementId, int increment);
}
