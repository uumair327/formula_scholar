import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';

@LazySingleton(as: PracticeDataSourcePort)
class PracticeFirebaseAdapter implements PracticeDataSourcePort {
  PracticeFirebaseAdapter(this._api, this._firebaseAuth);

  final FirestoreClientPort _api;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<List<QuizQuestion>> getQuestions({
    required String boardId,
    required String gradeId,
    String? subjectId,
    String? categoryId,
  }) async {
    AppLogger.trace(
      'getQuestions() fetching from Firestore for board=$boardId, grade=$gradeId, subject=$subjectId',
      tag: AppLogTags.practiceDataSource,
    );

    var query = _api
        .collection(AppFirestoreCollections.practiceQuestions)
        .where('boardId', isEqualTo: boardId)
        .where('gradeId', isEqualTo: gradeId);

    if (categoryId != null && categoryId.isNotEmpty) {
      query = query.where('category', isEqualTo: categoryId);
    }

    var snapshot = await _api.execute(
      () => query.get(),
      tag: AppLogTags.practiceDataSource,
    );

    if (snapshot.docs.isEmpty) {
      AppLogger.warning(
        'No board/grade-scoped practice questions found; falling back to legacy dataset',
        tag: AppLogTags.practiceDataSource,
      );
      Query<Map<String, dynamic>> fallbackQuery = _api.collection(AppFirestoreCollections.practiceQuestions);
      if (categoryId != null && categoryId.isNotEmpty) {
        fallbackQuery = fallbackQuery.where('category', isEqualTo: categoryId);
      }
      
      snapshot = await _api.execute(
        () => fallbackQuery.limit(20).get(),
        tag: AppLogTags.practiceDataSource,
      );
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

    await UserStatsAccumulator(_api).addPoints(uid, earnedPoints);

    final recentStudyRef = _api
        .collection(AppFirestoreCollections.userRecentStudies(uid))
        .doc('practice');
    await _api.execute(
      () => recentStudyRef.set({
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
      }, SetOptions(merge: true)),
      tag: AppLogTags.practiceDataSource,
    );

    AppLogger.info(
      'Persisted quiz completion for uid=$uid (points=$earnedPoints, questions=$answeredQuestions)',
      tag: AppLogTags.practiceDataSource,
    );
  }

  @override
  Future<void> saveAnswerRecords(List<QuizAnswerRecord> records) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null || records.isEmpty) return;

    final batch = _api.batch();
    final answersRef = _api
        .collection(AppFirestoreCollections.userQuizAnswers(uid));

    for (final record in records) {
      final docRef = answersRef.doc();
      batch.set(docRef, {
        ...record.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await _api.execute(
      () => batch.commit(),
      tag: AppLogTags.practiceDataSource,
    );
    AppLogger.info(
      'Saved ${records.length} answer records for uid=$uid',
      tag: AppLogTags.practiceDataSource,
    );
  }

  @override
  Future<void> saveQuizResult(QuizResult result) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) return;

    final docRef = _api
        .collection(AppFirestoreCollections.userQuizResults(uid))
        .doc(result.id);

    await _api.execute(
      () => docRef.set({
        ...result.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
      }),
      tag: AppLogTags.practiceDataSource,
    );

    AppLogger.info(
      'Saved quiz result ${result.id} for uid=$uid (${result.correctCount}/${result.totalQuestions})',
      tag: AppLogTags.practiceDataSource,
    );
  }

  @override
  Future<List<QuizResult>> getQuizResults({int limit = 20}) async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) return const [];

    final snapshot = await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.userQuizResults(uid))
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get(),
      tag: AppLogTags.practiceDataSource,
    );

    return snapshot.docs.map((doc) {
      return QuizResult.fromJson(doc.data());
    }).toList();
  }

  @override
  Future<List<QuizResult>> getRecentQuizResults({int limit = 5}) async {
    return getQuizResults(limit: limit);
  }
}
