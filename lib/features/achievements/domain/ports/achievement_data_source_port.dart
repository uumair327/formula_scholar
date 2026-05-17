import '../entities/achievement.dart';

abstract interface class AchievementDataSourcePort {
  Future<List<Achievement>> getAchievements();

  Future<void> saveAchievementProgress(
    String id,
    int progress,
    DateTime? unlockedAt,
  );
}
