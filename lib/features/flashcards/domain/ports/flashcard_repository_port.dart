import '../../../../core/error/result.dart';
import '../entities/flashcard.dart';

abstract interface class FlashcardRepositoryPort {
  Future<Result<List<Flashcard>>> loadReviews({
    required String userId,
    required List<Flashcard> cards,
  });

  Future<Result<void>> saveReview({
    required String userId,
    required Flashcard card,
  });
}
