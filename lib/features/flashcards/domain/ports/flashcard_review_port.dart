import '../entities/flashcard.dart';

abstract class FlashcardReviewPort {
  Future<void> saveReview({required String userId, required Flashcard card});

  Future<List<Flashcard>> loadReviews({
    required String userId,
    required List<Flashcard> cards,
  });
}
