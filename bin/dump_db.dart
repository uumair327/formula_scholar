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

  // Defaults to the provided Firebase Auth UID for local verification.
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

  final boardsSnap = await firestore.collection('boards').get();
  stdout.writeln('BOARDS:');
  for (var doc in boardsSnap.docs) {
    stdout.writeln('${doc.id}: ${doc.data()}');
  }

  final msbshseSnap = await firestore
      .collection('boards')
      .doc('msbshse')
      .collection('classes')
      .get();
  stdout.writeln('CLASSES in msbshse:');
  for (var doc in msbshseSnap.docs) {
    stdout.writeln('${doc.id}: ${doc.data()}');
  }

  final msbshseGradesSnap = await firestore
      .collection('boards')
      .doc('msbshse')
      .collection('grades')
      .get();
  stdout.writeln('GRADES in msbshse:');
  for (var doc in msbshseGradesSnap.docs) {
    stdout.writeln('${doc.id}: ${doc.data()}');
  }

  final allSubjectsSnap = await firestore.collection('subjects').get();
  final subjectsSnap = allSubjectsSnap.docs.where((subject) {
    final data = subject.data();
    return data['boardId'] == 'msbshse' && data['gradeId'] == 'class_9';
  }).toList();
  stdout.writeln('MSBSHSE SUBJECTS:');
  for (final subject in subjectsSnap) {
    stdout.writeln('${subject.id}: ${subject.data()}');
    final toolsSnap = await firestore
        .collection('subjects')
        .doc(subject.id)
        .collection('mastery_tools')
        .orderBy('displayOrder')
        .get();
    stdout.writeln('  mastery_tools:');
    for (final tool in toolsSnap.docs) {
      stdout.writeln('    ${tool.id}: ${tool.data()}');
    }
  }

  final notesSnap = await firestore.collection('saved_notes').get();
  final notes = notesSnap.docs.where((doc) {
    final data = doc.data();
    return data['curriculumKey'] == 'cbse_class_9';
  }).toList();
  stdout.writeln('SAVED NOTES:');
  for (final doc in notes) {
    stdout.writeln('${doc.id}: ${doc.data()}');
  }

  // --- Target User Data ---
  stdout.writeln('\nTARGET USER DATA:');
  stdout.writeln('uid: $targetUid');
  final userDoc = await firestore.collection('users').doc(targetUid).get();
  if (userDoc.exists) {
    stdout.writeln('User Profile: ${userDoc.data()}');

    // Print stats
    final statsDoc = await firestore
        .collection('users')
        .doc(targetUid)
        .collection('stats')
        .doc('current')
        .get();
    if (statsDoc.exists) {
      stdout.writeln('User Stats: ${statsDoc.data()}');
    }

    // Print recent studies
    final recentStudiesSnapshot = await firestore
        .collection('users')
        .doc(targetUid)
        .collection('recent_studies')
        .get();
    if (recentStudiesSnapshot.docs.isNotEmpty) {
      stdout.writeln('Recent Studies:');
      for (final doc in recentStudiesSnapshot.docs) {
        stdout.writeln('  ${doc.data()}');
      }
    }
  } else {
    stdout.writeln('Target user not found.');
  }

  exit(0);
}
