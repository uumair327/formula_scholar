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

  final subs = ['msbshse_class_9_algebra', 'msbshse_class_9_geometry'];
  for (var sub in subs) {
    final subRef = firestore
        .collection('subjects')
        .doc(sub)
        .collection('chapters');
    final snaps = await subRef.get();
    for (var doc in snaps.docs) {
      final fRef = doc.ref.collection('formulas');
      final fSnaps = await fRef.get();
      for (var fDoc in fSnaps.docs) {
        await fDoc.ref.delete();
      }
      await doc.ref.delete();
    }
  }
  print('Cleared old dummy formulas.');
  exit(0);
}
