import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Local adapter: returns hardcoded profile data for development.
///
/// Driven adapter implementing [ProfileDataSourcePort].
@LazySingleton(as: ProfileDataSourcePort)
class ProfileLocalAdapter implements ProfileDataSourcePort {
  @override
  Future<UserProfile> getUserProfile() async {
    AppLogger.trace(
      'getUserProfile() fetching local data',
      tag: AppLogTags.profileDataSource,
    );
    return const UserProfile(
      name: AppStrings.profileName,
      grade: AppStrings.profileGrade,
      avatarUrl: AppAssets.profileHeroAvatarUrl,
      isPro: true,
    );
  }

  @override
  Future<List<ProfileStat>> getProfileStats() async {
    AppLogger.trace(
      'getProfileStats() fetching local data',
      tag: AppLogTags.profileDataSource,
    );
    return const [
      ProfileStat(
        id: 'formulas',
        label: AppStrings.formulasMastered,
        value: AppStrings.formulasMasteredValue,
        iconName: 'functions',
      ),
      ProfileStat(
        id: 'streak',
        label: AppStrings.daysStreak,
        value: AppStrings.daysStreakValue,
        iconName: 'fire',
      ),
      ProfileStat(
        id: 'points',
        label: AppStrings.totalPoints,
        value: AppStrings.totalPointsValue,
        iconName: 'stars',
      ),
    ];
  }

  @override
  Future<List<SettingsItem>> getSettingsItems() async {
    AppLogger.trace(
      'getSettingsItems() fetching local data',
      tag: AppLogTags.profileDataSource,
    );
    return const [
      SettingsItem(
        id: 'account',
        label: AppStrings.accountInformation,
        iconName: 'person_outline',
      ),
      SettingsItem(
        id: 'bookmarks',
        label: AppStrings.myBookmarks,
        iconName: 'bookmark_outline',
      ),
      SettingsItem(
        id: 'notifications',
        label: AppStrings.notifications,
        iconName: 'notifications_outlined',
      ),
      SettingsItem(
        id: 'appearance',
        label: AppStrings.appearance,
        subtitle: AppStrings.toggleDarkMode,
        iconName: 'palette_outlined',
        isToggle: true,
      ),
      SettingsItem(
        id: 'help',
        label: AppStrings.helpAndSupport,
        iconName: 'help_outline',
      ),
      SettingsItem(
        id: 'logout',
        label: AppStrings.logout,
        iconName: 'logout',
        isDestructive: true,
      ),
    ];
  }
}
