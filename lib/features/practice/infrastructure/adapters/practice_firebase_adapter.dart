import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

@LazySingleton(as: PracticeDataSourcePort)
class PracticeFirebaseAdapter implements PracticeDataSourcePort {
  final FirebaseFirestore _firestore;

  PracticeFirebaseAdapter(this._firestore);

  @override
  Future<List<QuizQuestion>> getQuestions() async {
    AppLogger.trace('getQuestions() fetching from Firestore', tag: AppLogTags.practiceDataSource);
    final snapshot = await _firestore.collection('practice_questions').get();
    
    return snapshot.docs.map((doc) {
      final data = doc.data();
      final optionsList = data['options'] as List<dynamic>? ?? [];
      final options = optionsList.map((opt) {
        final optMap = opt as Map<String, dynamic>;
        return QuizOption(
          id: optMap['id'] ?? '',
          text: optMap['text'] ?? '',
        );
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
