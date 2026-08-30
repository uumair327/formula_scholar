/// Centralized dimension, spacing, and sizing constants.
///
/// Provides a single source of truth for all layout-related magic
/// numbers. Centralizing these here avoids inconsistencies and
/// makes design-system tweaks a one-line change.
abstract final class AppDimensions {
  // ──────────────────────── Padding / Spacing ────────────────
  static const double paddingXXS = 2.0;
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 12.0;
  static const double paddingLG = 16.0;
  static const double paddingXL = 20.0;
  static const double paddingXXL = 24.0;
  static const double paddingHero = 28.0;
  static const double paddingSection = 32.0;

  // ──────────────────────── Border Radius ────────────────────
  static const double radiusXS = 2.0;
  static const double radiusSM = 6.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusShell = 28.0;
  static const double radiusFull = 999.0;

  // ──────────────────────── Icon Sizes ───────────────────────
  static const double iconXS = 12.0;
  static const double iconSM = 16.0;
  static const double iconMD = 20.0;
  static const double iconDefault = 22.0;
  static const double iconLG = 24.0;
  static const double iconXL = 28.0;
  static const double iconXXL = 32.0;
  static const double iconHero = 48.0;
  static const double iconDecorative = 200.0;

  // ──────────────────────── Font Sizes ───────────────────────
  static const double fontSizeXXS = 8.0;
  static const double fontSizeXXSPlus = 9.0;
  static const double fontSizeXS = 10.0;
  static const double fontSizeXSPlus = 11.0;
  static const double fontSizeSM = 12.0;
  static const double fontSizeMD = 14.0;
  static const double fontSizeLG = 16.0;
  static const double fontSizeXL = 18.0;
  static const double fontSizeXXL = 20.0;
  static const double fontSizeHeadline = 24.0;
  static const double fontSizeDisplay = 32.0;
  static const double fontSizeDisplayLG = 40.0;

  // ──────────────────────── Letter Spacing ───────────────────
  static const double letterSpacingTight = -0.5;
  static const double letterSpacingMediumTight = -0.3;
  static const double letterSpacingSlightTight = -0.2;
  static const double letterSpacingNarrow = 0.3;
  static const double letterSpacingNormal = 1.2;
  static const double letterSpacingWide = 1.5;

  // ──────────────────────── Line Height ──────────────────────
  static const double lineHeightTight = 1.0;
  static const double lineHeightCompact = 1.1;
  static const double lineHeightDefault = 1.5;
  static const double lineHeightRelaxed = 1.6;

  // ──────────────────────── Avatar / Image ───────────────────
  static const double avatarSM = 24.0;
  static const double avatarMD = 40.0;
  static const double avatarLG = 48.0;
  static const double avatarXL = 56.0;
  static const double avatarHero = 64.0;
  static const double avatarProfile = 96.0;

  // ──────────────────────── Responsive Breakpoints ───────────
  static const double breakpointWide = 600.0;
  static const double breakpointMedium = 500.0;
  static const double breakpointCardHorizontal = 400.0;
  static const double breakpointTablet = 900.0;
  static const double breakpointDesktop = 1024.0;
  static const double breakpointMaxContent = 1200.0;

  // ──────────────────────── Side Navigation ──────────────────
  static const double sideNavWidth = 240.0;
  static const double sideNavRailWidth = 72.0;
  static const double sideNavCollapsedWidth = 80.0;

  // ──────────────────────── Card Heights / Constraints ───────
  static const double cardMinHeightLG = 280.0;
  static const double imagePreviewHeight = 120.0;
  static const double bottomNavPadding = 100.0;

  // ──────────────────────── Decorative Element Sizes ─────────
  static const double glowCircleSize = 180.0;
  static const double glowCircleSizeSM = 126.0;
  static const double decorativeIconSize = 100.0;
  static const double decorativeOffset = -30.0;
  static const double decorativeOffsetLG = -40.0;

  /// Fraction of screen height for decorative background positioning.
  static const double decorativePositionFraction = 0.25;

  // ──────────────────────── Shadow / Blur ─────────────────────
  static const double blurRadiusXS = 2.0;
  static const double blurRadiusSM = 4.0;
  static const double blurRadiusMD = 8.0;
  static const double blurRadiusLG = 24.0;
  static const double blurRadiusXL = 60.0;

  static const double spreadRadiusSM = -4.0;
  static const double spreadRadiusMD = 20.0;

  static const double shadowOffsetXS = 1.0;
  static const double shadowOffsetSM = 2.0;
  static const double shadowOffsetMD = 4.0;
  static const double shadowOffsetLG = 8.0;

