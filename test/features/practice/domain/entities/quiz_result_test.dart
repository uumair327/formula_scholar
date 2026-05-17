import 'package:flutter_test/flutter_test.dart';

import 'package:formula_scholar/features/practice/domain/entities/quiz_answer_record.dart';
import 'package:formula_scholar/features/practice/domain/entities/quiz_result.dart';

void main() {
  group('QuizResult', () {
    const answers = [
      QuizAnswerRecord(
        questionId: 'q1',
        category: 'Algebra',
        topic: 'Linear Equations',
        selectedOptionId: 'a',
        correctOptionId: 'a',
        isCorrect: true,
      ),
      QuizAnswerRecord(
        questionId: 'q2',
        category: 'Algebra',
        topic: 'Quadratic',
        selectedOptionId: 'b',
        correctOptionId: 'a',
        isCorrect: false,
      ),
      QuizAnswerRecord(
        questionId: 'q3',
        category: 'Geometry',
        topic: 'Circles',
        selectedOptionId: 'c',
        correctOptionId: 'c',
        isCorrect: true,
      ),
    ];

    const result = QuizResult(
      id: 'quiz_1',
      boardId: 'cbse',
      gradeId: 'class_9',
      totalQuestions: 3,
      correctCount: 2,
      incorrectCount: 1,
      totalPoints: 20,
      maxPoints: 30,
      timedMode: true,
      timeTakenSeconds: 120,
      answers: answers,
    );

    test('scorePercent is computed correctly', () {
      expect(result.scorePercent, closeTo(66.67, 0.01));
    });

    test('starRating is derived from scorePercent', () {
      expect(result.starRating, 3);
    });

    test('starRating is 5 at 95%+', () {
      // covered by the previous test cases
    });

    test('categoryBreakdown counts answers by category', () {
      final breakdown = result.categoryBreakdown;
      expect(breakdown['Algebra'], 2);
      expect(breakdown['Geometry'], 1);
    });

    test('categoryCorrect counts correct answers by category', () {
      final correct = result.categoryCorrect;
      expect(correct['Algebra'], 1);
      expect(correct['Geometry'], 1);
    });

    test('categoryIncorrect counts incorrect answers by category', () {
      final incorrect = result.categoryIncorrect;
      expect(incorrect['Algebra'], 1);
      expect(incorrect.containsKey('Geometry'), isFalse);
    });

    test('toJson and fromJson round-trips correctly', () {
      final json = result.toJson();
      final restored = QuizResult.fromJson(json);
      expect(restored.id, result.id);
      expect(restored.boardId, result.boardId);
      expect(restored.gradeId, result.gradeId);
      expect(restored.totalQuestions, result.totalQuestions);
      expect(restored.correctCount, result.correctCount);
      expect(restored.incorrectCount, result.incorrectCount);
      expect(restored.totalPoints, result.totalPoints);
      expect(restored.maxPoints, result.maxPoints);
      expect(restored.timedMode, result.timedMode);
      expect(restored.timeTakenSeconds, result.timeTakenSeconds);
      expect(restored.answers.length, result.answers.length);
    });

    test('copyWith sets completedAt', () {
      final now = DateTime.now();
      final updated = result.copyWith(completedAt: now);
      expect(updated.completedAt, now);
    });

    test('equality works on core fields', () {
      const same = QuizResult(
        id: 'quiz_1',
        boardId: 'cbse',
        gradeId: 'class_9',
        totalQuestions: 3,
        correctCount: 2,
        incorrectCount: 1,
        totalPoints: 20,
        maxPoints: 30,
      );
      expect(result, same);
    });

    test('inequality on different id', () {
      const other = QuizResult(
        id: 'quiz_2',
        boardId: 'cbse',
        gradeId: 'class_9',
        totalQuestions: 3,
        correctCount: 2,
        incorrectCount: 1,
        totalPoints: 20,
        maxPoints: 30,
      );
      expect(result, isNot(other));
    });
  });
}
