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

  @override
  Future<UserProfile> getUserProfile() async {
    AppLogger.trace('getUserProfile() fetching from Firestore', tag: AppLogTags.profileDataSource);
    
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      return const UserProfile(
        name: 'Guest',
        email: '',
        grade: AppStrings.profileGrade,
        avatarUrl: AppAssets.profileHeroAvatarUrl,
        isPro: false,
      );
    }

    // Start with Firebase Auth as the source of truth for identity.
    final authName = currentUser.displayName ?? '';
    final authEmail = currentUser.email ?? '';
    final authPhoto = currentUser.photoURL ?? '';

    // Merge with Firestore user doc for app-specific fields (grade, isPro).
    final docSnapshot = await _firestore.collection('users').doc(currentUser.uid).get();
    
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
        avatarUrl: authPhoto.isNotEmpty ? authPhoto : AppAssets.profileHeroAvatarUrl,
        isPro: false,
      );
    }

    final data = docSnapshot.data()!;
    return UserProfile(
      name: data['name'] ?? authName.isNotEmpty ? (data['name'] ?? authName) : 'Scholar',
      email: data['email'] ?? authEmail,
      grade: data['grade'] ?? AppStrings.profileGrade,
      avatarUrl: data['avatarUrl'] ?? (authPhoto.isNotEmpty ? authPhoto : AppAssets.profileHeroAvatarUrl),
      isPro: data['isPro'] ?? false,
    );
  }

  @override
  Future<List<ProfileStat>> getProfileStats() async {
    AppLogger.trace('getProfileStats() fetching from Firestore', tag: AppLogTags.profileDataSource);
    
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      return const [
        ProfileStat(
          id: 'formulas',
          label: AppStrings.formulasMastered,
          value: '124',
          iconName: 'functions',
        ),
        ProfileStat(
          id: 'streak',
          label: AppStrings.daysStreak,
          value: '12',
          iconName: 'fire',
        ),
        ProfileStat(
          id: 'points',
          label: AppStrings.totalPoints,
          value: '2450',
          iconName: 'stars',
        ),
      ];
    }

    final docSnapshot = await _firestore.collection('users').doc(uid).collection('stats').doc('current').get();
    Map<String, dynamic> data;

    if (!docSnapshot.exists) {
      // Seed robust mock stats for UI presentation if backend hasn't initialized them yet
      data = {
        'formulas': 124,
        'streak': 12,
        'points': 2450,
      };
      await _firestore.collection('users').doc(uid).collection('stats').doc('current').set(data);
    } else {
      data = docSnapshot.data()!;
    }
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

  @override
  Future<List<SettingsItem>> getSettingsItems() async {
    AppLogger.trace('getSettingsItems() returning static client data', tag: AppLogTags.profileDataSource);
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
