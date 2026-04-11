import '../entities/profile_stat.dart';
import '../entities/user_profile.dart';

/// Cache port for offline-first profile data access.
///
/// Settings items are static client data and don't need caching.
abstract interface class ProfileCachePort {
  /// Persists the user profile into local cache.
  Future<void> cacheUserProfile(UserProfile profile);

  /// Retrieves the cached user profile. Returns `null` if none.
  Future<UserProfile?> getUserProfile();

  /// Persists profile stats into local cache.
  Future<void> cacheProfileStats(List<ProfileStat> stats);

  /// Retrieves cached profile stats. Returns empty list if none.
  Future<List<ProfileStat>> getProfileStats();
}
