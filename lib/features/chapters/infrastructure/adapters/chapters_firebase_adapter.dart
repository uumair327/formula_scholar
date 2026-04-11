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

    // 2. Fetch user progress for this subject (if authenticated)
    Map<String, dynamic> progressMap = {};
    if (uid != null) {
      final progressSnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('progress')
          .doc(subjectId)
          .collection('chapters')
          .get();

      for (final doc in progressSnapshot.docs) {
        progressMap[doc.id] = doc.data();
      }
    }

    // 3. Merge data — always use doc.id as the canonical key
    return snapshot.docs.map((doc) {
      final data = doc.data();
      // Look up progress by doc.id first, then by data['id'] as fallback
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
}
