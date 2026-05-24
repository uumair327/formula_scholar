import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

@LazySingleton(as: FlashcardReviewPort)
class FirestoreFlashcardReviewAdapter implements FlashcardReviewPort {
  FirestoreFlashcardReviewAdapter(this._api);

  final FirestoreClientPort _api;

  CollectionReference _reviewsRef(String uid) =>
      _api.collection(AppFirestoreCollections.userFlashcardReviews(uid));

  @override
  Future<void> saveReview({
    required String userId,
    required Flashcard card,
  }) async {
    await _api.execute(
      () => _reviewsRef(userId).doc(card.id).set({
        'easeFactor': card.easeFactor,
        'interval': card.interval,
        'reviewCount': card.reviewCount,
        'lapses': card.lapses,
        'isMastered': card.isMastered,
        'nextReviewAt': card.nextReviewAt != null
            ? Timestamp.fromDate(card.nextReviewAt!)
            : null,
        'lastReviewedAt': Timestamp.now(),
        'title': card.title,
        'latex': card.latex,
        'subjectId': card.subjectId,
        'chapterId': card.chapterId,
        'updatedAt': Timestamp.now(),
      }),
      tag: AppLogTags.flashcardsDataSource,
    );
  }

  @override
  Future<List<Flashcard>> loadReviews({
    required String userId,
    required List<Flashcard> cards,
  }) async {
    final snapshot = await _api.execute(
      () => _reviewsRef(userId).get(),
      tag: AppLogTags.flashcardsDataSource,
    );
    if (snapshot.docs.isEmpty) return cards;

    final reviewMap = <String, Map<String, dynamic>>{};
    for (final doc in snapshot.docs) {
      reviewMap[doc.id] = doc.data() as Map<String, dynamic>;
    }

    return cards.map((card) {
      final data = reviewMap[card.id];
      if (data == null) return card;

      final nextReviewAt = data['nextReviewAt'] as Timestamp?;
      return card.copyWith(
        easeFactor: (data['easeFactor'] as num?)?.toDouble() ?? 2.5,
        interval: data['interval'] as int? ?? 0,
        reviewCount: data['reviewCount'] as int? ?? 0,
        lapses: data['lapses'] as int? ?? 0,
        isMastered: data['isMastered'] as bool? ?? false,
        nextReviewAt: nextReviewAt?.toDate(),
      );
    }).toList();
  }
}
