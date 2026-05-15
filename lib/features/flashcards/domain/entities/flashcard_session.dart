import 'package:equatable/equatable.dart';
import 'flashcard.dart';

class FlashcardSession extends Equatable {
  const FlashcardSession({
    required this.cards,
    this.currentIndex = 0,
    this.masteredIds = const [],
    this.reviewIds = const [],
    this.isFlipped = false,
  });

  final List<Flashcard> cards;
  final int currentIndex;
  final List<String> masteredIds;
  final List<String> reviewIds;
  final bool isFlipped;

  int get totalCards => cards.length;
  int get remainingCards => totalCards - masteredIds.length;
  int get progressPercent => totalCards > 0 ? (masteredIds.length * 100 ~/ totalCards) : 0;
  bool get isComplete => currentIndex >= cards.length;
  Flashcard? get currentCard => currentIndex < cards.length ? cards[currentIndex] : null;

  FlashcardSession copyWith({
    List<Flashcard>? cards,
    int? currentIndex,
    List<String>? masteredIds,
    List<String>? reviewIds,
    bool? isFlipped,
  }) {
    return FlashcardSession(
      cards: cards ?? this.cards,
      currentIndex: currentIndex ?? this.currentIndex,
      masteredIds: masteredIds ?? this.masteredIds,
      reviewIds: reviewIds ?? this.reviewIds,
      isFlipped: isFlipped ?? this.isFlipped,
    );
  }

  @override
  List<Object?> get props => [cards, currentIndex, masteredIds, reviewIds, isFlipped];
}
