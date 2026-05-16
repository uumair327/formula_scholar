import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';

@LazySingleton(as: PracticeDataSourcePort)
class PracticeFirebaseAdapter implements PracticeDataSourcePort {
  PracticeFirebaseAdapter(this._firestore, this._firebaseAuth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<List<QuizQuestion>> getQuestions({
    required String boardId,
    required String gradeId,
    String? subjectId,
  }) async {
    AppLogger.trace(
      'getQuestions() fetching from Firestore for board=$boardId, grade=$gradeId, subject=$subjectId',
      tag: AppLogTags.practiceDataSource,
    );
    
    var query = _firestore
        .collection('practice_questions')
        .where('boardId', isEqualTo: boardId)
        .where('gradeId', isEqualTo: gradeId);
        
    if (subjectId != null && subjectId.isNotEmpty) {
      query = query.where('category', isEqualTo: subjectId);
    }
        
    var snapshot = await query.get();

    // Backward compatibility for older datasets that don't yet store
    // boardId/gradeId on each question document.
    if (snapshot.docs.isEmpty) {
      AppLogger.warning(
        'No board/grade-scoped practice questions found; falling back to legacy dataset',
        tag: AppLogTags.practiceDataSource,
      );
      snapshot = await _firestore
          .collection('practice_questions')
          .limit(20)
          .get();
    }

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final optionsList = data['options'] as List<dynamic>? ?? [];
      final options = optionsList.map((opt) {
        final optMap = opt as Map<String, dynamic>;
        return QuizOption(id: optMap['id'] ?? '', text: optMap['text'] ?? '');
      }).toList();

      return QuizQuestion(
        id: data['id'] ?? doc.id,
        category: data['category'] ?? '',
        topic: data['topic'] ?? '',
        questionText: data['questionText'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        options: options,
        correctOptionId: data['correctOptionId'] ?? '',
        points: data['points'] ?? 10,
      );
    }).toList();
  }

  @override
  Future<void> recordQuizCompletion({
    required String boardId,
    required String gradeId,
    required int earnedPoints,
    required int answeredQuestions,
  }) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      AppLogger.warning(
        'Skipping quiz completion persistence because user is not authenticated',
        tag: AppLogTags.practiceDataSource,
      );
      return;
    }

    final userRef = _firestore.collection('users').doc(uid);

    await UserStatsAccumulator(_firestore).addPoints(uid, earnedPoints);

    final recentStudyRef = userRef.collection('recent_studies').doc('practice');
    await recentStudyRef.set({
      'id': 'practice',
      'subjectId': 'practice',
      'title': 'Practice Quiz',
      'subject': 'General Practice',
      'lastViewed': 'Just now',
      'iconName': 'brain',
      'colorValue': 0xFF655781,
      'backgroundColorValue': 0xFFE9DFFC,
      'boardId': boardId,
      'gradeId': gradeId,
      'answeredQuestions': answeredQuestions,
      'earnedPoints': earnedPoints,
      'viewedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    AppLogger.info(
      'Persisted quiz completion for uid=$uid (points=$earnedPoints, questions=$answeredQuestions)',
      tag: AppLogTags.practiceDataSource,
    );
  }

  @override
  Future<void> saveAnswerRecords(List<QuizAnswerRecord> records) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null || records.isEmpty) return;

    final batch = _firestore.batch();
    final answersRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('quiz_answers');

    for (final record in records) {
      final docRef = answersRef.doc();
      batch.set(docRef, {
        ...record.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
    AppLogger.info(
      'Saved ${records.length} answer records for uid=$uid',
      tag: AppLogTags.practiceDataSource,
    );
  }

  @override
  Future<void> saveQuizResult(QuizResult result) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('quiz_results')
        .doc(result.id);

    await docRef.set({
      ...result.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    AppLogger.info(
      'Saved quiz result ${result.id} for uid=$uid (${result.correctCount}/${result.totalQuestions})',
      tag: AppLogTags.practiceDataSource,
    );
  }

  @override
  Future<List<QuizResult>> getQuizResults({int limit = 20}) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) return const [];

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('quiz_results')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) {
      return QuizResult.fromJson(doc.data());
    }).toList();
  }

  @override
  Future<List<QuizResult>> getRecentQuizResults({int limit = 5}) async {
    return getQuizResults(limit: limit);
  }
}
