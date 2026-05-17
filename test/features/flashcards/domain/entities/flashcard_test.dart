import 'package:flutter_test/flutter_test.dart';

import 'package:formula_scholar/features/flashcards/domain/entities/flashcard.dart';

void main() {
  group('Flashcard', () {
    const baseCard = Flashcard(
      id: 'fc1',
      title: 'Quadratic Formula',
      latex: 'x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}',
      description: 'Solves ax^2 + bx + c = 0',
      subjectId: 'math',
      subjectName: 'Mathematics',
      chapterId: 'ch1',
      chapterName: 'Algebra',
    );

    test('copyWith preserves unchanged fields', () {
      final copy = baseCard.copyWith(isMastered: true);
      expect(copy.id, 'fc1');
      expect(copy.isMastered, true);
      expect(copy.reviewCount, 0);
    });

    test('copyWith updates SM-2 fields', () {
      final copy = baseCard.copyWith(
        easeFactor: 1.5,
        interval: 6,
        reviewCount: 1,
        lapses: 0,
      );
      expect(copy.easeFactor, 1.5);
      expect(copy.interval, 6);
      expect(copy.reviewCount, 1);
    });

    test('toJson/fromJson round-trip', () {
      final json = baseCard.toJson();
      final restored = Flashcard.fromJson(json);
      expect(restored.id, baseCard.id);
      expect(restored.title, baseCard.title);
      expect(restored.latex, baseCard.latex);
      expect(restored.description, baseCard.description);
      expect(restored.subjectId, baseCard.subjectId);
      expect(restored.subjectName, baseCard.subjectName);
      expect(restored.chapterId, baseCard.chapterId);
      expect(restored.chapterName, baseCard.chapterName);
      expect(restored.difficulty, baseCard.difficulty);
      expect(restored.isMastered, baseCard.isMastered);
      expect(restored.easeFactor, baseCard.easeFactor);
      expect(restored.interval, baseCard.interval);
      expect(restored.reviewCount, baseCard.reviewCount);
      expect(restored.lapses, baseCard.lapses);
      expect(restored.nextReviewAt, baseCard.nextReviewAt);
    });

    test('toJson/fromJson with nextReviewAt', () {
      final now = DateTime(2026, 5, 17, 10, 0, 0);
      final card = baseCard.copyWith(nextReviewAt: now);
      final json = card.toJson();
      expect(json['nextReviewAt'], now.toIso8601String());
      final restored = Flashcard.fromJson(json);
      expect(restored.nextReviewAt, now);
    });

    test('toJson/fromJson with difficulty variations', () {
      for (final diff in FlashcardDifficulty.values) {
        final card = baseCard.copyWith(difficulty: diff);
        final json = card.toJson();
        final restored = Flashcard.fromJson(json);
        expect(restored.difficulty, diff);
      }
    });

    test('equality works correctly', () {
      final identical = baseCard.copyWith();
      const different = Flashcard(
        id: 'fc2',
        title: 'Other',
        latex: 'y',
        description: '',
        subjectId: 'm',
        subjectName: 'M',
        chapterId: 'c',
        chapterName: 'C',
      );
      expect(baseCard, equals(identical));
      expect(baseCard, isNot(equals(different)));
    });
  });
}
