import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../core/core.dart';
import '../../domain/domain.dart';

@LazySingleton(as: ThemePreferenceDataSourcePort)
class ThemePreferenceFirebaseAdapter implements ThemePreferenceDataSourcePort {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  const ThemePreferenceFirebaseAdapter(this._firestore, this._firebaseAuth);

  @override
  Future<ThemePreference?> loadThemePreference() async {
    AppLogger.trace(
      'loadThemePreference() fetching from Firestore',
      tag: AppLogTags.themePreferenceDataSource,
    );
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      return null;
    }

    final snapshot = await _firestore.collection('users').doc(uid).get();
    return _mapPreference(snapshot.data());
  }

  @override
  Future<void> saveThemePreference(ThemePreference preference) async {
    AppLogger.trace(
      'saveThemePreference() persisting to Firestore',
      tag: AppLogTags.themePreferenceDataSource,
    );
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      throw const ServerException(message: 'No authenticated user found');
    }

    await _firestore.collection('users').doc(uid).set({
      'isDarkMode': preference.isDarkMode,
    }, SetOptions(merge: true));
  }

  @override
  Stream<ThemePreference?> watchThemePreference() {
    AppLogger.trace(
      'watchThemePreference() listening to Firestore + auth stream',
      tag: AppLogTags.themePreferenceDataSource,
    );
    return Stream<ThemePreference?>.multi((controller) {
      StreamSubscription<User?>? authSubscription;
      StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      documentSubscription;

      Future<void> cancelDocumentSubscription() async {
        await documentSubscription?.cancel();
        documentSubscription = null;
      }

      authSubscription = _firebaseAuth.authStateChanges().listen(
        (user) async {
          await cancelDocumentSubscription();
          if (user == null) {
            controller.add(null);
            return;
          }

          documentSubscription = _firestore
              .collection('users')
              .doc(user.uid)
              .snapshots()
              .listen(
                (snapshot) => controller.add(_mapPreference(snapshot.data())),
                onError: controller.addError,
              );
        },
        onError: controller.addError,
        onDone: () async {
          await cancelDocumentSubscription();
          await controller.close();
        },
      );

      controller.onCancel = () async {
        await cancelDocumentSubscription();
        await authSubscription?.cancel();
      };
    });
  }

  ThemePreference? _mapPreference(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    final value = data['isDarkMode'];
    if (value is bool) {
      return ThemePreference(isDarkMode: value);
    }

    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1' || normalized == 'yes') {
        return const ThemePreference(isDarkMode: true);
      }
      if (normalized == 'false' || normalized == '0' || normalized == 'no') {
        return const ThemePreference(isDarkMode: false);
      }
    }

    if (value is num) {
      return ThemePreference(isDarkMode: value != 0);
    }

    return null;
  }
}
