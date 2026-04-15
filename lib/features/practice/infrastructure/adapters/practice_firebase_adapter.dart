import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

@LazySingleton(as: PracticeDataSourcePort)
class PracticeFirebaseAdapter implements PracticeDataSourcePort {
  PracticeFirebaseAdapter(this._firestore);

  final FirebaseFirestore _firestore;

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
}
