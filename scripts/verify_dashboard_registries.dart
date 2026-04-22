/// Dart helper to verify dashboard registries exist in Firestore
/// Run this after the Node seeding to confirm the registries are available.
///
/// Usage:
///   dart run scripts/verify_dashboard_registries.dart ../formula-scholar-firebase-adminsdk-fbsvc-8b4116cc0e.json

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

Future<void> main(List<String> args) async {
  final serviceAccountPath = resolveServiceAccountPath(args);

  final admin = FirebaseAdminApp.initializeApp(
    'formula-scholar',
    Credential.fromServiceAccount(File(serviceAccountPath)),
  );

  final firestore = Firestore(admin);

  stdout.writeln('🔍 Verifying dashboard registries...\n');

  // --- Verify Curriculum Registry ---
  stdout.writeln('1. Checking dashboard_curriculum_registry/current...');
  try {
    final curriculumDoc = await firestore
        .collection('dashboard_curriculum_registry')
        .doc('current')
        .get();

    if (curriculumDoc.exists) {
      final data = curriculumDoc.data() as Map<String, dynamic>;
      final nodes = data['nodes'] as List?;
      final nodeCount = data['nodeCount'] ?? 0;
      final status = data['status'] ?? 'unknown';

      stdout.writeln('   ✅ Found curriculum registry');
      stdout.writeln('   └─ Status: $status');
      stdout.writeln('   └─ Node count: $nodeCount');
      if (nodes != null) {
        for (final node in nodes.cast<Map<String, dynamic>>()) {
          stdout.writeln(
            '      • ${node['label']} (${node['key']}) — ${node['nodeCount']} items',
          );
        }
      }
    } else {
      stdout.writeln('   ⚠️ Registry document not found');
      stdout.writeln('   └─ Run: npm run seed:curriculum-registry');
    }
  } catch (e) {
    stdout.writeln('   ❌ Error: $e');
  }

  stdout.writeln('');

  // --- Verify Content Registry ---
  stdout.writeln('2. Checking dashboard_content_registry/current...');
  try {
    final contentDoc = await firestore
        .collection('dashboard_content_registry')
        .doc('current')
        .get();

    if (contentDoc.exists) {
      final data = contentDoc.data() as Map<String, dynamic>;
      final items = data['items'] as List?;
      final itemCount = data['itemCount'] ?? 0;
      final status = data['status'] ?? 'unknown';

      stdout.writeln('   ✅ Found content registry');
      stdout.writeln('   └─ Status: $status');
      stdout.writeln('   └─ Item count: $itemCount');
      if (items != null) {
        for (final item in items.cast<Map<String, dynamic>>()) {
          final key = item['key'] ?? 'unknown';
          final itemStatus = item['status'] ?? 'unknown';
          stdout.writeln('      • $key ($itemStatus)');
        }
      }
    } else {
      stdout.writeln('   ⚠️ Registry document not found');
      stdout.writeln('   └─ Run: npm run seed:content-registry');
    }
  } catch (e) {
    stdout.writeln('   ❌ Error: $e');
  }

  stdout.writeln('');
  stdout.writeln('✅ Registry verification complete');
  exit(0);
}
