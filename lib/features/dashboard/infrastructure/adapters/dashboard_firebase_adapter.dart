import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

const _appBannersCollection = 'app_banners';
const _announcementsCollection = 'announcements';

@LazySingleton(as: DashboardDataSourcePort)
class DashboardFirebaseAdapter implements DashboardDataSourcePort {
  DashboardFirebaseAdapter(this._firestore, this._firebaseAuth);
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

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
      return _calculateProgressFromCurriculum(uid);
    }

    final data = docSnapshot.data()!;
    return StudyProgress(
      masteryPercentage: (data['masteryPercentage'] as num?)?.toDouble() ?? 0.0,
      completedChapters: data['completedChapters'] ?? 0,
      totalChapters: data['totalChapters'] ?? 0,
    );
  }

  Future<StudyProgress> _calculateProgressFromCurriculum(String uid) async {
    final userDoc = await _firestore.collection('users').doc(uid).get();
    final userData = userDoc.data();
    final boardId = userData?['boardId']?.toString();
    final gradeId = userData?['gradeId']?.toString();

    if (boardId == null || gradeId == null) {
      return const StudyProgress(
        masteryPercentage: 0,
        completedChapters: 0,
        totalChapters: 0,
      );
    }

    final subjectSnapshot = await _fetchSubjects(boardId, gradeId);

    if (subjectSnapshot.docs.isEmpty) {
      return const StudyProgress(
        masteryPercentage: 0,
        completedChapters: 0,
        totalChapters: 0,
      );
    }

    var totalChapters = 0;
    var completedChapters = 0;
    var masterySum = 0.0;
    var masteryCount = 0;

    for (final subjectDoc in subjectSnapshot.docs) {
      final data = subjectDoc.data();
      final unitCount = (data['unitCount'] as num?)?.toInt() ?? 0;
      totalChapters += unitCount;

      final mastery = (data['masteryPercentage'] as num?)?.toDouble();
      if (mastery != null) {
        masterySum += mastery;
        masteryCount += 1;
        completedChapters += ((mastery / 100) * unitCount).round();
      }
    }

    final masteryPercentage = masteryCount > 0
        ? masterySum / masteryCount
        : 0.0;
    completedChapters = completedChapters.clamp(0, totalChapters);

    return StudyProgress(
      masteryPercentage: masteryPercentage,
      completedChapters: completedChapters,
      totalChapters: totalChapters,
    );
  }

  @override
  Future<List<Subject>> getSubjects(String boardId, String gradeId) async {
    AppLogger.trace(
      'getSubjects() fetching from Firestore',
      tag: AppLogTags.dashboardDataSource,
    );
    final snapshot = await _fetchSubjects(boardId, gradeId);
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
        isGeneralContent: data['isGeneralContent'] ?? false,
        audiences:
            (data['audiences'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
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
      return _fallbackRecentStudiesFromSubjects(uid);
    }

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return RecentStudy(
        id: data['id'] ?? doc.id,
        subjectId: data['subjectId'] ?? '',
        title: data['title'] ?? '',
        subject: data['subject'] ?? '',
        lastViewed: data['lastViewed'] ?? '',
        iconName: data['iconName'] ?? 'book-open',
        colorValue: data['colorValue'] ?? 0xFF00639A,
        backgroundColorValue: data['backgroundColorValue'] ?? 0xFFCEE5FF,
      );
    }).toList();
  }

  Future<List<RecentStudy>> _fallbackRecentStudiesFromSubjects(
    String uid,
  ) async {
    final userDoc = await _firestore.collection('users').doc(uid).get();
    final userData = userDoc.data();
    final boardId = userData?['boardId']?.toString();
    final gradeId = userData?['gradeId']?.toString();
    if (boardId == null || gradeId == null) {
      return const [];
    }

    final subjectSnapshot = await _fetchSubjects(boardId, gradeId);

    final docs = [...subjectSnapshot.docs];
    docs.sort((a, b) {
      final aMastery =
          (a.data()['masteryPercentage'] as num?)?.toDouble() ?? 0.0;
      final bMastery =
          (b.data()['masteryPercentage'] as num?)?.toDouble() ?? 0.0;
      return bMastery.compareTo(aMastery);
    });

    return docs.take(5).map((doc) {
      final data = doc.data();
      final name = data['name'] as String? ?? '';
      final subtitle = data['subtitle'] as String? ?? name;
      return RecentStudy(
        id: doc.id,
        subjectId: data['id'] as String? ?? doc.id,
        title: subtitle,
        subject: name,
        lastViewed: data['lastViewed'] as String? ?? 'Recently updated',
        iconName: data['iconName'] as String? ?? 'book-open',
        colorValue: (data['colorValue'] as num?)?.toInt() ?? 0xFF00639A,
        backgroundColorValue: 0xFFCEE5FF,
      );
    }).toList();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _fetchSubjects(
    String boardId,
    String gradeId,
  ) async {
    final token = '${boardId}_$gradeId';
    final tokenAlt = '${boardId}_${_alternateGradeId(gradeId)}';

    // Using Firestore Filter.or to pull universal content OR strictly assigned targeted content
    // Also falling back to old 'boardId' check to support legacy seeded data
    final snapshot = await _firestore
        .collection('subjects')
        .where(
          Filter.or(
            Filter('isGeneralContent', isEqualTo: true),
            Filter('audiences', arrayContainsAny: [token, tokenAlt, boardId]),
            Filter('boardId', isEqualTo: boardId),
          ),
        )
        .get();

    // Final fallback to load EVERYTHING if database lacks assignment but needs to render
    if (snapshot.docs.isEmpty) {
      return _firestore.collection('subjects').get();
    }

    return snapshot;
  }

  @override
  Future<List<CarouselItem>> getBanners() async {
    AppLogger.trace(
      'getBanners() fetching from Firestore',
      tag: AppLogTags.dashboardDataSource,
    );

    final snapshot = await _firestore
        .collection(_appBannersCollection)
        .where('isActive', isEqualTo: true)
        .orderBy('displayOrder', descending: false)
        .get();

    return snapshot.docs.map((doc) => CarouselItem.fromFirestore(doc)).toList();
  }

  @override
  Future<List<AppAnnouncement>> getActiveAnnouncements() async {
    AppLogger.trace(
      'getActiveAnnouncements() fetching from Firestore',
      tag: AppLogTags.dashboardDataSource,
    );

    final snapshot = await _firestore
        .collection(_announcementsCollection)
        .where('status', isEqualTo: 'published')
        .orderBy('priority')
        .get();

    return snapshot.docs.map((doc) => AppAnnouncement.fromFirestore(doc)).toList();
  }

  String? _alternateGradeId(String gradeId) {
    final normalized = gradeId.trim().toLowerCase();
    if (normalized.startsWith('class_')) {
      return normalized.replaceFirst('class_', '');
    }
    final numeric = int.tryParse(normalized);
    if (numeric != null) {
      return 'class_$numeric';
    }
    return null;
  }

  @override
  Future<List<WeakArea>> getWeakAreas() async {
    AppLogger.trace(
      'getWeakAreas() aggregating quiz answers',
      tag: AppLogTags.dashboardDataSource,
    );

    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) return const [];

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('quiz_answers')
        .orderBy('createdAt', descending: true)
        .limit(200)
        .get();

    if (snapshot.docs.isEmpty) return const [];

    final Map<String, _CategoryStats> statsMap = {};
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final category = data['category'] as String? ?? '';
      if (category.isEmpty) continue;
      final isCorrect = data['isCorrect'] as bool? ?? false;
      statsMap.putIfAbsent(category, () => _CategoryStats());
      statsMap[category]!.total++;
      if (isCorrect) statsMap[category]!.correct++;
    }

    final List<WeakArea> results = [];
    for (final entry in statsMap.entries) {
      if (entry.value.total < 2) continue;
      results.add(WeakArea(
        category: entry.key,
        totalAttempts: entry.value.total,
        correctAttempts: entry.value.correct,
      ));
    }

    results.sort((a, b) => b.weaknessScore.compareTo(a.weaknessScore));
    return results.take(5).toList();
  }
}

class _CategoryStats {
  int total = 0;
  int correct = 0;
}
