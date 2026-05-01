import 'dart:io';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';

/// Resets `users/{uid}/stats/current` to real computed values
/// by counting mastered formulas across all progress subcollections
/// and resetting streak/points to 0 (they will be incremented live).
void main(List<String> args) async {
  final serviceAccountPath = args.isNotEmpty
      ? args.first
      : 'formula-scholar-firebase-adminsdk-fbsvc-8b4116cc0e.json';

  final targetUid = Platform.environment['TARGET_USER_UID'] ??
      '3y6cquvN0KbzhmqayddYABzLWMh2';

  final admin = FirebaseAdminApp.initializeApp(
    'formula-scholar',
    Credential.fromServiceAccount(File(serviceAccountPath)),
  );

  final firestore = Firestore(admin);

  stdout.writeln('Resetting stats for user: $targetUid');

  // 1. Count real mastered formulas across all progress subcollections.
  final progressSnap = await firestore
      .collection('users')
      .doc(targetUid)
      .collection('progress')
      .get();

  var totalMastered = 0;

  for (final subjectDoc in progressSnap.docs) {
    final chaptersSnap = await firestore
        .collection('users')
        .doc(targetUid)
        .collection('progress')
        .doc(subjectDoc.id)
        .collection('chapters')
        .get();

    for (final chapterDoc in chaptersSnap.docs) {
      final formulasSnap = await firestore
          .collection('users')
          .doc(targetUid)
          .collection('progress')
          .doc(subjectDoc.id)
          .collection('chapters')
          .doc(chapterDoc.id)
          .collection('formulas')
          .get();

      for (final formulaDoc in formulasSnap.docs) {
        final data = formulaDoc.data();
        if (data['isMastered'] == true) {
          totalMastered++;
        }
      }
    }
  }

  stdout.writeln('Counted $totalMastered real mastered formulas.');

  // 2. Read current stats to get today's date format.
  final now = DateTime.now().toUtc();
  final todayKey =
      '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

  // 3. Reset the stats doc with real data.
  final statsRef = firestore
      .collection('users')
      .doc(targetUid)
      .collection('stats')
      .doc('current');

  await statsRef.set({
    'formulas': totalMastered,
    'streak': 1, // Start fresh from today
    'points': totalMastered * 10, // 10 points per mastered formula
    'lastStudyDate': todayKey,
    'lastUpdated': FieldValue.serverTimestamp,
  });

  stdout.writeln(
    'Stats reset: formulas=$totalMastered, streak=1, points=${totalMastered * 10}',
  );
  stdout.writeln('Done.');

  exit(0);
}
