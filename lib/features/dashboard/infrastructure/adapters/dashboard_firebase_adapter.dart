import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

@LazySingleton(as: DashboardDataSourcePort)
class DashboardFirebaseAdapter implements DashboardDataSourcePort {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  DashboardFirebaseAdapter(this._firestore, this._firebaseAuth);

  @override
  Future<StudyProgress> getStudyProgress() async {
    AppLogger.trace(
      'getStudyProgress() fetching from Firestore',
      tag: AppLogTags.dashboardDataSource,
    );

    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      // Unauthenticated users see zero-state, not fake numbers.
      return const StudyProgress(
        masteryPercentage: 0,
        completedChapters: 0,
        totalChapters: 0,
      );
    }

    final docSnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('progress_summary')
        .doc('current')
        .get();

    if (!docSnapshot.exists) {
      // Return zero-state for new users — do NOT seed fake data.
      return const StudyProgress(
        masteryPercentage: 0,
        completedChapters: 0,
        totalChapters: 0,
      );
    }

    final data = docSnapshot.data()!;
    return StudyProgress(
      masteryPercentage: (data['masteryPercentage'] as num?)?.toDouble() ?? 0.0,
      completedChapters: data['completedChapters'] ?? 0,
      totalChapters: data['totalChapters'] ?? 0,
    );
  }

  @override
  Future<List<Subject>> getSubjects(String boardId, String gradeId) async {
    AppLogger.trace(
      'getSubjects() fetching from Firestore',
      tag: AppLogTags.dashboardDataSource,
    );
    final snapshot = await _firestore
        .collection('subjects')
        .where('boardId', isEqualTo: boardId)
        .where('gradeId', isEqualTo: gradeId)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Subject(
        id: data['id'] ?? doc.id,
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        category: data['category'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        unitCount: data['unitCount'] ?? 0,
        formulaCount: data['formulaCount'] ?? 0,
        iconName: data['iconName'] ?? 'book-open',
        colorValue: data['colorValue'] ?? 0xFF00639A,
        badgeText: data['badgeText'],
        subtitle: data['subtitle'],
        masteryPercentage: data['masteryPercentage'] != null
            ? (data['masteryPercentage'] as num).toDouble()
            : null,
        lastViewed: data['lastViewed'],
        isFeatured: data['isFeatured'] ?? false,
      );
    }).toList();
  }

  @override
  Future<List<RecentStudy>> getRecentStudies() async {
    AppLogger.trace(
      'getRecentStudies() fetching from Firestore',
      tag: AppLogTags.dashboardDataSource,
    );

    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      return const [];
    }

    // Query the user's recent activity from Firestore.
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('recent_studies')
        .orderBy('viewedAt', descending: true)
        .limit(5)
        .get();

    if (snapshot.docs.isEmpty) {
      return const [];
    }

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return RecentStudy(
        id: data['id'] ?? doc.id,
        title: data['title'] ?? '',
        subject: data['subject'] ?? '',
        lastViewed: data['lastViewed'] ?? '',
        iconName: data['iconName'] ?? 'book-open',
        colorValue: data['colorValue'] ?? 0xFF00639A,
        backgroundColorValue: data['backgroundColorValue'] ?? 0xFFCEE5FF,
      );
    }).toList();
  }
}

