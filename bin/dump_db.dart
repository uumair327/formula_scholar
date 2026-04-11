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

void main(List<String> args) async {
  final serviceAccountPath = resolveServiceAccountPath(args);

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

  exit(0);
}
