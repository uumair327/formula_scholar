import 'package:flutter_test/flutter_test.dart';

import 'package:formula_scholar/features/flashcards/domain/entities/flashcard.dart';
import 'package:formula_scholar/features/flashcards/domain/entities/flashcard_session.dart';

void main() {
  group('FlashcardSession', () {
    const cards = [
      Flashcard(
        id: 'a',
        title: 'A',
        latex: 'a',
        description: '',
        subjectId: 'm',
        subjectName: 'M',
        chapterId: 'c',
        chapterName: 'C',
      ),
      Flashcard(
        id: 'b',
        title: 'B',
        latex: 'b',
        description: '',
        subjectId: 'm',
        subjectName: 'M',
        chapterId: 'c',
        chapterName: 'C',
      ),
    ];

    test('currentCard returns null when out of range', () {
      const session = FlashcardSession(cards: []);
      expect(session.currentCard, isNull);
    });

    test('currentCard returns first card by default', () {
      const session = FlashcardSession(cards: cards);
      expect(session.currentCard?.id, 'a');
    });

    test('totalCards returns card count', () {
      const session = FlashcardSession(cards: cards);
      expect(session.totalCards, 2);
    });

    test('remainingCards starts at total', () {
      const session = FlashcardSession(cards: cards);
      expect(session.remainingCards, 2);
    });

    test('remainingCards decreases with graduated', () {
      const session = FlashcardSession(
        cards: cards,
        graduatedIds: ['a'],
      );
      expect(session.remainingCards, 1);
    });

    test('isComplete when all graduated', () {
      const session = FlashcardSession(
        cards: cards,
        graduatedIds: ['a', 'b'],
      );
      expect(session.isComplete, true);
    });

    test('progressPercent is 0 when none graduated', () {
      const session = FlashcardSession(cards: cards);
      expect(session.progressPercent, 0);
    });

    test('progressPercent is 50 when half graduated', () {
      const session = FlashcardSession(
        cards: cards,
        graduatedIds: ['a'],
      );
      expect(session.progressPercent, 50);
    });

    test('copyWith preserves unchanged fields', () {
      const session = FlashcardSession(cards: cards);
      final copy = session.copyWith(isFlipped: true);
      expect(copy.cards, cards);
      expect(copy.isFlipped, true);
      expect(copy.currentIndex, 0);
    });

    test('equality works correctly', () {
      const a = FlashcardSession(cards: cards);
      const b = FlashcardSession(cards: cards);
      final c = FlashcardSession(cards: [cards[0]]);
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });
  });
}
