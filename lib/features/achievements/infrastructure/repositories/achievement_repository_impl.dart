import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

@LazySingleton(as: AchievementRepositoryPort)
class AchievementRepositoryImpl implements AchievementRepositoryPort {
  const AchievementRepositoryImpl({
    required AchievementDataSourcePort dataSource,
    required AchievementCachePort cache,
  }) : _dataSource = dataSource,
       _cache = cache;

  final AchievementDataSourcePort _dataSource;
  final AchievementCachePort _cache;

  @override
  Future<Result<List<Achievement>>> getAchievements() {
    return safeOperation(
      tag: AppLogTags.achievementsRepo,
      operation: 'getAchievements',
      execute: () async {
        final cached = await _cache.getCachedAchievements();
        if (cached != null) return cached;
        final definitions = await _dataSource.getAchievements();
        await _cache.cacheAchievements(definitions);
        return definitions;
      },
      fallback: () => _dataSource.getAchievements(),
    );
  }

  @override
  Future<Result<void>> reportProgress(String achievementId, int increment) {
    return safeOperation(
      tag: AppLogTags.achievementsRepo,
      operation: 'reportProgress($achievementId, $increment)',
      execute: () async {
        final current = await _getCurrentAchievements();
        final updated = current.map((a) {
          if (a.id != achievementId || a.isUnlocked) return a;
          final newProgress = a.progress + increment;
          if (newProgress >= a.target) {
            return a.copyWith(
              progress: a.target,
              unlockedAt: DateTime.now(),
            );
          }
          return a.copyWith(progress: newProgress);
        }).toList();
        await _cache.cacheAchievements(updated);
      },
    );
  }

  Future<List<Achievement>> _getCurrentAchievements() async {
    final cached = await _cache.getCachedAchievements();
    if (cached != null) return cached;
    return _dataSource.getAchievements();
  }
}
