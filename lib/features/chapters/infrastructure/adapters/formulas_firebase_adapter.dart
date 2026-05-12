import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';

/// Firebase adapter for formula data retrieval.
///
/// Reads formulas from `subjects/{subjectId}/chapters/{chapterId}/formulas`.
/// Returns an empty list if the collection is empty — the caller/UI is
/// responsible for showing an appropriate empty state.
@LazySingleton(as: FormulasDataSourcePort)
class FormulasFirebaseAdapter implements FormulasDataSourcePort {
  FormulasFirebaseAdapter(this._firestore, this._firebaseAuth)
      : _statsAccumulator = UserStatsAccumulator(_firestore);

  final FirebaseFirestore _firestore;
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

    var snapshot = await _firestore
        .collection('subjects')
        .doc(subjectId)
        .collection('chapters')
        .doc(chapterId)
        .collection('formulas')
        .where(
          Filter.or(
            Filter('isGeneralContent', isEqualTo: true),
            Filter('canonicalScopeTags', arrayContains: curriculumKey),
            Filter(
              'audiences',
              arrayContains: curriculumKey,
            ), // Legacy fallback
          ),
        )
        .get();

    // Legacy fallback or fully universal fallback
    if (snapshot.docs.isEmpty) {
      snapshot = await _firestore
          .collection('subjects')
          .doc(subjectId)
          .collection('chapters')
          .doc(chapterId)
          .collection('formulas')
          .get();
    }

    Set<String> bookmarkedIds = {};
    final masteryMap = <String, bool>{};
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid != null) {
      final bookmarksSnap = await _firestore
          .collection('users')
          .doc(uid)
          .collection('bookmarks')
          .get();
      bookmarkedIds = bookmarksSnap.docs.map((d) => d.id).toSet();

      final masterySnap = await _firestore
          .collection('users')
          .doc(uid)
          .collection('progress')
          .doc(subjectId)
          .collection('chapters')
          .doc(chapterId)
          .collection('formulas')
          .get();
      for (final doc in masterySnap.docs) {
        masteryMap[doc.id] = doc.data()['isMastered'] as bool? ?? false;
      }
    }

    if (snapshot.docs.isEmpty) {
      // No formulas found — return empty list so the UI can show an
      // appropriate empty state. Content should be added via the Dashboard.
      AppLogger.info(
        'No formulas found for $subjectId/$chapterId',
        tag: AppLogTags.formulasDataSource,
      );
      return [];
    }

    return snapshot.docs
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

    final docRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('bookmarks')
        .doc(formula.id);

    if (formula.isBookmarked) {
      await docRef.delete();
      AppLogger.info(
        'Removed bookmark for ${formula.id}',
        tag: AppLogTags.formulasDataSource,
      );
    } else {
      await docRef.set({
        'id': formula.id,
        'title': formula.title,
        'subject': subjectName,
        'formula': formula.latex,
        'curriculumKey': curriculumKey,
        'savedAt': FieldValue.serverTimestamp(),
      });
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
    final snapshot = await chapterProgressRef.get();
    final data = snapshot.data() ?? const <String, dynamic>{};

    final completedFormulas = (data['completedFormulas'] as num?)?.toInt() ?? 0;
    final progressPercent = totalFormulas > 0
        ? (completedFormulas / totalFormulas) * 100
        : 0.0;

    await chapterProgressRef.set({
      'chapterId': chapterId,
      'chapterName': chapterName,
      'status': completedFormulas > 0 ? 'inProgress' : 'notStarted',
      'completedFormulas': completedFormulas,
      'totalFormulas': totalFormulas,
      'progressPercent': progressPercent,
      'startedAt': data['startedAt'] ?? FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _upsertRecentStudy(
      uid: uid,
      subjectId: subjectId,
      chapterId: chapterId,
      chapterName: chapterName,
      progressPercent: progressPercent,
    );

    // Bump daily streak whenever the user studies a chapter.
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
    final previousFormulaSnapshot = await formulaRef.get();
    final previousIsMastered =
        previousFormulaSnapshot.data()?['isMastered'] as bool? ?? false;

    await formulaRef.set({
      'id': formulaId,
      'uid': uid,
      'isMastered': isMastered,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    final masteredSnap = await chapterProgressRef
        .collection('formulas')
        .where('isMastered', isEqualTo: true)
        .get();

    final completedFormulas = masteredSnap.docs.length;
    final progressPercent = totalFormulas > 0
        ? (completedFormulas / totalFormulas) * 100
        : 0.0;

    await chapterProgressRef.set({
      'chapterId': chapterId,
      'chapterName': chapterName,
      'status': completedFormulas > 0 ? 'inProgress' : 'notStarted',
      'completedFormulas': completedFormulas,
      'totalFormulas': totalFormulas,
      'progressPercent': progressPercent,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

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

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('recent_studies')
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
        }, SetOptions(merge: true));
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
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('progress')
        .doc(subjectId)
        .collection('chapters')
        .doc(chapterId);
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
