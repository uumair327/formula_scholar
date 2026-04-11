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
      return const StudyProgress(
        masteryPercentage: 65,
        completedChapters: 14,
        totalChapters: 22,
      );
    }

    final docSnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('progress_summary')
        .doc('current')
        .get();
    Map<String, dynamic> data;

    if (!docSnapshot.exists) {
      data = {
        'masteryPercentage': 65,
        'completedChapters': 14,
        'totalChapters': 22,
      };
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('progress_summary')
          .doc('current')
          .set(data);
    } else {
      data = docSnapshot.data()!;
    }

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
    // You could query a 'recent_studies' collection here. Returning static or fetching from subjects.
    return const [
      RecentStudy(
        id: '1',
        title: 'Pythagorean Theorem',
        subject: 'Mathematics',
        lastViewed: '2 hours ago',
        iconName: 'calculator',
        colorValue: 0xFF00639A,
        backgroundColorValue: 0xFFCEE5FF,
      ),
      RecentStudy(
        id: '2',
        title: "Newton's Third Law",
        subject: 'Physics',
        lastViewed: 'Yesterday',
        iconName: 'rocket',
        colorValue: 0xFF056C42,
        backgroundColorValue: 0xFF9DF5BF,
      ),
    ];
  }
}
