import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

@LazySingleton(as: ProfileDataSourcePort)
class ProfileFirebaseAdapter implements ProfileDataSourcePort {
  ProfileFirebaseAdapter(this._api, this._firebaseAuth);
  final FirestoreClientPort _api;
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

  String _upgradeGooglePhotoUrl(String url) {
    if (url.isEmpty) return url;
    final upgraded = url.replaceAll(RegExp(r'=s\d+-c'), '=s400-c');
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
        grade: 'Class 10',
        board: '',
        avatarUrl: AppAssets.profileHeroAvatarUrl,
        isPro: false,
      );
    }

    final authName = currentUser.displayName ?? '';
    final authEmail = currentUser.email ?? '';
    final authPhoto = _upgradeGooglePhotoUrl(currentUser.photoURL ?? '');

    AppLogger.trace(
      'Auth photo URL: $authPhoto',
      tag: AppLogTags.profileDataSource,
    );

    final docRef = _api.doc(AppFirestoreCollections.userDoc(currentUser.uid));
    final docSnapshot = await _api.execute(
      () => docRef.get(),
      tag: AppLogTags.profileDataSource,
    );

    if (!docSnapshot.exists) {
      final seedData = {
        'name': authName,
        'email': authEmail,
        'avatarUrl': authPhoto,
        'grade': 'Class 10',
        'isPro': false,
      };
      await _api.execute(
        () => docRef.set(seedData),
        tag: AppLogTags.profileDataSource,
      );

      return UserProfile(
        name: authName.isNotEmpty ? authName : 'Scholar',
        email: authEmail,
        grade: 'Class 10',
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
      fallback: _readString(data, 'grade', fallback: 'Class 10'),
    );
    final fsBoard = _readString(data, 'boardName');
    final fsAvatarUrl = _readString(data, 'avatarUrl');
    final fsIsPro = _readBool(data, 'isPro', fallback: false);

    final resolvedAvatar = authPhoto.isNotEmpty
        ? authPhoto
        : (fsAvatarUrl.isNotEmpty
              ? fsAvatarUrl
              : AppAssets.profileHeroAvatarUrl);

    if (authPhoto.isNotEmpty && authPhoto != fsAvatarUrl) {
      await _api.execute(
        () => docRef.set({'avatarUrl': authPhoto}, SetOptions(merge: true)),
        tag: AppLogTags.profileDataSource,
      );
    }
    if (authName.isNotEmpty && authName != fsName) {
      await _api.execute(
        () => docRef.set({'name': authName}, SetOptions(merge: true)),
        tag: AppLogTags.profileDataSource,
      );
    }
    if (authEmail.isNotEmpty && authEmail != fsEmail) {
      await _api.execute(
        () => docRef.set({'email': authEmail}, SetOptions(merge: true)),
        tag: AppLogTags.profileDataSource,
      );
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

    final statsSnapshot = await _api.execute(
      () => _api.doc(AppFirestoreCollections.userStatsCurrent(uid)).get(),
      tag: AppLogTags.profileDataSource,
    );

    final statsData = statsSnapshot.data() ?? const <String, dynamic>{};

    final formulasCount = (statsData['formulas'] as num?)?.toInt() ?? 0;
    final streak = (statsData['streak'] as num?)?.toInt() ?? 0;
    final points = (statsData['points'] as num?)?.toInt() ?? 0;

    return [
      ProfileStat(
        id: 'formulas',
        label: '',
        value: _formatStatValue(formulasCount),
        iconName: 'functions',
      ),
      ProfileStat(
        id: 'streak',
        label: '',
        value: _formatStatValue(streak),
        iconName: 'fire',
      ),
      ProfileStat(
        id: 'points',
        label: '',
        value: _formatStatValue(points),
        iconName: 'stars',
      ),
    ];
  }

  String _formatStatValue(int value) {
    if (value >= 1000) {
      final k = value / 1000;
      return k == k.truncateToDouble()
          ? '${k.toInt()}K'
          : '${k.toStringAsFixed(1)}K';
    }
    return value.toString();
  }

  List<ProfileStat> _zeroStats() {
    return const [
      ProfileStat(id: 'formulas', label: '', value: '0', iconName: 'functions'),
      ProfileStat(id: 'streak', label: '', value: '0', iconName: 'fire'),
      ProfileStat(id: 'points', label: '', value: '0', iconName: 'stars'),
    ];
  }

  @override
  Future<List<SettingsItem>> getSettingsItems() async {
    return const [
      SettingsItem(id: 'account', label: '', iconName: 'person_outline'),
      SettingsItem(id: 'bookmarks', label: '', iconName: 'bookmark_outline'),
      SettingsItem(
        id: 'study_planner',
        label: '',
        subtitle: '',
        iconName: 'calendar_today',
      ),
      SettingsItem(
        id: 'achievements',
        label: '',
        subtitle: '',
        iconName: 'emoji_events',
      ),
      SettingsItem(
        id: 'notifications',
        label: '',
        iconName: 'notifications_outlined',
      ),
      SettingsItem(
        id: 'language',
        label: '',
        subtitle: '',
        iconName: 'language',
      ),
      SettingsItem(
        id: 'appearance',
        label: '',
        subtitle: '',
        iconName: 'palette_outlined',
        isToggle: true,
      ),
      SettingsItem(id: 'help', label: '', iconName: 'help_outline'),
      SettingsItem(
        id: 'about',
        label: '',
        subtitle: '',
        iconName: 'info_outline',
      ),
      SettingsItem(
        id: 'logout',
        label: '',
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

    await _api.execute(
      () => _api.doc(AppFirestoreCollections.userDoc(currentUser.uid)).set({
        'name': name,
        'avatarUrl': avatarUrl,
      }, SetOptions(merge: true)),
      tag: AppLogTags.profileDataSource,
    );
  }

  @override
  Future<NotificationPreferences> getNotificationPreferences() async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      return _notificationDefaults();
    }

    final docSnapshot = await _api.execute(
      () => _api.doc(AppFirestoreCollections.userDoc(uid)).get(),
      tag: AppLogTags.profileDataSource,
    );
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

    await _api.execute(
      () => _api.doc(AppFirestoreCollections.userDoc(uid)).set({
        'notificationPreferences': _notificationPreferencesToMap(preferences),
      }, SetOptions(merge: true)),
      tag: AppLogTags.profileDataSource,
    );
  }

  @override
  Future<void> updateStudyGoal(String studyGoalId) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      throw const ServerException(message: 'User not authenticated');
    }

    await _api.execute(
      () => _api.doc(AppFirestoreCollections.userDoc(uid)).set({
        'studyGoalId': studyGoalId,
      }, SetOptions(merge: true)),
      tag: AppLogTags.profileDataSource,
    );
  }
}
