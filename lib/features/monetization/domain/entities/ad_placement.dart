/// Type-safe ad placement identifiers in Formula Scholar.
enum AdPlacement {
  /// Bottom/inline banner on the main Dashboard.
  dashboardBanner,

  /// Banner on Chapters/Subject browser.
  chaptersBanner,

  /// Fullscreen / Duolingo-style window after completing a practice quiz.
  postQuizInterstitial,

  /// Fullscreen / Duolingo-style window after a flashcard study session.
  postFlashcardsInterstitial,

  /// Rewarded ad to restore a broken daily study streak.
  streakReviveRewarded,

  /// Rewarded ad to unlock an advanced AI formula deep derivation.
  aiDerivationRewarded,

  /// Rewarded ad to double quiz XP and earn trophy bonus.
  doubleXpRewarded,

  /// General Duolingo-style interactive promotional window.
  duolingoPromoWindow;

  /// Whether this placement is a rewarded ad format.
  bool get isRewarded => switch (this) {
    AdPlacement.streakReviveRewarded ||
    AdPlacement.aiDerivationRewarded ||
    AdPlacement.doubleXpRewarded => true,
    _ => false,
  };

  /// Whether this placement is a banner format.
  bool get isBanner => switch (this) {
    AdPlacement.dashboardBanner || AdPlacement.chaptersBanner => true,
    _ => false,
  };

  /// Whether this placement is a fullscreen interstitial format.
  bool get isInterstitial => !isRewarded && !isBanner;
}
