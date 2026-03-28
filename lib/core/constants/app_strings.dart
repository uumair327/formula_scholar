/// Centralized string constants used across the application.
///
/// Follows the Single Responsibility Principle – all user-facing
/// and internal string literals live here for easy l10n, consistency,
/// and to avoid magic strings scattered throughout the codebase.
///
/// Logger messages are intentionally left inline as they are
/// developer-facing, contextual, and do not require localization.
abstract final class AppStrings {
  // ──────────────────────── App-level ────────────────────────
  static const String appName = 'Formula Scholar';
  static const String welcomeScholar = 'Welcome, Scholar';
  static const String somethingWentWrong = 'Something went wrong';
  static const String retry = 'Retry';
  static const String pageNotFound = 'Page Not Found';
  static const String pageNotFoundDescription =
      "The page you're looking for doesn't exist. "
      'It might have been moved or the URL is incorrect.';
  static const String goHome = 'Go Home';

  // ──────────────────────── Error Messages ───────────────────
  static const String failedToLoadProfile = 'Failed to load profile';
  static const String failedToLoadDashboard = 'Failed to load dashboard';
  static const String failedToLoadGeometry = 'Failed to load geometry topics';
  static const String failedToLoadFormulas = 'Failed to load formulas';

  // ──────────────────────── Bottom Nav ───────────────────────
  static const String navHome = 'Home';
  static const String navChapters = 'Chapters';
  static const String navCheatSheet = 'Cheat Sheet';
  static const String navProfile = 'Profile';

  // ──────────────────────── Dashboard ────────────────────────
  static const String dashboard = 'DASHBOARD';
  static const String hiSarahReady = 'Hi Sarah! Ready to revise?';
  static const String searchHint = "Search formulas (e.g. Newton's Second Law)";
  static const String overallMastery = 'Overall Mastery';
  static const String masteryDescription =
      "You've covered more than half of the 9th-standard syllabus. Keep it up!";
  static const String chaptersLabel = 'Chapters';
  static const String dailyChallenge = 'Daily Challenge';
  static const String dailyChallengeDesc =
      'Test your knowledge with 5 quick formulas.';
  static const String startNow = 'Start Now';
  static const String exploreSubjects = 'Explore Subjects';
  static const String viewAll = 'View All';
  static const String formulaCheatSheets = 'Formula Cheat Sheets';
  static const String cheatSheetDesc =
      'Quick-access PDFs for last-minute exam revision.';
  static const String continueStudying = 'Continue Studying';
  static const String lastViewedTemplate = 'Last viewed';

  // ──────────────────────── Dashboard – Subjects ─────────────
  static const String numberSystemsGeometry = 'Number Systems & Geometry';
  static const String mathCardDescription =
      'Master algebra, circles, and linear equations with visual proofs.';
  static const String mathematics = 'Mathematics';
  static const String physics = 'Physics';
  static const String physicsDesc = 'Motion, Force, and Gravitation simplified.';
  static const String enterLab = 'Enter Lab';
  static const String chemistry = 'Chemistry';
  static const String chemistryDesc =
      'Atoms, Molecules, and Matter in our surroundings.';
  static const String exploreElements = 'Explore Elements';
  static const String science = 'Science';

  // ──────────────────────── Dashboard – Grades ───────────────
  static const String grade9th = '9th Standard';
  static const String grade10th = '10th Standard';
  static const String grade11th = '11th Standard';

  // ──────────────────────── Dashboard – Recent Studies ────────
  static const String pythagoreanTheorem = 'Pythagorean Theorem';
  static const String newtonsThirdLaw = "Newton's Third Law";
  static const String twoHoursAgo = '2 hours ago';
  static const String yesterday = 'Yesterday';

  // ──────────────────────── Geometry ─────────────────────────
  static const String geometry = 'Geometry';
  static const String visualizingSpace = 'Visualizing Space';
  static const String geometryHeroDesc =
      'Master the principles of shapes, sizes, and the relative position of '
      'figures. Geometry is the language of the physical world.';
  static const String chapter04 = 'CHAPTER 04';
  static const String continueLearning = 'Continue Learning';
  static const String nearlyThere = 'Nearly there!';
  static const String formulasLabel = 'FORMULAS';
  static const String viewTopics = 'View Topics';
  static const String locked = 'LOCKED';
  static const String masteryTools = 'Mastery Tools';
  static const String videoLessons = 'Video Lessons';
  static const String practiceQuiz = 'Practice Quiz';
  static const String cheatSheets = 'Cheat Sheets';
  static const String visualizer3d = '3D Visualizer';

