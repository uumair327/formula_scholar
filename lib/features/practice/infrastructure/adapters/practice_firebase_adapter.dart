import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

@LazySingleton(as: PracticeDataSourcePort)
class PracticeFirebaseAdapter implements PracticeDataSourcePort {
  PracticeFirebaseAdapter(this._api, this._firebaseAuth);

  final FirestoreClientPort _api;
  final FirebaseAuth _firebaseAuth;

  String _resolveLocalizedField(Map<String, dynamic> data, String key, String fallback) {
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
  Future<List<QuizQuestion>> getQuestions({
    required String curriculumKey,
    String? subjectId,
    String? categoryId,
  }) async {
    AppLogger.debug(
      'getQuestions() fetching from Firestore — curriculumKey=$curriculumKey, subjectId=$subjectId, categoryId=$categoryId',
      tag: AppLogTags.practiceDataSource,
    );

    Query<Map<String, dynamic>> query = _api
        .collection(AppFirestoreCollections.practiceQuestions)
        .where('audiences', arrayContains: curriculumKey);

    if (subjectId != null && subjectId.isNotEmpty) {
      query = query.where('subjectId', isEqualTo: subjectId);
    } else if (categoryId != null && categoryId.isNotEmpty) {
      query = query.where('categoryId', isEqualTo: categoryId);
    }

    var snapshot = await _api.execute(
      () => query.get(),
      tag: AppLogTags.practiceDataSource,
    );

    AppLogger.debug(
      'Primary query returned ${snapshot.docs.length} docs (curriculumKey=$curriculumKey, subjectId=$subjectId)',
      tag: AppLogTags.practiceDataSource,
    );

    if (snapshot.docs.isEmpty) {
      AppLogger.warning(
        'No board/grade-scoped practice questions found for curriculumKey=$curriculumKey subjectId=$subjectId; falling back to legacy dataset',
        tag: AppLogTags.practiceDataSource,
      );
      Query<Map<String, dynamic>> fallbackQuery = _api.collection(
        AppFirestoreCollections.practiceQuestions,
      );
      if (subjectId != null && subjectId.isNotEmpty) {
        fallbackQuery = fallbackQuery.where('subjectId', isEqualTo: subjectId);
      } else if (categoryId != null && categoryId.isNotEmpty) {
        fallbackQuery = fallbackQuery.where('categoryId', isEqualTo: categoryId);
      }

      snapshot = await _api.execute(
        () => fallbackQuery.limit(20).get(),
        tag: AppLogTags.practiceDataSource,
      );
    }

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final optionsList = data['options'] as List<dynamic>? ?? [];
      
      final localizedMap = data['localized'] as Map<String, dynamic>?;
      final currentLocale = AppLocales.normalizeContentLocaleCode(AppLocales.currentLocaleCode);
      final hasLoc = localizedMap != null && localizedMap[currentLocale] != null;
      final locOptions = hasLoc ? (localizedMap[currentLocale]['options'] as List<dynamic>?) : null;
      
      final options = optionsList.map((opt) {
        final optMap = opt as Map<String, dynamic>;
        final optId = optMap['id'] as String? ?? '';
        
        String optText = optMap['text'] as String? ?? '';
        if (locOptions != null) {
          final locOpt = locOptions.firstWhere((lo) => lo['id'] == optId, orElse: () => null);
          if (locOpt != null && locOpt['text'] != null && (locOpt['text'] as String).isNotEmpty) {
             optText = locOpt['text'] as String;
          }
        }
        
        return QuizOption(id: optId, text: optText);
      }).toList();

      final questionText = _resolveLocalizedField(data, 'questionText', data['questionText'] ?? '');
      final topic = _resolveLocalizedField(data, 'topic', data['topic'] ?? '');

      return QuizQuestion(
        id: data['id'] ?? doc.id,
        category: data['category'] as String? ?? data['categoryId'] as String? ?? '',
        topic: topic,
        questionText: questionText,
        imageUrl: data['imageUrl'] ?? '',
        options: options,
        correctOptionId: data['correctOptionId'] ?? '',
        points: data['points'] ?? 10,
      );
    }).toList();
  }

  @override
  Future<void> recordQuizCompletion({
    required String curriculumKey,
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
        'curriculumKey': curriculumKey,
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
    final answersRef = _api.collection(
      AppFirestoreCollections.userQuizAnswers(uid),
    );

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
