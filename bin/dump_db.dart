import 'dart:io';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';

void main() async {
  final serviceAccountPath =
      r'C:\Users\uumai\Downloads\zip\formula_scholar\formula-scholar-firebase-adminsdk-fbsvc-8b4116cc0e.json';

  final admin = FirebaseAdminApp.initializeApp(
    'formula-scholar',
    Credential.fromServiceAccount(File(serviceAccountPath)),
  );

  final firestore = Firestore(admin);

  final boardsSnap = await firestore.collection('boards').get();
  print('BOARDS:');
  for (var doc in boardsSnap.docs) {
    print('${doc.id}: ${doc.data()}');
  }

  final msbshseSnap = await firestore.collection('boards').doc('msbshse').collection('classes').get();
  print('CLASSES in msbshse:');
  for (var doc in msbshseSnap.docs) {
    print('${doc.id}: ${doc.data()}');
  }
  
  final msbshseGradesSnap = await firestore.collection('boards').doc('msbshse').collection('grades').get();
  print('GRADES in msbshse:');
  for (var doc in msbshseGradesSnap.docs) {
    print('${doc.id}: ${doc.data()}');
  }

  exit(0);
}