  // ──────────────────────── Progress Bar ─────────────────────
  static const double progressBarDefault = 12.0;
  static const double progressBarLG = 14.0;
  static const double progressBarSM = 8.0;
  static const double progressBarMD = 10.0;

  // ──────────────────────── Switch ───────────────────────────
  static const double switchWidth = 48.0;
  static const double switchHeight = 24.0;
  static const double switchThumbSize = 18.0;
  static const double switchPadding = 3.0;

  // ──────────────────────── Dot / Indicator ──────────────────
  static const double dotIndicatorSize = 6.0;
  static const double sectionDotSize = 8.0;
  static const double borderWidth = 2.0;
  static const double borderWidthThick = 4.0;
  static const double dividerHeight = 1.0;

  // ──────────────────────── Badge / Chip ─────────────────────
  static const double badgePaddingHorizontal = 10.0;
  static const double badgePaddingVertical = 4.0;
  static const double chipPaddingHorizontal = 14.0;
  static const double chipPaddingHorizontalLG = 16.0;
  static const double chipPaddingVertical = 6.0;
  static const double chipPaddingVerticalLG = 8.0;

  // ──────────────────────── Elevation ────────────────────────
  static const double elevationNone = 0.0;
  static const double elevationSM = 1.0;
  static const double elevationMD = 8.0;

  // ──────────────────────── Grid ─────────────────────────────
  static const int masteryToolsCrossAxisCount = 2;
  static const double masteryToolsSpacing = 12.0;
  static const double masteryToolsAspectRatio = 1.6;
  static const double vaultGridAspectRatio = 1.4;

  // ──────────────────────── Opacity ──────────────────────────
  static const double opacityFaint = 0.1;
  static const double opacitySubtle = 0.2;
  static const double opacityLight = 0.3;
  static const double opacityMediumLight = 0.5;
  static const double opacityMedium = 0.6;
  static const double opacityHigh = 0.8;
  static const double opacityAppBar = 0.85;
  static const double opacityNearOpaque = 0.9;
  static const double opacityOverlay = 0.05;
  static const double opacityShadowLight = 0.15;

  // ──────────────────────── Transform ────────────────────────
  static const double rotationSubtle = 0.2;
  static const double rotationMedium = 0.26;
  static const double avatarOverlapOffset = -8.0;

  // ──────────────────────── Decorative / Background ──────────
  static const double paddingSectionLG = 48.0;
  static const double positionOffsetSM = -8.0;
  static const double decorativeBlurLG = 384.0;
  static const double decorativeBlurMD = 300.0;
  static const double decorativeBlurSM = 280.0;
  static const double decorativeCircleMD = 200.0;
  static const double decorativeCircleSM = 150.0;
  static const double decorativeCircleXS = 120.0;
  static const double decorativeCircleTiny = 80.0;
  static const double decorativeBlurRadius = 50.0;
  static const double decorativeStrokeWidth = 12.0;

  // ──────────────────────── Image / Illustration ─────────────
  static const double imageXL = 128.0;
  static const double imageLG = 64.0;
  static const double imageMD = 48.0;
  static const double imageXS = 250.0;

  // ──────────────────────── Mascot Sizes ──────────────────────
  /// Small mascot — inline accent, hero card corner.
  static const double mascotSM = 64.0;

  /// Medium mascot — empty/error states, flashcard views.
  static const double mascotMD = 96.0;

  /// Large mascot — completion screens, 404 page.
  static const double mascotLG = 128.0;

  /// Extra-large mascot — onboarding, splash moments.
  static const double mascotXL = 180.0;

  // ──────────────────────── Position Offsets ──────────────────
  static const double positionTopLG = 100.0;
  static const double positionBottomLG = 80.0;

  // ──────────────────────── Container Heights ────────────────
  /// Subject chip filter bar height.
  static const double chipContainerHeight = 60.0;

  // ──────────────────────── Premium Additions ─────────────────────
  /// Pill-shaped radius (very large for stadium shapes).
  static const double radiusPill = 999.0;

  /// Consistent bottom nav bar height.
  static const double navBarHeight = 72.0;

  /// Consistent app bar / header height.
  static const double headerHeight = 56.0;

  /// Glass blur sigma value.
  static const double glassBlurSigma = 20.0;

  /// Card press-down scale factor.
  static const double cardPressScale = 0.97;

  /// Hover lift scale factor.
  static const double cardHoverScale = 1.02;

  /// Stagger delay multiplier base (ms per index).
  static const int staggerDelayMs = 60;

  /// Maximum content width for centered layouts.
  static const double maxContentWidth = 680.0;
}
