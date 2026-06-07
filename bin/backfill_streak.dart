import 'dart:io';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';

String resolveServiceAccountPath(List<String> args) {
  if (args.isNotEmpty) {
    return args.first;
  }

  final envPath = Platform.environment['FIREBASE_SERVICE_ACCOUNT_PATH'];
  if (envPath != null && envPath.isNotEmpty) {
    return envPath;
  }

  throw StateError(
    'Set FIREBASE_SERVICE_ACCOUNT_PATH or pass the service account JSON path as the first argument.',
  );
}

String resolveTargetUserUid() {
  final envUid = Platform.environment['TARGET_USER_UID'];
  if (envUid != null && envUid.isNotEmpty) {
    return envUid;
  }
  return '3y6cquvN0KbzhmqayddYABzLWMh2';
}

void main(List<String> args) async {
  final serviceAccountPath = resolveServiceAccountPath(args);
  final targetUid = resolveTargetUserUid();

  final admin = FirebaseAdminApp.initializeApp(
    'formula-scholar',
    Credential.fromServiceAccount(File(serviceAccountPath)),
  );

  final firestore = Firestore(admin);

  stdout.writeln('Checking streak data for user: $targetUid');
  
  final statsDoc = await firestore
      .collection('users')
      .doc(targetUid)
      .collection('stats')
      .doc('current')
      .get();
      
  if (!statsDoc.exists) {
    stdout.writeln('User stats not found. Exiting.');
    exit(0);
  }

  final data = statsDoc.data()!;
  final currentStreak = (data['streak'] as num?)?.toInt() ?? 0;
  final lastStudyDateStr = (data['lastStudyDate'] as String?) ?? '';
  
  if (currentStreak <= 0 || lastStudyDateStr.isEmpty) {
    stdout.writeln('No active streak or last study date found. Exiting.');
    exit(0);
  }
  
  stdout.writeln('Current Streak: $currentStreak');
  stdout.writeln('Last Study Date: $lastStudyDateStr');
  
  final lastStudyDate = DateTime.tryParse(lastStudyDateStr);
  if (lastStudyDate == null) {
    stdout.writeln('Invalid date format. Exiting.');
    exit(0);
  }
  
  // Backfill dates
  for (int i = 0; i < currentStreak; i++) {
    final date = lastStudyDate.subtract(Duration(days: i));
    final yearMonth = '${date.year}-${date.month.toString().padLeft(2, '0')}';
    
    stdout.writeln('Backfilling day: ${date.day} in month: $yearMonth');
    
    final docRef = firestore
        .collection('users')
        .doc(targetUid)
        .collection('activity_history')
        .doc(yearMonth);
        
    final docSnap = await docRef.get();
    
    if (docSnap.exists) {
      await docRef.update({
        'activeDays': FieldValue.arrayUnion([date.day]),
        'lastUpdated': FieldValue.serverTimestamp,
      });
    } else {
      await docRef.set({
        'activeDays': [date.day],
        'lastUpdated': FieldValue.serverTimestamp,
      });
    }
  }
  
  stdout.writeln('Backfill complete!');
  exit(0);
}
