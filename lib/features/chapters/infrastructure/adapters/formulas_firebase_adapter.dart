import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Firebase adapter for formula data retrieval.
///
/// Reads formulas from `subjects/{subjectId}/chapters/{chapterId}/formulas`.
/// Falls back to seeding mock formulas if the subcollection is empty,
/// guaranteeing the UI always has data to display.
@LazySingleton(as: FormulasDataSourcePort)
class FormulasFirebaseAdapter implements FormulasDataSourcePort {
  FormulasFirebaseAdapter(this._firestore, this._firebaseAuth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<List<Formula>> getFormulas(String subjectId, String chapterId) async {
    AppLogger.trace(
      'getFormulas($subjectId, $chapterId) fetching from Firestore',
      tag: AppLogTags.formulasDataSource,
    );

    final snapshot = await _firestore
        .collection('subjects')
        .doc(subjectId)
        .collection('chapters')
        .doc(chapterId)
        .collection('formulas')
        .get();

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
      // Seed representative formulas if the subcollection doesn't exist yet
      await _seedFormulas(subjectId, chapterId);
      final reFetch = await _firestore
          .collection('subjects')
          .doc(subjectId)
          .collection('chapters')
          .doc(chapterId)
          .collection('formulas')
          .get();
      return reFetch.docs
          .map(
            (doc) => _docToFormula(
              doc,
              bookmarkedIds.contains(doc.id),
              masteryOverride: masteryMap[doc.id],
            ),
          )
          .toList();
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
      await _incrementMasteredFormulaStat(uid, masteryDelta);
    }
  }

  int _masteryDelta({
    required bool previousIsMastered,
    required bool nextIsMastered,
  }) {
    if (!previousIsMastered && nextIsMastered) {
      return 1;
    }
    if (previousIsMastered && !nextIsMastered) {
      return -1;
    }
    return 0;
  }

  Future<void> _incrementMasteredFormulaStat(String uid, int delta) async {
    final statsRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('stats')
        .doc('current');

    await _firestore.runTransaction((tx) async {
      final snapshot = await tx.get(statsRef);
      final data = snapshot.data() ?? const <String, dynamic>{};
      final current = (data['formulas'] as num?)?.toInt() ?? 0;
      final updated = (current + delta).clamp(0, 1000000);

      tx.set(statsRef, {
        'formulas': updated,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
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

  Future<void> _seedFormulas(String subjectId, String chapterId) async {
    AppLogger.info(
      'Seeding formulas for $subjectId/$chapterId',
      tag: AppLogTags.formulasDataSource,
    );

    final batch = _firestore.batch();
    final ref = _firestore
        .collection('subjects')
        .doc(subjectId)
        .collection('chapters')
        .doc(chapterId)
        .collection('formulas');

    final seedData = [
      {
        'id': 'f1',
        'title': 'Core Identity I',
        'latex': r'(a + b)^2 = a^2 + 2ab + b^2',
        'description':
            'Square of a binomial sum — the most fundamental algebraic expansion.',
        'isMastered': true,
      },
      {
        'id': 'f2',
        'title': 'Core Identity II',
        'latex': r'(a - b)^2 = a^2 - 2ab + b^2',
        'description': 'Square of a binomial difference.',
        'isMastered': true,
      },
      {
        'id': 'f3',
        'title': 'Difference of Squares',
        'latex': r'a^2 - b^2 = (a+b)(a-b)',
        'description': 'Factoring a difference of two perfect squares.',
        'isMastered': false,
      },
      {
        'id': 'f4',
        'title': 'Cubic Sum',
        'latex': r'(a+b)^3 = a^3 + 3a^2b + 3ab^2 + b^3',
        'description': 'Expansion of the cube of a binomial sum.',
        'isMastered': false,
      },
    ];

    for (final f in seedData) {
      batch.set(ref.doc(f['id'] as String), f);
    }
    await batch.commit();
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
