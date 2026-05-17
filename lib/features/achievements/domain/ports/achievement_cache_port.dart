import '../entities/achievement.dart';

abstract interface class AchievementCachePort {
  Future<void> cacheAchievements(List<Achievement> achievements);

  Future<List<Achievement>?> getCachedAchievements();

  Future<void> updateAchievementProgress(
    String id,
    int progress,
    DateTime? unlockedAt,
  );
}
