library;

import 'package:injectable/injectable.dart';

import '../../../../core/error/result.dart';
import '../entities/flashcard.dart';
import '../ports/flashcard_repository_port.dart';

@injectable
class SaveReviewUseCase {
  const SaveReviewUseCase({required FlashcardRepositoryPort repository})
    : _repository = repository;

  final FlashcardRepositoryPort _repository;

  Future<Result<void>> call({required String userId, required Flashcard card}) {
    return _repository.saveReview(userId: userId, card: card);
  }
}
