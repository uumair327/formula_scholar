import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';

@LazySingleton(as: FormulasDataSourcePort)
class FormulasFirebaseAdapter implements FormulasDataSourcePort {
  FormulasFirebaseAdapter(this._api, this._firebaseAuth)
      : _statsAccumulator = UserStatsAccumulator(_api);

  final FirestoreClientPort _api;
  final FirebaseAuth _firebaseAuth;
  final UserStatsAccumulator _statsAccumulator;

  @override
  Future<List<Formula>> getFormulas(
    String subjectId,
    String chapterId, {
    String? curriculumKey,
  }) async {
    AppLogger.trace(
      'getFormulas($subjectId, $chapterId) fetching from Firestore',
      tag: AppLogTags.formulasDataSource,
    );

    var snapshot = await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.chapterFormulas(subjectId, chapterId))
          .where(
            Filter.or(
              Filter('isGeneralContent', isEqualTo: true),
              Filter('canonicalScopeTags', arrayContains: curriculumKey),
              Filter('audiences', arrayContains: curriculumKey),
            ),
          )
          .get(),
      tag: AppLogTags.formulasDataSource,
    );

    if (snapshot.docs.isEmpty) {
      snapshot = await _api.execute(
        () => _api
            .collection(AppFirestoreCollections.chapterFormulas(subjectId, chapterId))
            .get(),
        tag: AppLogTags.formulasDataSource,
      );
    }

    Set<String> bookmarkedIds = {};
    final masteryMap = <String, bool>{};
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid != null) {
      final bookmarksSnap = await _api.execute(
        () => _api
            .collection(AppFirestoreCollections.userBookmarks(uid))
            .get(),
        tag: AppLogTags.formulasDataSource,
      );
      bookmarkedIds = bookmarksSnap.docs.map((d) => d.id).toSet();

      final masterySnap = await _api.execute(
        () => _api
            .collection(AppFirestoreCollections.userProgressChapterFormulas(
                uid, subjectId, chapterId))
            .get(),
        tag: AppLogTags.formulasDataSource,
      );
      for (final doc in masterySnap.docs) {
        masteryMap[doc.id] = doc.data()['isMastered'] as bool? ?? false;
      }
    }

    if (snapshot.docs.isEmpty) {
      AppLogger.info(
        'No formulas found for $subjectId/$chapterId',
        tag: AppLogTags.formulasDataSource,
      );
      return [];
    }

    return snapshot.docs.where((doc) {
      final data = doc.data();
      return data['isActive'] != false;
    })
        .map(
          (doc) => _docToFormula(
            doc,
            bookmarkedIds.contains(doc.id),
            masteryOverride: masteryMap[doc.id],
          ),
        )
        .toList();
  }

  Formula _docToFormula(
    QueryDocumentSnapshot doc,
    bool isBookmarked, {
    bool? masteryOverride,
  }) {
    final data = doc.data() as Map<String, dynamic>;
    return Formula(
      id: data['id'] ?? doc.id,
      title: data['title'] ?? '',
      latex: data['latex'] ?? '',
      description: data['description'] ?? '',
      isMastered: masteryOverride ?? (data['isMastered'] ?? false),
      isBookmarked: isBookmarked,
      isGeneralContent: data['isGeneralContent'] ?? false,
      audiences:
          (data['audiences'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      canonicalFormulaId: data['canonicalFormulaId'] as String?,
      widgetConfig: data['widgetConfig'] as Map<String, dynamic>?,
    );
  }

  @override
  Future<void> toggleBookmark(
    Formula formula,
    String subjectName, {
    required String curriculumKey,
  }) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      throw Exception('User must be logged in to bookmark formulas');
    }

    final docRef = _api
        .collection(AppFirestoreCollections.userBookmarks(uid))
        .doc(formula.id);

    if (formula.isBookmarked) {
      await _api.execute(
        () => docRef.delete(),
        tag: AppLogTags.formulasDataSource,
      );
      AppLogger.info(
        'Removed bookmark for ${formula.id}',
        tag: AppLogTags.formulasDataSource,
      );
    } else {
      await _api.execute(
        () => docRef.set({
          'id': formula.id,
          'title': formula.title,
          'subject': subjectName,
          'formula': formula.latex,
          'curriculumKey': curriculumKey,
          'savedAt': FieldValue.serverTimestamp(),
        }),
        tag: AppLogTags.formulasDataSource,
      );
      AppLogger.info(
        'Added bookmark for ${formula.id}',
        tag: AppLogTags.formulasDataSource,
      );
    }
  }

  @override
  Future<void> markChapterStarted(
    String subjectId,
    String chapterId, {
    required String chapterName,
    required int totalFormulas,
  }) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      return;
    }

    final chapterProgressRef = _chapterProgressRef(uid, subjectId, chapterId);
    final snapshot = await _api.execute(
      () => chapterProgressRef.get(),
      tag: AppLogTags.formulasDataSource,
    );
    final data = snapshot.data() ?? const <String, dynamic>{};

    final completedFormulas = (data['completedFormulas'] as num?)?.toInt() ?? 0;
    final progressPercent = totalFormulas > 0
        ? (completedFormulas / totalFormulas) * 100
        : 0.0;

    await _api.execute(
      () => chapterProgressRef.set({
        'chapterId': chapterId,
        'chapterName': chapterName,
        'status': completedFormulas > 0 ? 'inProgress' : 'notStarted',
        'completedFormulas': completedFormulas,
        'totalFormulas': totalFormulas,
        'progressPercent': progressPercent,
        'startedAt': data['startedAt'] ?? FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)),
      tag: AppLogTags.formulasDataSource,
    );

    await _upsertRecentStudy(
      uid: uid,
      subjectId: subjectId,
      chapterId: chapterId,
      chapterName: chapterName,
      progressPercent: progressPercent,
    );

    await _statsAccumulator.touchDailyStreak(uid);
  }

  @override
  Future<void> toggleFormulaMastery(
    String subjectId,
    String chapterId,
    String formulaId, {
    required bool isMastered,
    required int totalFormulas,
    required String chapterName,
  }) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      throw Exception('User must be logged in to track progress');
    }

    final chapterProgressRef = _chapterProgressRef(uid, subjectId, chapterId);
    final formulaRef = chapterProgressRef.collection('formulas').doc(formulaId);
    final previousFormulaSnapshot = await _api.execute(
      () => formulaRef.get(),
      tag: AppLogTags.formulasDataSource,
    );
    final previousIsMastered =
        previousFormulaSnapshot.data()?['isMastered'] as bool? ?? false;

    await _api.execute(
      () => formulaRef.set({
        'id': formulaId,
        'uid': uid,
        'isMastered': isMastered,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)),
      tag: AppLogTags.formulasDataSource,
    );

    final masteredSnap = await _api.execute(
      () => chapterProgressRef
          .collection('formulas')
          .where('isMastered', isEqualTo: true)
          .get(),
      tag: AppLogTags.formulasDataSource,
    );

    final completedFormulas = masteredSnap.docs.length;
    final progressPercent = totalFormulas > 0
        ? (completedFormulas / totalFormulas) * 100
        : 0.0;

    await _api.execute(
      () => chapterProgressRef.set({
        'chapterId': chapterId,
        'chapterName': chapterName,
        'status': completedFormulas > 0 ? 'inProgress' : 'notStarted',
        'completedFormulas': completedFormulas,
        'totalFormulas': totalFormulas,
        'progressPercent': progressPercent,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)),
      tag: AppLogTags.formulasDataSource,
    );

    await _upsertRecentStudy(
      uid: uid,
      subjectId: subjectId,
      chapterId: chapterId,
      chapterName: chapterName,
      progressPercent: progressPercent,
    );

    final masteryDelta = _masteryDelta(
      previousIsMastered: previousIsMastered,
      nextIsMastered: isMastered,
    );
    if (masteryDelta != 0) {
      await _statsAccumulator.incrementMasteredFormulas(uid, masteryDelta);
    }
  }

  int _masteryDelta({
    required bool previousIsMastered,
    required bool nextIsMastered,
  }) {
    if (!previousIsMastered && nextIsMastered) return 1;
    if (previousIsMastered && !nextIsMastered) return -1;
    return 0;
  }

  Future<void> _upsertRecentStudy({
    required String uid,
    required String subjectId,
    required String chapterId,
    required String chapterName,
    required double progressPercent,
  }) async {
    final metadata = _recentStudyMetadata(subjectId);
    final docId = '${subjectId}_$chapterId';

    await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.userRecentStudies(uid))
          .doc(docId)
          .set({
            'id': docId,
            'subjectId': subjectId,
            'title': chapterName,
            'subject': metadata.subject,
            'lastViewed': 'Just now',
            'iconName': metadata.iconName,
            'colorValue': metadata.colorValue,
            'backgroundColorValue': metadata.backgroundColorValue,
            'progressPercent': progressPercent,
            'viewedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true)),
      tag: AppLogTags.formulasDataSource,
    );
  }

  _StudyMetadata _recentStudyMetadata(String subjectId) {
    if (subjectId.contains('math')) {
      return const _StudyMetadata(
        subject: 'Mathematics',
        iconName: 'calculator',
        colorValue: 0xFFD4A574,
        backgroundColorValue: 0xFFFFEAD1,
      );
    } else if (subjectId.contains('physics')) {
      return const _StudyMetadata(
        subject: 'Physics',
        iconName: 'rocket',
        colorValue: 0xFF3B82F6,
        backgroundColorValue: 0xFFDEEAFF,
      );
    } else if (subjectId.contains('chem')) {
      return const _StudyMetadata(
        subject: 'Chemistry',
        iconName: 'flask-conical',
        colorValue: 0xFFEA580C,
        backgroundColorValue: 0xFFFECDD2,
      );
    } else if (subjectId.contains('bio')) {
      return const _StudyMetadata(
        subject: 'Biology',
        iconName: 'microscope',
        colorValue: 0xFF16A34A,
        backgroundColorValue: 0xFFDCFCE7,
      );
    } else {
      return const _StudyMetadata(
        subject: 'General',
        iconName: 'book-open',
        colorValue: 0xFF00639A,
        backgroundColorValue: 0xFFCEE5FF,
      );
    }
  }

  DocumentReference<Map<String, dynamic>> _chapterProgressRef(
    String uid,
    String subjectId,
    String chapterId,
  ) {
    return _api.doc(
      AppFirestoreCollections.userProgressChapter(uid, subjectId, chapterId),
    );
  }

  @override
  Future<FormulaNote?> getFormulaNote(String formulaId) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    final doc = await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.userFormulaNotes(user.uid))
          .doc(formulaId)
          .get(),
      tag: AppLogTags.formulasDataSource,
    );
    if (!doc.exists) return null;
    return FormulaNote(
      formulaId: doc.id,
      content: doc.data()!['content'] as String? ?? '',
      updatedAt: (doc.data()!['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  @override
  Future<void> saveFormulaNote(FormulaNote note) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.userFormulaNotes(user.uid))
          .doc(note.formulaId)
          .set({
        'content': note.content,
        'updatedAt': Timestamp.fromDate(note.updatedAt),
      }),
      tag: AppLogTags.formulasDataSource,
    );
  }

  @override
  Future<void> deleteFormulaNote(String formulaId) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.userFormulaNotes(user.uid))
          .doc(formulaId)
          .delete(),
      tag: AppLogTags.formulasDataSource,
    );
  }
}


class _StudyMetadata {
  const _StudyMetadata({
    required this.subject,
    required this.iconName,
    required this.colorValue,
    required this.backgroundColorValue,
  });

  final String subject;
  final String iconName;
  final int colorValue;
  final int backgroundColorValue;
}
