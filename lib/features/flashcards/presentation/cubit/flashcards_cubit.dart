import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';
import 'flashcards_state.dart';

@injectable
class FlashcardsCubit extends Cubit<FlashcardsState> {
  FlashcardsCubit() : super(const FlashcardsState());

  void startSession(List<Flashcard> cards) {
    emit(FlashcardsState(
      status: FlashcardsStatus.ready,
      session: FlashcardSession(cards: cards),
    ));
  }

  void flipCard() {
    emit(state.copyWith(
      session: state.session.copyWith(isFlipped: !state.session.isFlipped),
    ));
  }

  void markMastered() {
    final current = state.session.currentCard;
    if (current == null) return;

    final newMastered = [...state.session.masteredIds, current.id];
    final nextIndex = state.session.currentIndex + 1;

    emit(state.copyWith(
      session: state.session.copyWith(
        currentIndex: nextIndex,
        masteredIds: newMastered,
        isFlipped: false,
        cards: state.session.cards.map((c) =>
          c.id == current.id ? c.copyWith(isMastered: true) : c
        ).toList(),
      ),
    ));

    _checkComplete();
  }

  void markForReview() {
    final current = state.session.currentCard;
    if (current == null) return;

    final newReview = [...state.session.reviewIds, current.id];
    final nextIndex = state.session.currentIndex + 1;

    emit(state.copyWith(
      session: state.session.copyWith(
        currentIndex: nextIndex,
        reviewIds: newReview,
        isFlipped: false,
      ),
    ));

    _checkComplete();
  }

  void _checkComplete() {
    if (state.session.currentIndex >= state.session.cards.length) {
      emit(state.copyWith(status: FlashcardsStatus.finished));
    }
  }

  void restart() {
    emit(const FlashcardsState());
  }
}
