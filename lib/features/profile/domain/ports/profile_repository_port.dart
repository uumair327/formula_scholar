import '../../../../core/error/result.dart';
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
}
