import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Concrete implementation of [ProfileRepositoryPort].
///
/// Uses [safeOperation] for DRY error handling and [ProfileCachePort]
/// for offline-first fallback on getUserProfile and getProfileStats.
/// Settings items are static client data and don't need caching.
@LazySingleton(as: ProfileRepositoryPort)
class ProfileRepositoryImpl implements ProfileRepositoryPort {
  final ProfileDataSourcePort _dataSource;
  final ProfileCachePort _cache;

  const ProfileRepositoryImpl({
    required ProfileDataSourcePort dataSource,
    required ProfileCachePort cache,
  }) : _dataSource = dataSource,
       _cache = cache;

  @override
  Future<Result<UserProfile>> getUserProfile() {
    return safeOperation(
      tag: AppLogTags.profileRepo,
      operation: 'getUserProfile',
      execute: () async {
        final result = await _dataSource.getUserProfile();
        await _cache.cacheUserProfile(result);
        return result;
      },
      fallback: () => _cache.getUserProfile(),
    );
  }

  @override
  Future<Result<List<ProfileStat>>> getProfileStats() {
    return safeOperation(
      tag: AppLogTags.profileRepo,
      operation: 'getProfileStats',
      execute: () async {
        final result = await _dataSource.getProfileStats();
        await _cache.cacheProfileStats(result);
        return result;
      },
      fallback: () async {
        final cached = await _cache.getProfileStats();
        return cached.isNotEmpty ? cached : null;
      },
    );
  }

  @override
  Future<Result<List<SettingsItem>>> getSettingsItems() {
    // Settings are static client data — no cache needed.
    return safeOperation(
      tag: AppLogTags.profileRepo,
      operation: 'getSettingsItems',
      execute: () => _dataSource.getSettingsItems(),
    );
  }

  @override
  Future<Result<void>> updateProfile({
    required String name,
    required String avatarUrl,
  }) {
    return safeOperation(
      tag: AppLogTags.profileRepo,
      operation: 'updateProfile',
      execute: () =>
          _dataSource.updateProfile(name: name, avatarUrl: avatarUrl),
    );
  }

  @override
  Future<Result<void>> updateStudyGoal(String studyGoalId) {
    return safeOperation(
      tag: AppLogTags.profileRepo,
      operation: 'updateStudyGoal',
      execute: () => _dataSource.updateStudyGoal(studyGoalId),
    );
  }
}
