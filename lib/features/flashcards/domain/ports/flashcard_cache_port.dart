import '../entities/flashcard.dart';

abstract interface class FlashcardCachePort {
  Future<void> cacheReviews(String userId, List<Flashcard> cards);

  Future<List<Flashcard>?> getCachedReviews(String userId);

  Future<void> updateReview(String userId, Flashcard card);
}
