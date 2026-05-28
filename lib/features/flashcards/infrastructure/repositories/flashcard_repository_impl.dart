import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

@LazySingleton(as: FlashcardRepositoryPort)
class FlashcardRepositoryImpl implements FlashcardRepositoryPort {
  const FlashcardRepositoryImpl({
    required FlashcardReviewPort dataSource,
    required FlashcardCachePort cache,
  }) : _dataSource = dataSource,
       _cache = cache;

  final FlashcardReviewPort _dataSource;
  final FlashcardCachePort _cache;

  @override
  Future<Result<List<Flashcard>>> loadReviews({
    required String userId,
    required List<Flashcard> cards,
  }) {
    return safeOperation(
      tag: AppLogTags.flashcardsRepo,
      operation: 'loadReviews($userId, ${cards.length} cards)',
      execute: () async {
        final result = await _dataSource.loadReviews(
          userId: userId,
          cards: cards,
        );
        await _cache.cacheReviews(userId, result);
        return result;
      },
      fallback: () => _cache.getCachedReviews(userId),
    );
  }

  @override
  Future<Result<void>> saveReview({
    required String userId,
    required Flashcard card,
  }) {
    return safeOperation(
      tag: AppLogTags.flashcardsRepo,
      operation: 'saveReview($userId, ${card.id})',
      execute: () async {
        await _dataSource.saveReview(userId: userId, card: card);
        await _cache.updateReview(userId, card);
      },
    );
  }
}
