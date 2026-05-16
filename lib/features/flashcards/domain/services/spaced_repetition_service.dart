import '../entities/flashcard.dart';

enum ReviewQuality { again, hard, good, easy }

/// SM-2 spaced repetition algorithm implementation.
///
/// Based on the SuperMemo SM-2 algorithm with a simplified 4-point scale
/// (Again, Hard, Good, Easy) mapped to qualities 1-4.
class SpacedRepetitionService {
  static const double _minEaseFactor = 1.3;
  static const int _maxInterval = 365;

  /// Applies the SM-2 algorithm and returns an updated [Flashcard].
  Flashcard rateCard(Flashcard card, ReviewQuality quality) {
    final q = _qualityScore(quality);
    final newEaseFactor = _computeEaseFactor(card.easeFactor, q);
    final newInterval = _computeInterval(card.interval, q, card.reviewCount);
    final newReviewCount = card.reviewCount + 1;
    final newLapses = q < 3 ? card.lapses + 1 : card.lapses;
    final newNextReviewAt =
        DateTime.now().add(Duration(days: newInterval));

    return card.copyWith(
      easeFactor: newEaseFactor,
      interval: newInterval,
      reviewCount: newReviewCount,
      lapses: newLapses,
      nextReviewAt: newNextReviewAt,
      isMastered: newInterval >= 21,
    );
  }

  double _qualityScore(ReviewQuality quality) {
    return switch (quality) {
      ReviewQuality.again => 1,
      ReviewQuality.hard => 2,
      ReviewQuality.good => 3,
      ReviewQuality.easy => 4,
    };
  }

  double _computeEaseFactor(double ef, double q) {
    final newEf = ef + (0.1 - (4 - q) * (0.08 + (4 - q) * 0.02));
    return newEf < _minEaseFactor ? _minEaseFactor : newEf;
  }

  int _computeInterval(int previousInterval, double q, int reviewCount) {
    if (q < 3) return 1;

    if (reviewCount == 0) return 1;
    if (reviewCount == 1) return 6;

    final interval = (previousInterval * 2.5).round();
    return interval > _maxInterval ? _maxInterval : interval;
  }

  /// Whether a card is due for review based on its next review date.
  bool isDue(Flashcard card) {
    final next = card.nextReviewAt;
    return next == null || next.isBefore(DateTime.now());
  }

  /// Filters a list of cards to only those due for review.
  List<Flashcard> dueCards(List<Flashcard> cards) {
    return cards.where(isDue).toList();
  }
}
