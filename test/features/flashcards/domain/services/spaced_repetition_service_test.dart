import 'package:flutter_test/flutter_test.dart';

import 'package:formula_scholar/features/flashcards/domain/entities/flashcard.dart';
import 'package:formula_scholar/features/flashcards/domain/services/spaced_repetition_service.dart';

void main() {
  group('SpacedRepetitionService', () {
    late SpacedRepetitionService srs;

    setUp(() {
      srs = SpacedRepetitionService();
    });

    const baseCard = Flashcard(
      id: 'test',
      title: 'Test',
      latex: 'x',
      description: '',
      subjectId: 'm',
      subjectName: 'M',
      chapterId: 'c',
      chapterName: 'C',
    );

    group('rateCard', () {
      test('Again resets interval to 1 and increments lapses', () {
        final result = srs.rateCard(baseCard, ReviewQuality.again);
        expect(result.interval, 1);
        expect(result.lapses, 1);
        expect(result.reviewCount, 1);
      });

      test('Hard sets interval to 1 and increments lapses', () {
        final card = baseCard.copyWith(easeFactor: 2.5);
        final result = srs.rateCard(card, ReviewQuality.hard);
        expect(result.interval, 1);
        expect(result.lapses, 1);
        expect(result.reviewCount, 1);
      });

      test('Good on first review sets interval to 1', () {
        final result = srs.rateCard(baseCard, ReviewQuality.good);
        expect(result.interval, 1);
        expect(result.reviewCount, 1);
      });

      test('Good on second review sets interval to 6', () {
        final card = baseCard.copyWith(reviewCount: 1, interval: 1);
        final result = srs.rateCard(card, ReviewQuality.good);
        expect(result.interval, 6);
        expect(result.reviewCount, 2);
      });

      test('Good on third review doubles previous interval', () {
        final card = baseCard.copyWith(reviewCount: 2, interval: 6);
        final result = srs.rateCard(card, ReviewQuality.good);
        expect(result.interval, (6 * 2.5).round());
        expect(result.reviewCount, 3);
      });

      test('Easy increases ease factor', () {
        final result = srs.rateCard(baseCard, ReviewQuality.easy);
        expect(result.easeFactor, greaterThan(2.5));
      });

      test('Card is mastered when interval >= 21', () {
        final card = baseCard.copyWith(
          reviewCount: 5,
          interval: 20,
        );
        final result = srs.rateCard(card, ReviewQuality.easy);
        expect(result.isMastered, true);
        expect(result.interval, greaterThanOrEqualTo(21));
      });

      test('Ease factor never drops below 1.3', () {
        var card = baseCard.copyWith(easeFactor: 2.5);
        // Repeated Again ratings should drop ease factor but floor at 1.3
        for (int i = 0; i < 10; i++) {
          card = srs.rateCard(card, ReviewQuality.again);
        }
        expect(card.easeFactor, greaterThanOrEqualTo(1.3));
      });
    });

    group('isDue', () {
      test('returns true when nextReviewAt is null', () {
        expect(srs.isDue(baseCard), true);
      });

      test('returns true when nextReviewAt is in the past', () {
        final card = baseCard.copyWith(
          nextReviewAt: DateTime.now().subtract(const Duration(days: 1)),
        );
        expect(srs.isDue(card), true);
      });

      test('returns false when nextReviewAt is in the future', () {
        final card = baseCard.copyWith(
          nextReviewAt: DateTime.now().add(const Duration(days: 1)),
        );
        expect(srs.isDue(card), false);
      });
    });

    group('dueCards', () {
      test('returns only due cards', () {
        final past = Flashcard(
          id: 'past',
          title: 'Past',
          latex: 'p',
          description: '',
          subjectId: 'm',
          subjectName: 'M',
          chapterId: 'c',
          chapterName: 'C',
          nextReviewAt: DateTime.now().subtract(const Duration(hours: 1)),
        );
        final future = Flashcard(
          id: 'future',
          title: 'Future',
          latex: 'f',
          description: '',
          subjectId: 'm',
          subjectName: 'M',
          chapterId: 'c',
          chapterName: 'C',
          nextReviewAt: DateTime.now().add(const Duration(days: 1)),
        );
        final result = srs.dueCards([past, future]);
        expect(result.length, 1);
        expect(result.first.id, 'past');
      });
    });
  });
}
