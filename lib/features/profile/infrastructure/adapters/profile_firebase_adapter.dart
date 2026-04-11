import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

@LazySingleton(as: ProfileDataSourcePort)
class ProfileFirebaseAdapter implements ProfileDataSourcePort {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  ProfileFirebaseAdapter(this._firestore, this._firebaseAuth);

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

    // Start with Firebase Auth as the source of truth for identity.
    final authName = currentUser.displayName ?? '';
    final authEmail = currentUser.email ?? '';
    final authPhoto = currentUser.photoURL ?? '';

    // Merge with Firestore user doc for app-specific fields (grade, board, isPro).
    final docSnapshot = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (!docSnapshot.exists) {
      // Seed a baseline user doc for first-time users.
      final seedData = {
        'name': authName,
        'email': authEmail,
        'avatarUrl': authPhoto,
        'grade': AppStrings.profileGrade,
        'isPro': false,
      };
      await _firestore.collection('users').doc(currentUser.uid).set(seedData);

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
    final fsAvatarUrl = _readString(
      data,
      'avatarUrl',
      fallback: authPhoto.isNotEmpty
          ? authPhoto
          : AppAssets.profileHeroAvatarUrl,
    );
    final fsIsPro = _readBool(data, 'isPro', fallback: false);

    return UserProfile(
      name: fsName.isNotEmpty ? fsName : 'Scholar',
      email: fsEmail,
      grade: fsGrade,
      board: fsBoard,
      avatarUrl: fsAvatarUrl,
      isPro: fsIsPro,
    );
  }

  @override
  Future<List<ProfileStat>> getProfileStats() async {
    AppLogger.trace(
      'getProfileStats() fetching from Firestore',
      tag: AppLogTags.profileDataSource,
    );

    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      return _zeroStats();
    }

    final docSnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('stats')
        .doc('current')
        .get();

    if (!docSnapshot.exists) {
      // New user — return zero-state, do NOT seed fake data.
      return _zeroStats();
    }

    final data = docSnapshot.data()!;
    return [
      ProfileStat(
        id: 'formulas',
        label: AppStrings.formulasMastered,
        value: data['formulas']?.toString() ?? '0',
        iconName: 'functions',
      ),
      ProfileStat(
        id: 'streak',
        label: AppStrings.daysStreak,
        value: data['streak']?.toString() ?? '0',
        iconName: 'fire',
      ),
      ProfileStat(
        id: 'points',
        label: AppStrings.totalPoints,
        value: data['points']?.toString() ?? '0',
        iconName: 'stars',
      ),
    ];
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
