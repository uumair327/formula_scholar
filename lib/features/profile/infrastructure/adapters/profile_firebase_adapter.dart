import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

@LazySingleton(as: ProfileDataSourcePort)
class ProfileFirebaseAdapter implements ProfileDataSourcePort {
  ProfileFirebaseAdapter(this._firestore, this._firebaseAuth);
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  String _readString(
    Map<String, dynamic> data,
    String key, {
    String fallback = '',
  }) {
    final value = data[key];
    if (value is String) return value;
    if (value == null) return fallback;
    return value.toString();
  }

  bool _readBool(
    Map<String, dynamic> data,
    String key, {
    bool fallback = false,
  }) {
    final value = data[key];
    if (value is bool) return value;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1' || normalized == 'yes') {
        return true;
      }
      if (normalized == 'false' || normalized == '0' || normalized == 'no') {
        return false;
      }
    }
    if (value is num) return value != 0;
    return fallback;
  }

  NotificationPreferences _notificationDefaults() {
    return const NotificationPreferences();
  }

  NotificationPreferences _notificationPreferencesFromMap(
    Map<String, dynamic> map,
  ) {
    final defaults = _notificationDefaults();
    return NotificationPreferences(
      studyReminders: _readBool(
        map,
        'studyReminders',
        fallback: defaults.studyReminders,
      ),
      streakAlerts: _readBool(
        map,
        'streakAlerts',
        fallback: defaults.streakAlerts,
      ),
      newContent: _readBool(map, 'newContent', fallback: defaults.newContent),
      achievements: _readBool(
        map,
        'achievements',
        fallback: defaults.achievements,
      ),
      weeklyReport: _readBool(
        map,
        'weeklyReport',
        fallback: defaults.weeklyReport,
      ),
      pushNotifications: _readBool(
        map,
        'pushNotifications',
        fallback: defaults.pushNotifications,
      ),
      emailNotifications: _readBool(
        map,
        'emailNotifications',
        fallback: defaults.emailNotifications,
      ),
    );
  }

  Map<String, dynamic> _notificationPreferencesToMap(
    NotificationPreferences value,
  ) {
    return {
      'studyReminders': value.studyReminders,
      'streakAlerts': value.streakAlerts,
      'newContent': value.newContent,
      'achievements': value.achievements,
      'weeklyReport': value.weeklyReport,
      'pushNotifications': value.pushNotifications,
      'emailNotifications': value.emailNotifications,
    };
  }

  /// Upgrades Google profile photo URLs from the default 96px thumbnail
  /// to a 400px version for crisp rendering on high-density displays.
  String _upgradeGooglePhotoUrl(String url) {
    if (url.isEmpty) return url;
    // Google user photos: replace =s96-c (or similar) with =s400-c
    final upgraded = url.replaceAll(RegExp(r'=s\d+-c'), '=s400-c');
    // If no size param was present, append one
    if (upgraded == url && url.contains('googleusercontent.com')) {
      return '$url=s400-c';
    }
    return upgraded;
  }

  @override
  Future<UserProfile> getUserProfile() async {
    AppLogger.trace(
      'getUserProfile() fetching from Firestore',
      tag: AppLogTags.profileDataSource,
    );

    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      return const UserProfile(
        name: 'Guest',
        email: '',
        grade: AppStrings.profileGrade,
        board: '',
        avatarUrl: AppAssets.profileHeroAvatarUrl,
        isPro: false,
      );
    }

    // Firebase Auth is the source of truth for identity fields.
    final authName = currentUser.displayName ?? '';
    final authEmail = currentUser.email ?? '';
    final authPhoto = _upgradeGooglePhotoUrl(currentUser.photoURL ?? '');

    AppLogger.trace(
      'Auth photo URL: $authPhoto',
      tag: AppLogTags.profileDataSource,
    );

    // Merge with Firestore user doc for app-specific fields (grade, board, isPro).
    final docRef = _firestore.collection('users').doc(currentUser.uid);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      // Seed a baseline user doc for first-time users.
      final seedData = {
        'name': authName,
        'email': authEmail,
        'avatarUrl': authPhoto,
        'grade': AppStrings.profileGrade,
        'isPro': false,
      };
      await docRef.set(seedData);

      return UserProfile(
        name: authName.isNotEmpty ? authName : 'Scholar',
        email: authEmail,
        grade: AppStrings.profileGrade,
        board: '',
        avatarUrl: authPhoto.isNotEmpty
            ? authPhoto
            : AppAssets.profileHeroAvatarUrl,
        isPro: false,
      );
    }

    final data = docSnapshot.data()!;
    final fsName = _readString(data, 'name', fallback: authName);
    final fsEmail = _readString(data, 'email', fallback: authEmail);
    final fsGrade = _readString(
      data,
      'gradeLabel',
      fallback: _readString(data, 'grade', fallback: AppStrings.profileGrade),
    );
    final fsBoard = _readString(data, 'boardName');
    final fsAvatarUrl = _readString(data, 'avatarUrl');
    final fsIsPro = _readBool(data, 'isPro', fallback: false);

    // Always prefer the live Firebase Auth photo over a stale/empty
    // Firestore value. This ensures Google profile changes propagate.
    final resolvedAvatar = authPhoto.isNotEmpty
        ? authPhoto
        : (fsAvatarUrl.isNotEmpty
              ? fsAvatarUrl
              : AppAssets.profileHeroAvatarUrl);

    // Sync Firestore with the latest auth identity so it stays current.
    if (authPhoto.isNotEmpty && authPhoto != fsAvatarUrl) {
      await docRef.set({'avatarUrl': authPhoto}, SetOptions(merge: true));
    }
    if (authName.isNotEmpty && authName != fsName) {
      await docRef.set({'name': authName}, SetOptions(merge: true));
    }
    if (authEmail.isNotEmpty && authEmail != fsEmail) {
      await docRef.set({'email': authEmail}, SetOptions(merge: true));
    }

    return UserProfile(
      name: (fsName.isNotEmpty ? fsName : authName).isNotEmpty
          ? (fsName.isNotEmpty ? fsName : authName)
          : 'Scholar',
      email: fsEmail.isNotEmpty ? fsEmail : authEmail,
      grade: fsGrade,
      board: fsBoard,
      avatarUrl: resolvedAvatar,
      isPro: fsIsPro,
    );
  }

  @override
  Future<List<ProfileStat>> getProfileStats() async {
    AppLogger.trace(
      'getProfileStats() computing from Firestore',
      tag: AppLogTags.profileDataSource,
    );

    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      return _zeroStats();
    }

    // Read the stats accumulator doc.
    final statsSnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('stats')
        .doc('current')
        .get();

    final statsData = statsSnapshot.data() ?? const <String, dynamic>{};

    // Formulas count comes from the stats accumulator (updated on mastery toggle).
    final formulasCount = (statsData['formulas'] as num?)?.toInt() ?? 0;

    // Streak and points also come from the accumulator.
    final streak = (statsData['streak'] as num?)?.toInt() ?? 0;
    final points = (statsData['points'] as num?)?.toInt() ?? 0;

    return [
      ProfileStat(
        id: 'formulas',
        label: AppStrings.formulasMastered,
        value: _formatStatValue(formulasCount),
        iconName: 'functions',
      ),
      ProfileStat(
        id: 'streak',
        label: AppStrings.daysStreak,
        value: _formatStatValue(streak),
        iconName: 'fire',
      ),
      ProfileStat(
        id: 'points',
        label: AppStrings.totalPoints,
        value: _formatStatValue(points),
        iconName: 'stars',
      ),
    ];
  }

  /// Formats large numbers for display (e.g. 1500 → "1.5K").
  String _formatStatValue(int value) {
    if (value >= 1000) {
      final k = value / 1000;
      return k == k.truncateToDouble()
          ? '${k.toInt()}K'
          : '${k.toStringAsFixed(1)}K';
    }
    return value.toString();
  }

  /// Returns zero-state stats for unauthenticated or brand-new users.
  List<ProfileStat> _zeroStats() {
    return const [
      ProfileStat(
        id: 'formulas',
        label: AppStrings.formulasMastered,
        value: '0',
        iconName: 'functions',
      ),
      ProfileStat(
        id: 'streak',
        label: AppStrings.daysStreak,
        value: '0',
        iconName: 'fire',
      ),
      ProfileStat(
        id: 'points',
        label: AppStrings.totalPoints,
        value: '0',
        iconName: 'stars',
      ),
    ];
  }

  @override
  Future<List<SettingsItem>> getSettingsItems() async {
    AppLogger.trace(
      'getSettingsItems() returning static client data',
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
        id: 'achievements',
        label: AppStrings.achievementsTitle,
        subtitle: AppStrings.achievementsSubtitle,
        iconName: 'emoji_events',
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

  @override
  Future<void> updateProfile({
    required String name,
    required String avatarUrl,
  }) async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw const ServerException(message: 'User not authenticated');
    }

    await currentUser.updateDisplayName(name);
    if (avatarUrl.isNotEmpty) {
      await currentUser.updatePhotoURL(avatarUrl);
    }

    await _firestore.collection('users').doc(currentUser.uid).set({
      'name': name,
      'avatarUrl': avatarUrl,
    }, SetOptions(merge: true));
  }

  @override
  Future<NotificationPreferences> getNotificationPreferences() async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      return _notificationDefaults();
    }

    final docSnapshot = await _firestore.collection('users').doc(uid).get();
    if (!docSnapshot.exists) {
      return _notificationDefaults();
    }

    final data = docSnapshot.data()!;
    final prefsData = data['notificationPreferences'];
    if (prefsData is! Map) {
      return _notificationDefaults();
    }

    return _notificationPreferencesFromMap(
      Map<String, dynamic>.from(prefsData),
    );
  }

  @override
  Future<void> updateNotificationPreferences(
    NotificationPreferences preferences,
  ) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      throw const ServerException(message: 'User not authenticated');
    }

    await _firestore.collection('users').doc(uid).set({
      'notificationPreferences': _notificationPreferencesToMap(preferences),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> updateStudyGoal(String studyGoalId) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      throw const ServerException(message: 'User not authenticated');
    }

    await _firestore.collection('users').doc(uid).set({
      'studyGoalId': studyGoalId,
    }, SetOptions(merge: true));
  }
}
