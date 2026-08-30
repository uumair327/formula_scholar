import 'package:flutter_test/flutter_test.dart';
import 'package:formula_scholar/core/core.dart';
import 'package:formula_scholar/features/achievements/domain/domain.dart';
import 'package:formula_scholar/features/flashcards/domain/domain.dart';
import 'package:formula_scholar/features/flashcards/presentation/cubit/flashcards_cubit.dart';
import 'package:formula_scholar/features/flashcards/presentation/cubit/flashcards_state.dart';

class _FakeLoadReviewsUseCase extends LoadReviewsUseCase {
  _FakeLoadReviewsUseCase() : super(repository: _FakeFlashcardRepository());

  @override
  Future<Result<List<Flashcard>>> call({
    required String userId,
    required List<Flashcard> cards,
  }) async {
    return Success(cards);
  }
}

class _FakeSaveReviewUseCase extends SaveReviewUseCase {
  _FakeSaveReviewUseCase() : super(repository: _FakeFlashcardRepository());

  @override
  Future<Result<void>> call({
    required String userId,
    required Flashcard card,
  }) async {
    return const Success(null);
  }
}

class _FakeReportAchievementProgressUseCase
    extends ReportAchievementProgressUseCase {
  _FakeReportAchievementProgressUseCase()
    : super(repository: _FakeAchievementRepository());

  @override
  Future<Result<void>> call(String achievementId, int increment) async {
    return const Success(null);
  }
}

class _FakeFlashcardRepository implements FlashcardRepositoryPort {
  @override
  Future<Result<List<Flashcard>>> loadReviews({
    required String userId,
    required List<Flashcard> cards,
  }) async => Success(cards);

  @override
  Future<Result<void>> saveReview({
    required String userId,
    required Flashcard card,
  }) async => const Success(null);
}

class _FakeAchievementRepository implements AchievementRepositoryPort {
  @override
  Future<Result<List<Achievement>>> getAchievements() async =>
      const Success([]);

  @override
  Future<Result<void>> reportProgress(
    String achievementId,
    int increment,
  ) async => const Success(null);
}

void main() {
  late FlashcardsCubit cubit;

  const testCards = [
    Flashcard(
      id: 'f1',
      title: 'Pythagorean Theorem',
      latex: r'a^2 + b^2 = c^2',
      description: 'Right triangles',
      subjectId: 'math',
      subjectName: 'Mathematics',
      chapterId: 'geo',
      chapterName: 'Geometry',
    ),
    Flashcard(
      id: 'f2',
      title: 'Circle Area',
      latex: r'\pi r^2',
      description: 'Area of circle',
      subjectId: 'math',
      subjectName: 'Mathematics',
      chapterId: 'geo',
      chapterName: 'Geometry',
    ),
  ];

  setUp(() {
    cubit = FlashcardsCubit(
      loadReviews: _FakeLoadReviewsUseCase(),
      saveReview: _FakeSaveReviewUseCase(),
      reportAchievement: _FakeReportAchievementProgressUseCase(),
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is correct', () {
    expect(cubit.state, const FlashcardsState());
    expect(cubit.state.status, FlashcardsStatus.initial);
  });

  test('startSession loads cards and sets status to ready', () async {
    await cubit.startSession(cards: testCards, userId: 'user1');

    expect(cubit.state.status, FlashcardsStatus.ready);
    expect(cubit.state.session.totalCards, 2);
    expect(cubit.state.session.currentCard?.id, 'f1');
    expect(cubit.state.session.isFlipped, false);
  });

  test('flipCard toggles isFlipped in session', () async {
    await cubit.startSession(cards: testCards, userId: 'user1');

    cubit.flipCard();
    expect(cubit.state.session.isFlipped, true);

    cubit.flipCard();
    expect(cubit.state.session.isFlipped, false);
  });

  test('rateCard advances index and records graduated or review', () async {
    await cubit.startSession(cards: testCards, userId: 'user1');

    // Rate card 1 as good (graduated)
    await cubit.rateCard(ReviewQuality.good);
    expect(cubit.state.session.currentIndex, 1);
    expect(cubit.state.session.graduatedIds, ['f1']);
    expect(cubit.state.session.currentCard?.id, 'f2');
    expect(cubit.state.session.isFlipped, false);

    // Rate card 2 as again (review) -> should finish session since index >= 2
    await cubit.rateCard(ReviewQuality.again);
    expect(cubit.state.status, FlashcardsStatus.finished);
    expect(cubit.state.session.reviewIds, ['f2']);
    expect(cubit.state.reviewSummary?.graduated, 1);
    expect(cubit.state.reviewSummary?.totalCards, 2);
  });

  test('reviewRemaining starts new session with review cards only', () async {
    await cubit.startSession(cards: testCards, userId: 'user1');
    await cubit.rateCard(ReviewQuality.good); // f1
    await cubit.rateCard(ReviewQuality.again); // f2 -> finished

    cubit.reviewRemaining();
    expect(cubit.state.status, FlashcardsStatus.ready);
    expect(cubit.state.session.totalCards, 1);
    expect(cubit.state.session.currentCard?.id, 'f2');
  });

  test('restart reloads all cards in session', () async {
    await cubit.startSession(cards: testCards, userId: 'user1');
    await cubit.rateCard(ReviewQuality.good);
    await cubit.rateCard(ReviewQuality.good);

    cubit.restart();
    expect(cubit.state.status, FlashcardsStatus.ready);
    expect(cubit.state.session.totalCards, 2);
    expect(cubit.state.session.currentIndex, 0);
  });
}
