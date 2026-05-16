import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

enum FlashcardsStatus { initial, loading, ready, finished }

class FlashcardsState extends Equatable {
  const FlashcardsState({
    this.status = FlashcardsStatus.initial,
    this.session = const FlashcardSession(cards: []),
    this.reviewSummary,
    this.totalCardCount = 0,
  });

  final FlashcardsStatus status;
  final FlashcardSession session;
  final ReviewSummary? reviewSummary;
  final int totalCardCount;

  FlashcardsState copyWith({
    FlashcardsStatus? status,
    FlashcardSession? session,
    ReviewSummary? reviewSummary,
    int? totalCardCount,
  }) {
    return FlashcardsState(
      status: status ?? this.status,
      session: session ?? this.session,
      reviewSummary: reviewSummary ?? this.reviewSummary,
      totalCardCount: totalCardCount ?? this.totalCardCount,
    );
  }

  @override
  List<Object?> get props => [status, session, reviewSummary, totalCardCount];
}

class ReviewSummary extends Equatable {
  const ReviewSummary({
    required this.totalCards,
    required this.graduated,
    required this.mastered,
  });

  final int totalCards;
  final int graduated;
  final int mastered;

  @override
  List<Object?> get props => [totalCards, graduated, mastered];
}
