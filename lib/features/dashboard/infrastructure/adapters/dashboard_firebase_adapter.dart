import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

// @LazySingleton(as: DashboardDataSourcePort)
class DashboardFirebaseAdapter implements DashboardDataSourcePort {
  DashboardFirebaseAdapter(this._api, this._firebaseAuth);
  final FirestoreClientPort _api;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<StudyProgress> getStudyProgress() async {
    AppLogger.trace(
      'getStudyProgress() fetching from Firestore',
      tag: AppLogTags.dashboardDataSource,
    );

    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      return const StudyProgress(
        masteryPercentage: 0,
        completedChapters: 0,
        totalChapters: 0,
      );
    }

    final docSnapshot = await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.userProgressSummary(uid))
          .doc(AppFirestoreCollections.current)
          .get(),
      tag: AppLogTags.dashboardDataSource,
    );

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
    final userDoc = await _api.execute(
      () => _api.doc(AppFirestoreCollections.userDoc(uid)).get(),
      tag: AppLogTags.dashboardDataSource,
    );
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

    if (subjectSnapshot.isEmpty) {
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

    for (final subjectDoc in subjectSnapshot) {
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

  String _resolveLocalizedField(
    Map<String, dynamic> data,
    String key,
    String fallback,
  ) {
    if (!AppLocales.contentLocalizationEnabled) {
      return fallback;
    }
    try {
      final loc = data['localized'] as Map<String, dynamic>?;
      if (loc != null) {
        final localeCode = AppLocales.normalizeContentLocaleCode(
          AppLocales.currentLocaleCode,
        );
        final candidate = loc[localeCode] as Map<String, dynamic>?;
        if (candidate != null &&
            candidate[key] != null &&
            (candidate[key] as String).isNotEmpty) {
          return candidate[key] as String;
        }
        for (final fb in AppLocales.contentLocaleFallbacks(localeCode)) {
          final fbCandidate = loc[fb] as Map<String, dynamic>?;
          if (fbCandidate != null &&
              fbCandidate[key] != null &&
              (fbCandidate[key] as String).isNotEmpty) {
            return fbCandidate[key] as String;
          }
        }
      }
    } catch (_) {}
    return fallback;
  }

  @override
  Future<List<Subject>> getSubjects(String boardId, String gradeId) async {
    AppLogger.trace(
      'getSubjects() fetching from Firestore',
      tag: AppLogTags.dashboardDataSource,
    );
    final snapshot = await _fetchSubjects(boardId, gradeId);
    return snapshot.map((doc) {
      final data = doc.data();
      final name = _resolveLocalizedField(data, 'name', data['name'] ?? '');
      final description = _resolveLocalizedField(
        data,
        'description',
        data['description'] ?? '',
      );

      final rawSubtitle = data['subtitle'] as String?;
      final subtitle = rawSubtitle != null
          ? _resolveLocalizedField(data, 'subtitle', rawSubtitle)
          : null;

      final rawBadgeText = data['badgeText'] as String?;
      final badgeText = rawBadgeText != null
          ? _resolveLocalizedField(data, 'badgeText', rawBadgeText)
          : null;

      return Subject(
        id: data['id'] ?? doc.id,
        name: name,
        description: description,
        category: data['category'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        unitCount: data['unitCount'] ?? 0,
        formulaCount: data['formulaCount'] ?? 0,
        iconName: data['iconName'] ?? 'book-open',
        colorValue: data['colorValue'] ?? 0xFF00639A,
        badgeText: badgeText,
        subtitle: subtitle,
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

    final snapshot = await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.userRecentStudies(uid))
          .orderBy('viewedAt', descending: true)
          .limit(5)
          .get(),
      tag: AppLogTags.dashboardDataSource,
    );

    if (snapshot.docs.isEmpty) {
      return _fallbackRecentStudiesFromSubjects(uid);
    }

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final viewedAt = (data['viewedAt'] as Timestamp?)?.toDate();
      
      String formattedTime = 'Just now';
      if (viewedAt != null) {
        final now = DateTime.now();
        final difference = now.difference(viewedAt);
        if (difference.inSeconds < 60) {
          formattedTime = 'Just now';
        } else if (difference.inMinutes < 60) {
          formattedTime = '${difference.inMinutes}m ago';
        } else if (difference.inHours < 24) {
          formattedTime = '${difference.inHours}h ago';
        } else if (difference.inDays < 7) {
          formattedTime = '${difference.inDays}d ago';
        } else {
          formattedTime = '${viewedAt.day}/${viewedAt.month}';
        }
      }

      return RecentStudy(
        id: data['id'] ?? doc.id,
        subjectId: data['subjectId'] ?? '',
        title: data['title'] ?? '',
        subject: data['subject'] ?? '',
        lastViewed: formattedTime,
        iconName: data['iconName'] ?? 'book-open',
        colorValue: data['colorValue'] ?? 0xFF00639A,
        backgroundColorValue: data['backgroundColorValue'] ?? 0xFFCEE5FF,
      );
    }).toList();
  }

  Future<List<RecentStudy>> _fallbackRecentStudiesFromSubjects(
    String uid,
  ) async {
    final userDoc = await _api.execute(
      () => _api.doc(AppFirestoreCollections.userDoc(uid)).get(),
      tag: AppLogTags.dashboardDataSource,
    );
    final userData = userDoc.data();
    final boardId = userData?['boardId']?.toString();
    final gradeId = userData?['gradeId']?.toString();
    if (boardId == null || gradeId == null) {
      return const [];
    }

    final subjectSnapshot = await _fetchSubjects(boardId, gradeId);

    final docs = [...subjectSnapshot];
    docs.sort((a, b) {
      final aMastery =
          (a.data()['masteryPercentage'] as num?)?.toDouble() ?? 0.0;
      final bMastery =
          (b.data()['masteryPercentage'] as num?)?.toDouble() ?? 0.0;
      return bMastery.compareTo(aMastery);
    });

    return docs.take(5).map((doc) {
      final data = doc.data();
      final name = _resolveLocalizedField(
        data,
        'name',
        data['name'] as String? ?? '',
      );
      final rawSubtitle = data['subtitle'] as String?;
      final subtitle = rawSubtitle != null
          ? _resolveLocalizedField(data, 'subtitle', rawSubtitle)
          : name;
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

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>?
  _activeSubjectsFetch;
  String? _activeSubjectsToken;
  DateTime? _activeSubjectsTime;

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _fetchSubjects(
    String boardId,
    String gradeId,
  ) {
    final cacheKey = '${boardId}_$gradeId';
    if (_activeSubjectsFetch != null &&
        _activeSubjectsToken == cacheKey &&
        _activeSubjectsTime != null &&
        DateTime.now().difference(_activeSubjectsTime!).inSeconds < 10) {
      return _activeSubjectsFetch!;
    }

    _activeSubjectsToken = cacheKey;
    _activeSubjectsTime = DateTime.now();
    _activeSubjectsFetch = _doFetchSubjects(boardId, gradeId);
    return _activeSubjectsFetch!;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _doFetchSubjects(
    String boardId,
    String gradeId,
  ) async {
    final token = '${boardId}_$gradeId';
    final tokenAlt = '${boardId}_${_alternateGradeId(gradeId)}';
    final tokenCountry = 'IN_${boardId}_$gradeId';
    final tokenCountryAlt = 'IN_${boardId}_${_alternateGradeId(gradeId)}';

    final snapshot = await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.subjects)
          .where(
            Filter.or(
              Filter('isGeneralContent', isEqualTo: true),
              Filter(
                'audiences',
                arrayContainsAny: [
                  token,
                  tokenAlt,
                  tokenCountry,
                  tokenCountryAlt,
                ],
              ),
              Filter('boardId', isEqualTo: boardId),
              Filter('boardId', isEqualTo: 'IN_$boardId'),
            ),
          )
          .get(),
      tag: AppLogTags.dashboardDataSource,
    );

    final filteredDocs = snapshot.docs.where((doc) {
      final data = doc.data();
      if (data['isActive'] == false) return false;

      final aud =
          (data['audiences'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];

      if (aud.isNotEmpty) {
        final matchesGrade =
            aud.contains(token) ||
            aud.contains(tokenAlt) ||
            aud.contains(tokenCountry) ||
            aud.contains(tokenCountryAlt);

        if (matchesGrade) return true;

        final matchesBoardOnly =
            aud.contains(boardId) || aud.contains('IN_$boardId');
        if (!matchesBoardOnly) {
          return false;
        }
      }

      final docBoard = data['boardId']?.toString();
      if (docBoard != null && docBoard.isNotEmpty) {
        if (docBoard != boardId && docBoard != 'IN_$boardId') {
          return false;
        }
      }

      final docGrade = data['gradeId']?.toString();
      if (docGrade != null && docGrade.isNotEmpty) {
        if (docGrade != gradeId && docGrade != _alternateGradeId(gradeId)) {
          return false;
        }
      }

      if (data['isGeneralContent'] == true) {
        final badge = data['badgeText']?.toString().toLowerCase() ?? '';
        final currentBoardLower = boardId.toLowerCase();

        if ((badge.contains('cbse') && !currentBoardLower.contains('cbse')) ||
            (badge.contains('icse') && !currentBoardLower.contains('icse')) ||
            (badge.contains('msbshse') &&
                !currentBoardLower.contains('msbshse'))) {
          return false;
        }

        final gradeStr = gradeId.toString();
        if (badge.contains('10') && !badge.contains('9') && gradeStr == '9') {
          return false;
        }
        if (badge.contains('9') && !badge.contains('10') && gradeStr == '10') {
          return false;
        }

        return true;
      }

      return true;
    }).toList();

    return filteredDocs;
  }

  @override
  Future<List<CarouselItem>> getBanners() async {
    AppLogger.trace(
      'getBanners() fetching from Firestore',
      tag: AppLogTags.dashboardDataSource,
    );

    final snapshot = await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.appBanners)
          .where('isActive', isEqualTo: true)
          .orderBy('displayOrder', descending: false)
          .get(),
      tag: AppLogTags.dashboardDataSource,
    );

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final title = _resolveLocalizedField(data, 'title', data['title'] ?? '');
      return CarouselItem(
        id: doc.id,
        title: title,
        imageUrl: data['imageUrl'] as String? ?? '',
        link: data['link'] as String? ?? '',
        isActive: data['isActive'] as bool? ?? false,
        displayOrder: data['displayOrder'] as int?,
        bgColor: data['bgColor'] as String?,
      );
    }).toList();
  }

  @override
  Future<List<AppAnnouncement>> getActiveAnnouncements() async {
    AppLogger.trace(
      'getActiveAnnouncements() fetching from Firestore',
      tag: AppLogTags.dashboardDataSource,
    );

    final snapshot = await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.announcements)
          .where('status', isEqualTo: 'published')
          .orderBy('priority')
          .get(),
      tag: AppLogTags.dashboardDataSource,
    );

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final title = _resolveLocalizedField(data, 'title', data['title'] ?? '');
      final message = _resolveLocalizedField(
        data,
        'message',
        data['message'] ?? '',
      );
      return AppAnnouncement(
        id: doc.id,
        title: title,
        message: message,
        priority: data['priority'] as String? ?? 'normal',
        status: data['status'] as String? ?? 'draft',
        publishAt: data['publishAt'] as String?,
        expiresAt: data['expiresAt'] as String?,
      );
    }).toList();
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

    final snapshot = await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.userQuizAnswers(uid))
          .orderBy('createdAt', descending: true)
          .limit(200)
          .get(),
      tag: AppLogTags.dashboardDataSource,
    );

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
      results.add(
        WeakArea(
          category: entry.key,
          totalAttempts: entry.value.total,
          correctAttempts: entry.value.correct,
        ),
      );
    }

    results.sort((a, b) => b.weaknessScore.compareTo(a.weaknessScore));
    return results.take(5).toList();
  }
}

class _CategoryStats {
  int total = 0;
  int correct = 0;
}
