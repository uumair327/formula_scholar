import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

@LazySingleton(as: ChaptersDataSourcePort)
class ChaptersFirebaseAdapter implements ChaptersDataSourcePort {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  ChaptersFirebaseAdapter(this._firestore, this._firebaseAuth);

  @override
  Future<List<Chapter>> getChapters(String subjectId) async {
    AppLogger.trace(
      'getChapters($subjectId) fetching from Firestore',
      tag: AppLogTags.chaptersDataSource,
    );

    // 1. Fetch static chapters
    final snapshot = await _firestore
        .collection('subjects')
        .doc(subjectId)
        .collection('chapters')
        .get();

    final uid = _firebaseAuth.currentUser?.uid;

    // 2. Fetch user progress for this subject
    Map<String, dynamic> progressMap = {};
    if (uid != null) {
      final progressSnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('progress')
          .doc(subjectId)
          .collection('chapters')
          .get();

      // Seed mock progress if it doesn't exist to show working UI
      if (progressSnapshot.docs.isEmpty) {
        await _seedMockProgress(uid, subjectId, snapshot.docs);
        // Re-fetch after seeding
        final newProgress = await _firestore
            .collection('users')
            .doc(uid)
            .collection('progress')
            .doc(subjectId)
            .collection('chapters')
            .get();
        for (var doc in newProgress.docs) {
          progressMap[doc.id] = doc.data();
        }
      } else {
        for (var doc in progressSnapshot.docs) {
          progressMap[doc.id] = doc.data();
        }
      }
    }

    // 3. Merge data — always use doc.id as the canonical key
    return snapshot.docs.map((doc) {
      final data = doc.data();
      // Look up progress by doc.id first (matches _seedMockProgress),
      // then by data['id'] as fallback
      final progressData = progressMap[doc.id] ?? progressMap[data['id']] ?? {};
      final hasProgress = (progressData as Map).isNotEmpty;

      // Status: prefer progress record, fall back to static chapter data
      final statusStr = hasProgress
          ? progressData['status'] as String?
          : data['status'] as String?;
      ChapterStatus status = ChapterStatus.notStarted;
      if (statusStr == 'inProgress') status = ChapterStatus.inProgress;
      if (statusStr == 'locked') status = ChapterStatus.locked;

      // Completed formulas from progress (static has 0 by default)
      final completedFormulas = hasProgress
          ? (progressData['completedFormulas'] ?? 0)
          : (data['completedFormulas'] ?? 0);
      final totalFormulas = data['totalFormulas'] ?? 1;

      // Calculate progress (0–100)
      double progressPercent;
      if (hasProgress && progressData['progressPercent'] != null) {
        progressPercent = (progressData['progressPercent'] as num).toDouble();
      } else if (data['progressPercent'] != null) {
        progressPercent = (data['progressPercent'] as num).toDouble();
      } else {
        progressPercent = totalFormulas > 0
            ? (completedFormulas / totalFormulas) * 100.0
            : 0.0;
      }
      // Normalise: if stored as 0–1, scale to 0–100
      if (progressPercent > 0 && progressPercent <= 1.0) {
        progressPercent *= 100;
      }

      return Chapter(
        id: data['id'] ?? doc.id,
        name: data['name'] ?? '',
        subtitle: data['subtitle'] ?? '',
        completedFormulas: completedFormulas,
        totalFormulas: totalFormulas,
        progressPercent: progressPercent,
        status: status,
      );
    }).toList();
  }

  Future<void> _seedMockProgress(
    String uid,
    String subjectId,
    List<QueryDocumentSnapshot> staticChapters,
  ) async {
    AppLogger.info(
      'Seeding mock progress for $subjectId',
      tag: AppLogTags.chaptersDataSource,
    );
    final batch = _firestore.batch();

    for (int i = 0; i < staticChapters.length; i++) {
      final doc = staticChapters[i];
      final staticData = doc.data() as Map<String, dynamic>;
      final totalFormulas = staticData['totalFormulas'] ?? 10;

      // Store progress keyed by doc.id (canonical Firestore key)
      final ref = _firestore
          .collection('users')
          .doc(uid)
          .collection('progress')
          .doc(subjectId)
          .collection('chapters')
          .doc(doc.id);

      int completed;
      double progressPct;
      String status;

      if (i == 0) {
        // Featured chapter — 65% progress, inProgress
        completed = (totalFormulas * 0.65).round();
        progressPct = 65.0;
        status = 'inProgress';
      } else if (i == 1) {
        // Secondary chapter — small progress, shown as "START NOW"
        completed = 2;
        progressPct = totalFormulas > 0 ? (2 / totalFormulas) * 100 : 0;
        status = 'notStarted';
      } else {
        // Remaining chapters — locked
        completed = 0;
        progressPct = 0;
        status = 'locked';
      }

      batch.set(ref, {
        'completedFormulas': completed,
        'progressPercent': progressPct,
        'status': status,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }
}
