import '../entities/notification_preferences.dart';
import '../entities/profile_stat.dart';
import '../entities/settings_item.dart';
import '../entities/user_profile.dart';

/// Port: Defines the contract that any backend adapter must implement
/// for profile data.
///
/// Driven port (secondary) in hexagonal terminology.
abstract interface class ProfileDataSourcePort {
  /// Fetches the user's profile information.
  Future<UserProfile> getUserProfile();

  /// Fetches profile statistics (formulas mastered, streak, points).
  Future<List<ProfileStat>> getProfileStats();

  /// Fetches settings/menu items.
  Future<List<SettingsItem>> getSettingsItems();

  /// Fetches notification preference flags for the current user.
  Future<NotificationPreferences> getNotificationPreferences();

  Future<void> updateProfile({required String name, required String avatarUrl});

  Future<void> updateNotificationPreferences(
    NotificationPreferences preferences,
  );

  Future<void> updateStudyGoal(String studyGoalId);
}
