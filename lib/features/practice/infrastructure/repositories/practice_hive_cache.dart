import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

/// Hive-backed cache for practice/quiz data, enabling offline-first access.
///
/// Follows the same pattern established by [ChaptersHiveCache] and [DashboardHiveCache].
@LazySingleton(as: PracticeCachePort)
class PracticeHiveCache implements PracticeCachePort {
  static const String _boxName = 'practice_cache';

  Future<Box<dynamic>> _box() => Hive.openBox<dynamic>(_boxName);

  String _key(String boardId, String gradeId, String? subjectId) =>
      'practice_${boardId}_${gradeId}_${subjectId ?? '_all'}';

  @override
  Future<void> cacheQuestions(
    String boardId,
    String gradeId,
    String? subjectId,
    List<QuizQuestion> questions,
  ) async {
    final box = await _box();
    await box.put(
      _key(boardId, gradeId, subjectId),
      questions
          .map(
            (q) => {
              'id': q.id,
              'category': q.category,
              'topic': q.topic,
              'questionText': q.questionText,
              'imageUrl': q.imageUrl,
              'options': q.options
                  .map((o) => {'id': o.id, 'text': o.text})
                  .toList(),
              'correctOptionId': q.correctOptionId,
              'points': q.points,
            },
          )
          .toList(),
    );
  }

  @override
  Future<List<QuizQuestion>> getQuestions(
    String boardId,
    String gradeId,
    String? subjectId,
  ) async {
    final box = await _box();
    final cached = box.get(_key(boardId, gradeId, subjectId)) as List<dynamic>?;
    if (cached == null) {
      return const [];
    }

    return cached
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map((item) {
          final optionsData = (item['options'] as List<dynamic>?)
                  ?.whereType<Map>()
                  .map((o) => QuizOption(
                        id: o['id'] as String? ?? '',
                        text: o['text'] as String? ?? '',
                      ))
                  .toList() ??
              const [];

          return QuizQuestion(
            id: item['id'] as String? ?? '',
            category: item['category'] as String? ?? '',
            topic: item['topic'] as String? ?? '',
            questionText: item['questionText'] as String? ?? '',
            imageUrl: item['imageUrl'] as String? ?? '',
            options: optionsData,
            correctOptionId: item['correctOptionId'] as String? ?? '',
            points: (item['points'] as num?)?.toInt() ?? 10,
          );
        })
        .toList();
  }
}
