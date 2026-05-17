import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

@LazySingleton(as: AchievementCachePort)
class AchievementHiveCache implements AchievementCachePort {
  static const String _boxName = 'achievement_cache';

  Future<Box<dynamic>> _box() => Hive.openBox<dynamic>(_boxName);

  @override
  Future<void> cacheAchievements(List<Achievement> achievements) async {
    final box = await _box();
    final data = achievements.map((a) => a.toJson()).toList();
    await box.put('achievements', data);
  }

  @override
  Future<List<Achievement>?> getCachedAchievements() async {
    final box = await _box();
    final cached = box.get('achievements') as List<dynamic>?;
    if (cached == null) return null;
    return cached
        .whereType<Map>()
        .map((item) => Achievement.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  @override
  Future<void> updateAchievementProgress(
    String id,
    int progress,
    DateTime? unlockedAt,
  ) async {
    final cached = await getCachedAchievements();
    if (cached == null) return;
    final updated = cached.map((a) {
      if (a.id != id) return a;
      return a.copyWith(
        progress: progress,
        unlockedAt: unlockedAt,
      );
    }).toList();
    await cacheAchievements(updated);
  }
}
