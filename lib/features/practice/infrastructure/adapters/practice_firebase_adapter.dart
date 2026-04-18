import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
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
  }) async {
    AppLogger.trace(
      'getQuestions() fetching from Firestore for board=$boardId, grade=$gradeId',
      tag: AppLogTags.practiceDataSource,
    );
    var snapshot = await _firestore
        .collection('practice_questions')
        .where('boardId', isEqualTo: boardId)
        .where('gradeId', isEqualTo: gradeId)
        .get();

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
    final statsRef = userRef.collection('stats').doc('current');
    final nowUtc = DateTime.now().toUtc();
    final todayKey = _dateKey(nowUtc);

    await _firestore.runTransaction((tx) async {
      final snapshot = await tx.get(statsRef);
      final data = snapshot.data() ?? const <String, dynamic>{};

      final currentPoints = (data['points'] as num?)?.toInt() ?? 0;
      final currentStreak = (data['streak'] as num?)?.toInt() ?? 0;
      final lastStudyDate = (data['lastStudyDate'] as String?) ?? '';

      final nextStreak = _calculateNextStreak(
        lastStudyDate,
        todayKey,
        fallbackCurrentStreak: currentStreak,
      );

      tx.set(statsRef, {
        'points': currentPoints + earnedPoints,
        'streak': nextStreak,
        'lastStudyDate': todayKey,
        'lastQuizAt': FieldValue.serverTimestamp(),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });

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

  int _calculateNextStreak(
    String lastStudyDate,
    String todayKey, {
    required int fallbackCurrentStreak,
  }) {
    if (lastStudyDate.isEmpty) {
      return 1;
    }

    if (lastStudyDate == todayKey) {
      return fallbackCurrentStreak > 0 ? fallbackCurrentStreak : 1;
    }

    final parsedLast = DateTime.tryParse(lastStudyDate);
    final parsedToday = DateTime.tryParse(todayKey);
    if (parsedLast == null || parsedToday == null) {
      return 1;
    }

    final dayDelta = parsedToday.difference(parsedLast).inDays;
    if (dayDelta == 1) {
      return fallbackCurrentStreak + 1;
    }

    return 1;
  }

  String _dateKey(DateTime utcDate) {
    final month = utcDate.month.toString().padLeft(2, '0');
    final day = utcDate.day.toString().padLeft(2, '0');
    return '${utcDate.year}-$month-$day';
  }
}
