import '../../../../core/error/result.dart';
import '../entities/notification_preferences.dart';
import '../entities/profile_stat.dart';
import '../entities/settings_item.dart';
import '../entities/user_profile.dart';

/// Port: Defines the contract for profile data access.
///
/// Primary hexagonal port with [Result] return types.
abstract interface class ProfileRepositoryPort {
  /// Fetches the user's profile information.
  Future<Result<UserProfile>> getUserProfile();

  /// Fetches profile statistics (formulas mastered, streak, points).
  Future<Result<List<ProfileStat>>> getProfileStats();

  /// Fetches settings/menu items.
  Future<Result<List<SettingsItem>>> getSettingsItems();

  /// Fetches notification preference flags for the current user.
  Future<Result<NotificationPreferences>> getNotificationPreferences();

  /// Updates the user's profile details.
  Future<Result<void>> updateProfile({
    required String name,
    required String avatarUrl,
  });

  /// Updates notification preference flags for the current user.
  Future<Result<void>> updateNotificationPreferences(
    NotificationPreferences preferences,
  );

  /// Updates the user's study goal in their profile.
  Future<Result<void>> updateStudyGoal(String studyGoalId);
}