  // Geometry – Topics
  static const String triangles = 'Triangles';
  static const String trianglesSubtitle =
      'Explore congruence, similarity, and the powerful Pythagorean theorem across different types of triangles.';
  static const String circles = 'Circles';
  static const String circlesSubtitle = 'Area, Circumference & Tangents';
  static const String quadrilaterals = 'Quadrilaterals';
  static const String quadrilateralsSubtitle =
      'Squares, Rectangles & Parallelograms';
  static const String coordinates = 'Coordinates';
  static const String coordinatesSubtitle = 'Plotting & Distance Formula';
  static const String advancedPolygons = 'Advanced Polygons';
  static const String advancedPolygonsSubtitle =
      'Hexagons, Octagons & Sum of Angles';

  // Geometry – Breadcrumb
  static const String breadcrumbHome = 'HOME';
  static const String breadcrumbMath = 'MATH';
  static const String breadcrumbGeometry = 'GEOMETRY';

  // Geometry – Template patterns
  static String completedOfFormulas(int completed, int total) =>
      'Completed $completed of $total formulas';
  static String percentDone(int percent) => '$percent% Done';
  static String studyMeta(String subject, String lastViewed) =>
      '$subject • $lastViewed $lastViewedTemplate';

  // ──────────────────────── Algebra ──────────────────────────
  static const String algebraCheatSheet = 'Algebra Cheat Sheet';
  static const String mathStandard = 'MATHEMATICS • 9TH STANDARD';
  static const String quickRevisionMode = 'Quick Revision Mode';
  static const String quickRevision = 'Quick Revision';
  static const String detailedView = 'Detailed View';
  static const String examTip = 'Exam Tip';
  static const String examTipContent =
      'Always check the sign in (a-b)² and (a-b)³ identities. '
      'One small sign error can change the entire result!';

  // Algebra – Section Titles
  static const String polynomialIdentities = 'POLYNOMIAL IDENTITIES';
  static const String linearEquations = 'LINEAR EQUATIONS';
  static const String cubicIdentities = 'CUBIC IDENTITIES';

  // Algebra – Formula Tags
  static const String squareOfSum = 'Square of Sum';
  static const String squareOfDifference = 'Square of Difference';
  static const String differenceOfSquares = 'Difference of Squares';
  static const String cubeOfSum = 'Cube of Sum';

  // Algebra – Formula Badges
  static const String essential = 'ESSENTIAL';
  static const String standardForm = 'STANDARD FORM';

  // Algebra – Formula Descriptions
  static const String usedInQuadraticEquations = 'Used in Quadratic Equations';
  static const String linearEquationDesc =
      'Where a, b, c are real numbers and a, b are not both zero.';

  // ──────────────────────── Profile ──────────────────────────
  static const String myProgress = 'My Progress';
  static const String viewHistory = 'View History';
  static const String settings = 'Settings';
  static const String currentGrade = 'Current Grade';
  static const String proBadge = 'PRO';
  static const String readyForMore = 'Ready for more?';
  static const String encouragementMessage =
      "You're in the top 5% of 9th graders this week. Keep flowing!";

  // Profile – User Data
  static const String profileName = 'Sarah';
  static const String profileGrade = '9th Standard';

  // Profile – Stats
  static const String formulasMastered = 'Formulas Mastered';
  static const String formulasMasteredValue = '142';
  static const String daysStreak = 'Days Streak';
  static const String daysStreakValue = '12';
  static const String totalPoints = 'Total Points';
  static const String totalPointsValue = '2,400';

  // Profile – Settings
  static const String accountInformation = 'Account Information';
  static const String myBookmarks = 'My Bookmarks';
  static const String notifications = 'Notifications';
  static const String appearance = 'Appearance';
  static const String toggleDarkMode = 'Toggle Dark Mode';
  static const String helpAndSupport = 'Help & Support';
  static const String logout = 'Logout';
}
