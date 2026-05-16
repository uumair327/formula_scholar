import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import 'flashcards_state.dart';

@injectable
class FlashcardsCubit extends Cubit<FlashcardsState> {
  FlashcardsCubit({required FlashcardReviewPort reviewPort})
    : _reviewPort = reviewPort,
      super(const FlashcardsState());

  final FlashcardReviewPort _reviewPort;
  final SpacedRepetitionService _srs = SpacedRepetitionService();
  String? _userId;

  Future<void> startSession({
    required List<Flashcard> cards,
    required String userId,
  }) async {
    _userId = userId;
    AppLogger.info(
      'Starting flashcard session with ${cards.length} cards',
      tag: 'FlashcardsCubit',
    );
    final enriched = await _reviewPort.loadReviews(userId: userId, cards: cards);
    final due = _srs.dueCards(enriched);
    final sessionCards = due.isEmpty ? enriched : due;
    emit(FlashcardsState(
      status: FlashcardsStatus.ready,
      session: FlashcardSession(cards: sessionCards),
      totalCardCount: enriched.length,
    ));
  }

  void flipCard() {
    emit(state.copyWith(
      session: state.session.copyWith(isFlipped: !state.session.isFlipped),
    ));
  }

  Future<void> rateCard(ReviewQuality quality) async {
    final current = state.session.currentCard;
    if (current == null) return;

    final updatedCard = _srs.rateCard(current, quality);
    final isGraduated = quality == ReviewQuality.good ||
        quality == ReviewQuality.easy;
    final newIndex = state.session.currentIndex + 1;
    final newMastered = updatedCard.isMastered
        ? [...state.session.masteredIds, current.id]
        : state.session.masteredIds;
    final newReview = !isGraduated
        ? [...state.session.reviewIds, current.id]
        : state.session.reviewIds;
    final newGraduated = isGraduated
        ? [...state.session.graduatedIds, current.id]
        : state.session.graduatedIds;

    final updatedCards = state.session.cards.map((c) {
      if (c.id == current.id) return updatedCard;
      return c;
    }).toList();

    emit(state.copyWith(
      session: state.session.copyWith(
        currentIndex: newIndex,
        cards: updatedCards,
        masteredIds: newMastered,
        reviewIds: newReview,
        graduatedIds: newGraduated,
        isFlipped: false,
      ),
    ));

    final uid = _userId;
    if (uid != null) {
      unawaited(_reviewPort.saveReview(userId: uid, card: updatedCard));
    }

    _checkComplete();
  }

  void _checkComplete() {
    final session = state.session;
    if (session.graduatedIds.length >= session.cards.length) {
      emit(state.copyWith(
        status: FlashcardsStatus.finished,
        reviewSummary: ReviewSummary(
          totalCards: session.totalCards,
          graduated: session.graduatedIds.length,
          mastered: session.masteredIds.length,
        ),
      ));
    }
  }

  void restart() {
    emit(const FlashcardsState());
  }
}
