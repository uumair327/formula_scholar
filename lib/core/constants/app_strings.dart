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

  // ──────────────────────── Auth – Login ──────────────────────
  static const String loginTitle = 'Welcome Back';
  static const String loginSubtitle =
      'Enter your credentials to access your sanctuary.';
  static const String loginEmailLabel = 'Email or Username';
  static const String loginEmailHint = 'scholar@formulaflow.com';
  static const String loginPasswordLabel = 'Password';
  static const String loginPasswordHint = '••••••••••••';
  static const String loginForgotPassword = 'Forgot Password?';
  static const String loginSignIn = 'Sign In';
  static const String loginOr = 'OR';
  static const String loginGoogle = 'Google';
  static const String loginSchoolId = 'School ID';
  static const String loginNoAccount = "Don't have an account?";
  static const String loginSignUp = 'Sign Up';
  static const String loginBrandTagline = 'Master every\nformula with\nease.';
  static const String loginBrandDesc =
      'The ultimate cognitive sanctuary for high school scholars. '
      'Organize, learn, and excel in your mathematical journey.';
  static const String loginStudentPortal = 'STUDENT PORTAL';
  static const String loginErrorInvalidCredentials = 'Invalid credentials. Please try again.';

  // ──────────────────────── Auth – Signup ─────────────────────
  static const String signupTitle = 'Create your account';
  static const String signupSubtitle =
      'Start your journey into the Cognitive Sanctuary.';
  static const String signupFullName = 'Full Name';
  static const String signupFullNameHint = 'John Doe';
  static const String signupEmail = 'Email Address';
  static const String signupEmailHint = 'name@school.com';
  static const String signupPassword = 'Password';
  static const String signupConfirmPassword = 'Confirm Password';
  static const String signupPasswordHint = '••••••••';
  static const String signupTerms = 'I agree to the ';
  static const String signupTermsLink = 'Terms of Service';
  static const String signupAnd = ' and ';
  static const String signupPrivacy = 'Privacy Policy';
  static const String signupCreateAccount = 'Create Account';
  static const String signupOrJoin = 'Or join with';
  static const String signupFacebook = 'Facebook';
  static const String signupHasAccount = 'Already have an account?';
  static const String signupSignIn = 'Sign In';
  static const String signupBrandTitle = 'Formula Sanctuary';
  static const String signupBrandHeadline = 'Master the Flow of Knowledge.';
  static const String signupBrandDesc =
      'Join a sanctuary designed for focused learning. '
      'Transform complex equations into intuitive steps.';
  static const String signupTestimonial =
      '"The formulas finally make sense. It doesn\'t feel like studying; it feels like exploring."';
  static const String signupTestimonialName = 'Ishita Sharma';
  static const String signupTestimonialRole = 'Class 9 Student';
  static const String signupErrorFailed = 'Registration failed. Please try again.';

  // ──────────────────────── Onboarding Step 1 – Location ──────
  static const String step1Tag = 'Location Preference';
  static const String step1Title = 'Where are you studying?';
  static const String step1Subtitle =
      "We'll tailor your formulas and curriculum based on your region's educational standards.";
  static const String step1CountryLabel = 'Select Country';
  static const String step1StateLabel = 'Select State or Region';
  static const String step1StateHint = 'Search state (e.g. Maharashtra)';
  static const String step1LocalizedTitle = 'Localized Content';
  static const String step1LocalizedDesc =
      'We automatically sync with CBSE, ICSE, and various State Board syllabi based on your choice.';
  static const String step1PrivacyTitle = 'Privacy Guaranteed';
  static const String step1PrivacyDesc =
      'Your location is only used to personalize your curriculum roadmap.';
  static const String step1Continue = 'Continue to Step 2';

  // ──────────────────────── Onboarding Step 2 – Curriculum ────
  static const String step2Tag = 'Curriculum Selection';
  static const String step2Title = 'Select Your Curriculum';
  static const String step2NotSureTitle = 'Not sure about your board?';
  static const String step2NotSureDesc =
      'Check your school ID card or textbook covers for the official board affiliation.';
  static const String step2LearnMore = 'Learn more';

  // ──────────────────────── Onboarding Step 3 – Subjects ──────
  static const String step3Tag = 'Subject Focus';
  static const String step3Title = 'What are your focus areas?';
  static const String step3Subtitle =
      'Choose the subjects you want to master first. You can always change this later.';

  // ──────────────────────── Onboarding Step 4 – Goal ──────────
  static const String step4Tag = 'Commitment';
  static const String step4Title = 'Set your weekly goal';
  static const String step4Subtitle =
      'Consistency is the key to mastery. How much time can you dedicate?';
  static const String step4Casual = 'Casual Learner';
  static const String step4CasualDesc = '15 mins / day';
  static const String step4Regular = 'Regular Scholar';
  static const String step4RegularDesc = '30 mins / day';
  static const String step4Intensive = 'Intensive Mastery';
  static const String step4IntensiveDesc = '60+ mins / day';
  static const String step4EnterSanctuary = 'Enter Sanctuary';

  // ──────────────────────── Onboarding shared ─────────────────
  static const String onboardingNeedHelp = 'Need Help?';
  static const String onboardingBoardSubtitle =
      'Personalize your journey by selecting your academic board. '
      "We'll tailor your formulas and practice sets to your specific curriculum.";
  static const String onboardingSelectBoard = 'Select Board';
  static const String onboardingBoardChangeHint =
      'Selected board can be changed later in Profile.';
  static const String onboardingBoardSelected = 'BOARD SELECTED';
  static const String onboardingJourneyProgress = 'Journey Progress';
  static const String onboardingGradeSubtitle =
      "We'll customize your FormulaFlow experience based on your current curriculum.";
  static const String onboardingMostPopular = 'MOST POPULAR';
  static const String onboardingGradeChangeHint =
      'You can always change your grade in Profile settings later.';
  static const String onboardingBack = 'Back';
  static const String onboardingContinue = 'Continue';
  static const String onboardingAppBrand = 'Formula Sanctuary';
  static String onboardingStepOf(int current, int total) =>
      'Step $current of $total';

  // ──────────────────────── Error Messages ───────────────────
  static const String failedToLoadProfile = 'Failed to load profile';
  static const String failedToLoadDashboard = 'Failed to load dashboard';
  static const String failedToLoadGeometry = 'Failed to load geometry topics';
  static const String failedToLoadFormulas = 'Failed to load formulas';
  static const String failedToLoadPractice =
      'Failed to load practice questions';
  static const String failedToLoadSaved = 'Failed to load bookmarks';

  // ──────────────────────── Bottom Nav ───────────────────────
  static const String navHome = 'Home';
  static const String navChapters = 'Chapters';
  static const String navPractice = 'Practice';
  static const String navSaved = 'Saved';
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

  // Dashboard – Hero / Status Card
  static const String dashboardSanctuary = 'Formula Sanctuary';
  static const String dashboardActiveCurriculum = 'ACTIVE CURRICULUM';
  static const String dashboardSwitchBoardGrade = 'Switch Board/Grade';
  static const String dashboardHeroBadge = 'CBSE Syllabus • Grade 9';
  static const String dashboardHeroTitle = 'Mastering Motion &\nLaws of Forces';
  static const String dashboardHeroDescription =
      "Continue your journey through Physics. You're 65% through the current chapter.";
  static const String dashboardResumeLesson = 'Resume Lesson';
  static const String dashboardAcademicPath = 'Academic Path';

  // Dashboard – Subject Cards
  static const String dashboardCuratedBadge = 'CBSE 9 CURATED';
  static const String dashboardMathTitle = 'Polynomials & Geometrical Proofs';
  static const String dashboardMathFormulas = '14 Formulas';
  static const String dashboardGrade9Badge = 'GRADE 9';
  static const String dashboardPhysicsTitle = 'Gravitation & Sound';
  static const String dashboardPhysicsDesc =
      'Universal law of gravitation and its implications in CBSE Grade IX science curriculum.';
  static const String dashboardMastered75 = '75% MASTERED';
  static const String dashboardChemistryTitle = 'Atoms & Molecules';
  static const String dashboardLastViewed2Days = 'Last viewed 2 days ago';
  static const String dashboardBiology = 'Biology';
  static const String dashboardBiologyTitle = 'Cell: The Fundamental Unit';
  static const String dashboardBiologyRecommended = 'Recommended for Boards';
  static const String dashboardLive = 'LIVE';
  static const String dashboardBoardReadyQuiz = 'Board Ready Quiz';
  static const String dashboardQuizDesc =
      'Test your knowledge on CBSE Chapter 2.';

  // Dashboard – Formula Vault
  static const String dashboardFormulaVault = 'My Formula Vault';
  static const String dashboardVaultDesc = '42 saved items across 4 subjects';
  static const String dashboardVaultMath = 'Quadratic Formula';
  static const String dashboardVaultPhysics = 'Kinematic Eq 1';
  static const String dashboardVaultChem = 'Ideal Gas Law';

  // ──────────────────────── Dashboard – Subjects ─────────────
  static const String numberSystemsGeometry = 'Number Systems & Geometry';
  static const String mathCardDescription =
      'Detailed CBSE compliant formula sheets for algebraic identities and theorems specifically for Grade 9 students.';
  static const String mathematics = 'Mathematics';
  static const String physics = 'Physics';
  static const String physicsDesc =
      'Motion, Force, and Gravitation simplified.';
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

  // ──────────────────────── Chapters (generic) ───────────────
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
  static const String selectSubjectTitle = 'Select a Subject';
  static const String selectSubjectDesc =
      'Tap on a subject from the Home tab to start exploring chapters and formulas.';

  // Chapters – Breadcrumb
  static const String breadcrumbHome = 'HOME';

  // Chapters – Math Topics
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

  // Geometry – Template patterns
  static String completedOfFormulas(int completed, int total) =>
      'Completed $completed of $total formulas';
  static String percentDone(int percent) => '$percent% Done';
  static String studyMeta(String subject, String lastViewed) =>
      '$subject • $lastViewed $lastViewedTemplate';

  // Chapters – Algebra Topics
  static const String polynomialIdentities = 'Polynomial Identities';
  static const String polynomialIdentitiesSubtitle =
      'Square of sum, difference of squares & more';
  static const String linearEquations = 'Linear Equations';
  static const String linearEquationsSubtitle =
      'Standard form, slope-intercept & solutions';

  // Chapters – Physics Topics
  static const String motion = 'Motion';
  static const String motionSubtitle =
      'Speed, velocity, acceleration & equations of motion';
  static const String forceAndLaws = 'Force & Laws of Motion';
  static const String forceSubtitle =
      "Newton's three laws and their applications";
  static const String gravitation = 'Gravitation';
  static const String gravitationSubtitle =
      'Universal law, free fall & weight vs mass';

  // Chapters – Chemistry Topics
  static const String matterInSurroundings = 'Matter in Our Surroundings';
  static const String matterSubtitle =
      'States of matter, evaporation & intermolecular forces';
  static const String atomsAndMolecules = 'Atoms & Molecules';
  static const String atomsSubtitle =
      'Atomic mass, molecular formula & mole concept';
  static const String structureOfAtom = 'Structure of the Atom';
  static const String structureOfAtomSubtitle =
      'Bohr model, electron configuration & isotopes';

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

  // ──────────────────────── Practice ──────────────────────────
  static const String circlesAndAreas = 'Circles & Areas';
  static const String geometryBasics = 'GEOMETRY BASICS';
  static const String practiceQuestionLabel = 'QUESTION';
  static const String ofLabel = 'of';
  static const String ptsLabel = 'pts';
  static const String correct = 'Correct!';
  static const String plusPointsTemplate = '+10 Points';
  static const String masteryLevelIncreasing = 'Mastery level increasing';
  static const String areaOfCircleQuestion =
      'Which of the following formulas correctly represents the area of a circle with radius r?';
  static const String nextQuestion = 'Next Question';

  // ──────────────────────── Saved / Bookmarks ─────────────────
  static const String formulaFlow = 'FormulaFlow';
  static const String connectionError = 'Connection Error';
  static const String signalsCrossed = 'Signals are Crossed';
  static const String connectionErrorDesc =
      "We can't seem to reach the formula lab right now. "
      'Check your connection and let\'s try that again.';
  static const String tryAgain = 'Try Again';
  static const String nothingHereYet = 'Nothing here yet';
  static const String emptyBookmarksDesc =
      'Your saved formulas will appear here. Start exploring and '
      'bookmark the theorems you want to master.';
  static const String browseLessons = 'Browse Lessons';
  static const String proTip = 'Pro Tip';
  static const String proTipContent =
      'You can still access your recently viewed formulas '
      'offline if they\'ve been cached previously.';

  // ──────────────────────── Coming Soon ──────────────────────
  static const String comingSoon = 'COMING SOON';
  static const String gotIt = 'Got It';
  static const String comingSoonChip1 = 'In Development';
  static const String comingSoonChip2 = 'Stay Tuned';
  static const String comingSoonChip3 = 'Exciting Updates';

  // ──────────────────────── Account Information ──────────────
  static const String personalInfo = 'Personal Information';
  static const String academicInfo = 'Academic Information';
  static const String accountActions = 'Account Actions';
  static const String fullName = 'Full Name';
  static const String emailAddress = 'Email Address';
  static const String accountType = 'Account Type';
  static const String freeAccount = 'Free';
  static const String verifiedAccount = 'VERIFIED';
  static const String editProfile = 'Edit Profile';
  static const String changePassword = 'Change Password';
  static const String deleteAccount = 'Delete Account';

  // ──────────────────────── Bookmarks ────────────────────────
  static const String bookmarkCategories = 'Categories';
  static const String savedFormulas = 'Saved Formulas';
  static const String savedChapters = 'Saved Chapters';
  static const String savedNotes = 'Saved Notes';
  static const String recentBookmarks = 'Recent Bookmarks';
  static const String searchBookmarks = 'Search Bookmarks';

  // ──────────────────────── Notifications ────────────────────
  static const String studyNotifications = 'Study Notifications';
  static const String studyReminders = 'Study Reminders';
  static const String studyRemindersDesc = 'Daily reminders to keep learning';
  static const String streakAlerts = 'Streak Alerts';
  static const String streakAlertsDesc = 'Don\'t break your study streak';
  static const String newContent = 'New Content';
  static const String newContentDesc = 'When new chapters are available';
  static const String achievementNotifications = 'Achievements';
  static const String achievements = 'Milestone Alerts';
  static const String achievementsDesc = 'When you hit learning milestones';
  static const String weeklyReport = 'Weekly Report';
  static const String weeklyReportDesc = 'Summary of your weekly progress';
  static const String deliveryChannels = 'Delivery Channels';
  static const String pushNotificationsLabel = 'Push Notifications';
  static const String pushNotificationsDesc = 'Receive alerts on your device';
  static const String emailNotificationsLabel = 'Email Notifications';
  static const String emailNotificationsDesc = 'Receive updates via email';
  static const String notificationsEnabled = 'Notifications Active';
  static const String notificationsEnabledDesc =
      'You\'re all set to receive important updates.';

  // ──────────────────────── Help & Support ───────────────────
  static const String quickActions = 'Quick Actions';
  static const String chatWithUs = 'Chat';
  static const String emailUs = 'Email';
  static const String faqLabel = 'FAQ';
  static const String frequentlyAsked = 'Frequently Asked';
  static const String faq1Question = 'How do I change my grade?';
  static const String faq1Answer =
      'Go to Profile → Account Information to update your grade. '
      'Your curriculum will automatically adjust to match.';
  static const String faq2Question = 'Can I use the app offline?';
  static const String faq2Answer =
      'Yes! Previously viewed formulas and chapters are cached '
      'for offline access. Bookmarks are always available offline.';
  static const String faq3Question = 'How are streaks calculated?';
  static const String faq3Answer =
      'Your streak counts consecutive days with at least 5 minutes '
      'of study time. The counter resets at midnight local time.';
  static const String faq4Question = 'What is Formula Scholar Pro?';
  static const String faq4Answer =
      'Pro unlocks advanced features like 3D visualizers, unlimited '
      'practice quizzes, and priority access to new content.';
  static const String resources = 'Resources';
  static const String userGuide = 'User Guide';
  static const String userGuideDesc = 'Learn how to use Formula Scholar';
  static const String videoTutorials = 'Video Tutorials';
  static const String videoTutorialsDesc = 'Watch step-by-step guides';
  static const String privacyPolicy = 'Privacy Policy';
  static const String privacyPolicyDesc = 'How we protect your data';
  static const String termsOfServiceDesc = 'Rules and guidelines for app usage';
  static const String helpHeroTitle = 'How can we help?';
  static const String helpHeroSubtitle =
      'Browse FAQs or contact our support team.';
  static const String appVersion = 'Version 1.0.0 (Beta)';
  static const String madeWithLove = 'Made with ❤️ for scholars';

  // ──────────────────────── Global Actions ───────────────────
  static const String searchLabel = 'Search';
  static const String quickPractice = 'Quick Practice';

  // ──────────────────────── Formulas Page ────────────────────
  static const String formulasTitle = 'Formulas';
  static const String formulasBreadcrumb = 'FORMULAS';
  static const String chapterLabel = 'Chapter';
  static const String chapterBreadcrumb = 'CHAPTER';
  static const String masteredLabel = 'MASTERED';
  static const String savedPrefix = 'SAVED';

  /// Template: "X of Y formulas mastered"
  static String formulasMasteredOf(int mastered, int total) =>
      '$mastered of $total formulas mastered';

  // ──────────────────────── Legal / Compliance ───────────────
  static const String privacyPolicyTitle = 'Privacy Policy';
  static const String termsOfServiceTitle = 'Terms of Service';
  static const String legalEffectiveDate = 'Effective: April 2026';

  // Privacy Policy sections
  static const String legalInfoWeCollect = 'Information We Collect';
  static const String legalInfoWeCollectContent =
      'We collect information you provide directly, such as your name, email '
      'address, and academic preferences (board, grade, subjects) when you '
      'create an account. We also collect usage data including formulas viewed, '
      'quiz scores, and study progress to personalize your experience.';

  static const String legalHowWeUse = 'How We Use Your Information';
  static const String legalHowWeUseContent =
      'Your information is used to: personalize your learning dashboard, track '
      'your study progress and mastery levels, recommend relevant formulas and '
      'chapters, send study reminders (with your consent), and improve our '
      'educational content and features.';

  static const String legalDataStorage = 'Data Storage & Security';
  static const String legalDataStorageContent =
      'Your data is stored securely on Google Firebase servers with encryption '
      'at rest and in transit. We use industry-standard security measures to '
      'protect your personal information. You can request data export or '
      'deletion at any time through the app settings.';

  static const String legalThirdParty = 'Third-Party Services';
  static const String legalThirdPartyContent =
      'We use the following third-party services: Firebase (authentication '
      'and data storage by Google), Google Sign-In (optional account linking). '
      'These services have their own privacy policies which we encourage you '
      'to review.';

  static const String legalYourRights = 'Your Rights';
  static const String legalYourRightsContent =
      'You have the right to: access your personal data, correct inaccurate '
      'data, request deletion of your account and data, export your data in a '
      'portable format, and opt out of non-essential communications. To '
      'exercise these rights, contact us through the Help & Support section.';

  static const String legalChildrenPrivacy = "Children's Privacy";
  static const String legalChildrenPrivacyContent =
      'Formula Scholar is designed for students of all ages. For users under '
      '13, we collect only the minimum information necessary for the service. '
      'We do not knowingly collect sensitive personal information from children. '
      'Parents may contact us to review or delete their child\'s data.';

  static const String legalChanges = 'Changes to This Policy';
  static const String legalChangesContent =
      'We may update this Privacy Policy from time to time. We will notify you '
      'of any material changes through the app and update the effective date. '
      'Your continued use of Formula Scholar after changes indicates acceptance '
      'of the updated policy.';

  static const String legalContact = 'Contact Us';
  static const String legalContactContent =
      'If you have questions about this Privacy Policy or your data, please '
      'contact us through the Help & Support section in the app, or email us '
      'at support@formulascholar.app.';

  // Terms of Service sections
  static const String legalAcceptance = 'Acceptance of Terms';
  static const String legalAcceptanceContent =
      'By creating an account or using Formula Scholar, you agree to these '
      'Terms of Service. If you do not agree, please do not use the service. '
      'We may update these terms and will notify you of significant changes.';

  static const String legalUseOfService = 'Use of Service';
  static const String legalUseOfServiceContent =
      'Formula Scholar provides educational tools for learning mathematical '
      'and scientific formulas. The service is provided "as is" for personal, '
      'non-commercial educational use. You agree not to: share your account '
      'credentials, use the service for unauthorized purposes, or attempt to '
      'reverse-engineer any part of the application.';

  static const String legalUserAccounts = 'User Accounts';
  static const String legalUserAccountsContent =
      'You are responsible for maintaining the security of your account and '
      'password. You must provide accurate information during registration. '
      'You may delete your account at any time, which will permanently remove '
      'your data from our systems.';

  static const String legalIntellectualProperty = 'Intellectual Property';
  static const String legalIntellectualPropertyContent =
      'All content, design, and code within Formula Scholar are protected by '
      'intellectual property laws. Educational formulas themselves are in the '
      'public domain, but our presentation, explanations, and quiz content are '
      'proprietary. You may not reproduce or distribute our content without '
      'permission.';

  static const String legalTermination = 'Termination';
  static const String legalTerminationContent =
      'We may suspend or terminate your access if you violate these terms. '
      'You may terminate your account at any time. Upon termination, your right '
      'to use the service ceases and your data will be deleted per our '
      'retention policy.';

  static const String legalDisclaimer = 'Disclaimer';
  static const String legalDisclaimerContent =
      'Formula Scholar is an educational aid and should supplement, not '
      'replace, formal education. We strive for accuracy but do not guarantee '
      'that all content is error-free. We are not liable for academic outcomes '
      'based on use of this application.';

  static const String legalGoverningLaw = 'Governing Law';
  static const String legalGoverningLawContent =
      'These Terms of Service are governed by applicable law. Any disputes '
      'arising from these terms will be resolved through appropriate legal '
      'channels in the jurisdiction where the service provider is located.';

  // Legal footer
  static const String legalFooterTitle =
      'Your Privacy & Security Matter to Us';
  static const String legalFooterDesc =
      'We are committed to protecting your personal information '
      'and providing a safe learning environment.';
}
