import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';
import '../../../achievements/domain/domain.dart';

import 'flashcards_state.dart';

@injectable
class FlashcardsCubit extends Cubit<FlashcardsState>
    with CubitFailureLogger<FlashcardsState> {
  FlashcardsCubit({
    required LoadReviewsUseCase loadReviews,
    required SaveReviewUseCase saveReview,
    required ReportAchievementProgressUseCase reportAchievement,
  }) : _loadReviews = loadReviews,
       _saveReview = saveReview,
       _reportAchievement = reportAchievement,
       super(const FlashcardsState());

  final LoadReviewsUseCase _loadReviews;
  final SaveReviewUseCase _saveReview;
  final ReportAchievementProgressUseCase _reportAchievement;
  final SpacedRepetitionService _srs = SpacedRepetitionService();
  String? _userId;

  @override
  String get logTag => AppLogTags.flashcardsCubit;

  Future<void> startSession({
    required List<Flashcard> cards,
    required String userId,
  }) async {
    _userId = userId;
    AppLogger.info(
      'Starting flashcard session with ${cards.length} cards',
      tag: AppLogTags.flashcardsCubit,
    );
    final result = await _loadReviews(userId: userId, cards: cards);
    switch (result) {
      case Success(:final data):
        final due = _srs.dueCards(data);
        final sessionCards = due.isEmpty ? data : due;
        emit(
          FlashcardsState(
            status: FlashcardsStatus.ready,
            session: FlashcardSession(cards: sessionCards),
            totalCardCount: data.length,
          ),
        );
      case Error(:final failure):
        logFailure('loadReviews', failure);
    }
  }

  void flipCard() {
    emit(
      state.copyWith(
        session: state.session.copyWith(isFlipped: !state.session.isFlipped),
      ),
    );
  }

  Future<void> rateCard(ReviewQuality quality) async {
    final current = state.session.currentCard;
    if (current == null) return;

    final updatedCard = _srs.rateCard(current, quality);
    final isGraduated =
        quality == ReviewQuality.good || quality == ReviewQuality.easy;
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

    emit(
      state.copyWith(
        session: state.session.copyWith(
          currentIndex: newIndex,
          cards: updatedCards,
          masteredIds: newMastered,
          reviewIds: newReview,
          graduatedIds: newGraduated,
          isFlipped: false,
        ),
      ),
    );

    final uid = _userId;
    if (uid != null) {
      final saveResult = await _saveReview(userId: uid, card: updatedCard);
      if (saveResult is Error<void>) {
        logFailure('saveReview', saveResult.failure);
      }
    }

    _checkComplete();
  }

  void _checkComplete() {
    final session = state.session;
    if (session.graduatedIds.length >= session.cards.length) {
      emit(
        state.copyWith(
          status: FlashcardsStatus.finished,
          reviewSummary: ReviewSummary(
            totalCards: session.totalCards,
            graduated: session.graduatedIds.length,
            mastered: session.masteredIds.length,
          ),
        ),
      );
      _reportAchievementProgress();
    }
  }

  void _reportAchievementProgress() {
    final graduated = state.session.graduatedIds.length;
    unawaited(_reportAchievement('first_flashcard', graduated));
    unawaited(_reportAchievement('ten_flashcards', graduated));
  }

  void restart() {
    emit(const FlashcardsState());
  }
}
