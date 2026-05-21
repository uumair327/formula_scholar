library;

import 'package:injectable/injectable.dart';

import '../../../../core/error/result.dart';
import '../entities/flashcard.dart';
import '../ports/flashcard_repository_port.dart';

@injectable
class LoadReviewsUseCase {
  const LoadReviewsUseCase({required FlashcardRepositoryPort repository})
    : _repository = repository;

  final FlashcardRepositoryPort _repository;

  Future<Result<List<Flashcard>>> call({
    required String userId,
    required List<Flashcard> cards,
  }) {
    return _repository.loadReviews(userId: userId, cards: cards);
  }
}
