// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Formula Scholar';

  @override
  String get dashboardHeroBadge => 'CBSE Syllabus • Grade 9';

  @override
  String get dashboardHeroTitle => 'Mastering Motion &\\nLaws of Forces';

  @override
  String dashboardHeroDescription(Object progress) {
    return 'Continue your journey through Physics. You\'re 65% through the current chapter.';
  }

  @override
  String get dashboardResumeLesson => 'Resume Lesson';

  @override
  String get dashboardResumeSemantic => 'Resume learning';

  @override
  String get quickActionsTitle => 'Explore Tools';

  @override
  String get studyPlanner => 'Study Planner';

  @override
  String get viewAnalytics => 'View Analytics';

  @override
  String get flashcards => 'Flashcards';

  @override
  String get welcomeBack => 'Welcome back ✨';

  @override
  String get searchLabel => 'Search';

  @override
  String get searchFormulas => 'Search formulas';

  @override
  String get searchFormulasTitle => 'Search formulas';

  @override
  String get searchEmptyDescription =>
      'Type to search across all your subjects and chapters';

  @override
  String get noResultsFound => 'No Results Found';

  @override
  String get tryDifferentSearch => 'Try a different search term';

  @override
  String get clearSearch => 'Clear Search';

  @override
  String get navHome => 'Home';

  @override
  String get navSubjects => 'Subjects';

  @override
  String get navPractice => 'Practice';

  @override
  String get navSaved => 'Saved';

  @override
  String get navProfile => 'Profile';

  @override
  String get labelsLocalizationTitle => 'App label localization';

  @override
  String get labelsLocalizationSubtitle =>
      'Control app labels and backend content language independently';

  @override
  String get enableLabelsLocalization => 'Enable app label localization';

  @override
  String get enableLabelsLocalizationDesc =>
      'Switch the app labels to the selected language';

  @override
  String get useSystemLanguage => 'Use System Language';

  @override
  String get currentSystemLanguage => 'Current System Language';

  @override
  String get appLabelLanguage => 'App Label Language';

  @override
  String get contentLocalizationTitle => 'Backend content localization';

  @override
  String get contentLocalizationSubtitle =>
      'Choose the Firestore content language separately from app labels';

  @override
  String get enableContentLocalization => 'Enable backend content localization';

  @override
  String get enableContentLocalizationDesc =>
      'Load dashboard content for the selected locale';

  @override
  String get contentLanguage => 'Content Language';

  @override
  String get contentLocalizationFallbackInfo =>
      'If a translation is missing, the app falls back to English (India).';

  @override
  String get localizationEffectiveSummary => 'Effective localization';

  @override
  String get appLabels => 'App Labels';

  @override
  String get backendContent => 'Backend Content';

  @override
  String get languageAndLocalization => 'Language & Localization';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get languageUrdu => 'Urdu';

  @override
  String get languageMarathi => 'Marathi';

  @override
  String get languageEnglishIndia => 'English (India)';

  @override
  String get viewInsights => 'View Insights';

  @override
  String get loginTitle => 'Welcome Back';

  @override
  String get loginSubtitle =>
      'Enter your credentials to access your sanctuary.';

  @override
  String get loginEmailLabel => 'Email or Username';

  @override
  String get loginEmailHint => 'scholar@formulaflow.com';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordHint => '••••••••••••';

  @override
  String get loginForgotPassword => 'Forgot Password?';

  @override
  String get showPassword => 'Show Password';

  @override
  String get hidePassword => 'Hide Password';

  @override
  String get loginSignIn => 'Sign In';

  @override
  String get loginOr => 'OR';

  @override
  String get loginGoogle => 'Google';

  @override
  String get loginSchoolId => 'School ID';

  @override
  String get loginNoAccount => 'Don\'t have an account?';

  @override
  String get loginSignUp => 'Sign Up';

  @override
  String get signupTitle => 'Create your account';

  @override
  String get signupSubtitle =>
      'Start your journey into the Cognitive Sanctuary.';

  @override
  String get signupFullName => 'Full Name';

  @override
  String get signupFullNameHint => 'John Doe';

  @override
  String get signupEmail => 'Email Address';

  @override
  String get signupEmailHint => 'name@school.com';

  @override
  String get signupPassword => 'Password';

  @override
  String get signupConfirmPassword => 'Confirm Password';

  @override
  String get signupPasswordHint => '••••••••';

  @override
  String get signupCreateAccount => 'Create Account';

  @override
  String get signupHasAccount => 'Already have an account?';

  @override
  String get signupSignIn => 'Sign In';

  @override
  String get proBadge => 'PRO';

  @override
  String get currentGrade => 'Current Grade';

  @override
  String get pageNotFound => 'Page Not Found';

  @override
  String get pageNotFoundDescription =>
      'The page you\'re looking for doesn\'t exist. It might have been moved or the URL is incorrect.';

  @override
  String get goHome => 'Go Home';

  @override
  String get loginStudentPortal => 'STUDENT PORTAL';

  @override
  String get loginBrandTagline => 'Master every\\nformula with\\nease.';

  @override
  String get loginBrandDesc =>
      'The ultimate cognitive sanctuary for high school scholars. Organize, learn, and excel in your mathematical journey.';

  @override
  String get signupTerms => 'I agree to the ';

  @override
  String get signupTermsLink => 'Terms of Service';

  @override
  String get signupAnd => ' and ';

  @override
  String get signupPrivacy => 'Privacy Policy';

  @override
  String get signupOrJoin => 'Or join with';

  @override
  String get signupFacebook => 'Facebook';

  @override
  String get profileInsightsTitle => 'Profile Insights';

  @override
  String get profileInsightsSubtitle => 'Backend-fed progress at a glance';

  @override
  String get profileInsightsSource => 'Synced from Firestore';

  @override
  String get profileStatsPending =>
      'Your profile stats will appear here once your backend sync completes.';

  @override
  String get continuePracticing => 'Continue Practicing';

  @override
  String get browseChapters => 'Browse Chapters';

  @override
  String get viewFullAnalytics => 'View Full Analytics';

  @override
  String get deletePlan => 'Delete Plan';

  @override
  String get noPlansYet => 'No Plans Yet';

  @override
  String get createPlan => 'Create Plan';

  @override
  String get planTitle => 'Plan Title';

  @override
  String get planTitleHint => 'e.g. Cover chapters 1-3';

  @override
  String get editPlan => 'Edit Plan';

  @override
  String get newPlan => 'New Plan';

  @override
  String get swapFormulas => 'Swap Formulas';

  @override
  String get step1CountryLabel => 'Select Country';

  @override
  String get step1StateLabel => 'Select State or Region';

  @override
  String get perCategory => 'Per Category';

  @override
  String get timeTaken => 'Time Taken';

  @override
  String get practiceHistory => 'Practice History';

  @override
  String get noPracticeHistory => 'No practice history yet';

  @override
  String get noPracticeHistoryDesc =>
      'You haven\'t completed any practice sessions yet.';

  @override
  String get scoreLabel => 'Score';

  @override
  String get ptsLabel => 'pts';

  @override
  String get correctLabel => 'Correct';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get plusPointsTemplate => '+10 Points';

  @override
  String get correct => 'Correct!';

  @override
  String get masteryLevelIncreasing => 'Mastery level increasing';

  @override
  String get wrongAnswer => 'Incorrect';

  @override
  String get tryNextTime => 'Review and try again next time';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get failedToLoadProfile => 'Failed to load profile';

  @override
  String get failedToUpdateProfile => 'Failed to update profile';

  @override
  String get dashboardCurriculumOptionsLoadFailed =>
      'Unable to load boards and classes right now.';

  @override
  String get chaptersFormulasLoadFailed => 'Failed to load formulas';

  @override
  String get chaptersToggleMasteryFailed => 'Failed to update mastery progress';

  @override
  String get chaptersToggleBookmarkFailed => 'Failed to bookmark formula';

  @override
  String get chaptersToggleChapterBookmarkFailed =>
      'Failed to bookmark chapter';

  @override
  String get dashboardCurriculumRequired =>
      'Select your board and grade to unlock your dashboard.';

  @override
  String get failedToLoadDashboard => 'Failed to load dashboard';

  @override
  String get retry => 'Retry';

  @override
  String get comingSoon => 'COMING SOON';

  @override
  String get comingSoonChip1 => 'In Development';

  @override
  String get comingSoonChip2 => 'Stay Tuned';

  @override
  String get comingSoonChip3 => 'Exciting Updates';

  @override
  String get gotIt => 'Got It';

  @override
  String get legalFooterTitle => 'Your Privacy & Security Matter to Us';

  @override
  String get legalFooterDesc =>
      'We are committed to protecting your personal information and providing a safe learning environment.';

  @override
  String get legalEffectiveDate => 'Effective: April 2026';

  @override
  String get selectSubjectTitle => 'Select a Subject';

  @override
  String get selectSubjectDesc =>
      'Tap on a subject from the Home tab to start exploring chapters and formulas.';

  @override
  String get selectSubjectFirst => 'Please select a subject first';

  @override
  String get breadcrumbHome => 'HOME';

  @override
  String get viewProfile => 'View Profile';

  @override
  String get chapterLabel => 'Chapter';

  @override
  String get unknownSubject => 'Unknown Subject';

  @override
  String get generateCheatSheet => 'Generate Cheat Sheet';

  @override
  String get studyAsFlashcards => 'Study As Flashcards';

  @override
  String get searchChaptersHint => 'Search chapters...';

  @override
  String get toggleSortDirection => 'Toggle Sort Direction';

  @override
  String get sortDescending => 'Sort Descending';

  @override
  String get sortAscending => 'Sort Ascending';

  @override
  String get continueLearning => 'Continue Learning';

  @override
  String get startNow => 'Start Now';

  @override
  String get formulasLabel => 'FORMULAS';

  @override
  String get removeBookmark => 'Remove Bookmark';

  @override
  String get bookmarkChapter => 'Bookmark Chapter';

  @override
  String get removeSavedChapter => 'Remove Saved Chapter';

  @override
  String percentDone(Object percent) {
    return '$percent% done';
  }

  @override
  String completedOfFormulas(Object completed, Object total) {
    return '$completed of $total formulas';
  }

  @override
  String get nearlyThere => 'Nearly there!';

  @override
  String get keepGoing => 'Keep going!';

  @override
  String get justStarted => 'Just getting started';

  @override
  String get locked => 'LOCKED';

  @override
  String get step1StateHint => 'Search state (e.g. Maharashtra)';

  @override
  String get step1LocalizedTitle => 'Localized Content';

  @override
  String get step1LocalizedDesc =>
      'We automatically sync with CBSE, ICSE, and various State Board syllabi based on your choice.';

  @override
  String get step1PrivacyTitle => 'Privacy Guaranteed';

  @override
  String get step1PrivacyDesc =>
      'Your location is only used to personalize your curriculum roadmap.';

  @override
  String get step2Tag => 'Curriculum Selection';

  @override
  String get step2Title => 'Select Your Curriculum';

  @override
  String get step2NotSureTitle => 'Not sure about your board?';

  @override
  String get step2NotSureDesc =>
      'Check your school ID card or textbook covers for the official board affiliation.';

  @override
  String get step2LearnMore => 'Learn more';

  @override
  String get step1Continue => 'Continue to Step 2';

  @override
  String get step1Tag => 'Location Preference';

  @override
  String get step1Title => 'Where are you studying?';

  @override
  String get step1Subtitle =>
      'We\'ll tailor your formulas and curriculum based on your region\'s educational standards.';

  @override
  String get flashcardFlip => 'Tap to flip';

  @override
  String get flashcardAgain => 'Again';

  @override
  String get flashcardHard => 'Hard';

  @override
  String get flashcardGood => 'Good';

  @override
  String get flashcardEasy => 'Easy';

  @override
  String get appVersion => 'Version 1.0.0 (Beta)';

  @override
  String get madeWithLove => 'Made with ❤️ for scholars';

  @override
  String get deleteAccountFailed => 'Failed to delete account';

  @override
  String get deleteAccountTitle => 'Delete Account';

  @override
  String get deleteAccountConfirmation =>
      'Are you sure you want to delete your account?';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get deleteAccountButton => 'Delete Permanently';

  @override
  String get dashboardLive => 'LIVE';

  @override
  String get startQuiz => 'Start Quiz';

  @override
  String get welcomeScholar => 'Welcome, Scholar';

  @override
  String get myProgress => 'My Progress';

  @override
  String get viewHistory => 'View History';

  @override
  String get noFormulasAvailable => 'No Formulas Available';

  @override
  String get formulasTitle => 'Formulas';

  @override
  String get chaptersNoContentTitle => 'No chapters available yet';

  @override
  String get chaptersNoContentDescription =>
      'This subject has not been populated with chapters yet. Try another subject or check back after the backend sync finishes.';

  @override
  String get chaptersBrowseSubjects => 'Browse Subjects';

  @override
  String get printLabel => 'Print';

  @override
  String get formulaCheatSheets => 'Formula Cheat Sheets';

  @override
  String get previousFormula => 'Previous';

  @override
  String get nextFormula => 'Next';

  @override
  String get visualizer3d => '3D Visualizer';

  @override
  String get autoRotatePause => 'Pause auto-rotate';

  @override
  String get autoRotateStart => 'Start auto-rotate';

  @override
  String get practiceQuestionLabel => 'QUESTION';

  @override
  String get ofLabel => 'of';

  @override
  String get quizCompleteTitle => 'Quiz Complete!';

  @override
  String get quizCompleteDesc => 'Great effort! Review your results below.';

  @override
  String get playAgain => 'Play Again';

  @override
  String get retryIncorrect => 'Retry Incorrect';

  @override
  String get backToDashboard => 'Back to Dashboard';

  @override
  String get savedChapters => 'Saved Chapters';

  @override
  String get savedFormulas => 'Saved Formulas';

  @override
  String get savedNotes => 'Saved Notes';

  @override
  String get editNote => 'Edit Note';

  @override
  String get addNote => 'Add Note';

  @override
  String get save => 'Save';

  @override
  String get noteTitleHint => 'Note title';

  @override
  String get noteHint => 'Write your note here...';

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String get unknownCurriculum => 'unknown_curriculum';

  @override
  String get creating => 'Creating...';

  @override
  String get supportEmail => 'support@formulaflow.com';

  @override
  String get masteryTools => 'Mastery Tools';

  @override
  String get masteryToolsSyncing =>
      'Mastery tools are syncing from backend. Please try again in a moment.';

  @override
  String get videoLessons => 'Video Lessons';

  @override
  String get cheatSheets => 'Cheat Sheets';

  @override
  String get academicInfo => 'Academic Information';

  @override
  String get accountActions => 'Account Actions';

  @override
  String get accountInformation => 'Account Information';

  @override
  String get accountType => 'Account Type';

  @override
  String get achievementNotifications => 'Achievements';

  @override
  String get achievements => 'Milestone Alerts';

  @override
  String get achievementsDesc => 'When you hit learning milestones';

  @override
  String get allSubjects => 'All Subjects';

  @override
  String get browseLessons => 'Browse Lessons';

  @override
  String get changePassword => 'Change Password';

  @override
  String get chatWithUs => 'Chat';

  @override
  String get closeLabel => 'Close Label';

  @override
  String get closePractice => 'Close Practice';

  @override
  String get closeQuiz => 'Close Quiz';

  @override
  String get dailyChallenge => 'Daily Challenge';

  @override
  String get dailyChallengeDesc => 'Test your knowledge with 5 quick formulas.';

  @override
  String get dashboardAcademicViewAll => 'View All';

  @override
  String dashboardVaultDescWithCounts(int formulas, int subjects) {
    return '$formulas formulas across $subjects subjects';
  }

  @override
  String get dashboardAcademicPath => 'Academic Path';

  @override
  String get dashboardAvailableBoards => 'Boards for your region';

  @override
  String get dashboardNoBoardsAvailable =>
      'No boards available for your region.';

  @override
  String get dashboardAvailableClasses => 'Classes for selected board';

  @override
  String get dashboardNoClassesAvailable =>
      'No classes available for this board.';

  @override
  String get dashboardActiveCurriculum => 'ACTIVE CURRICULUM';

  @override
  String get dashboardCurriculumPending => 'Syncing your board and grade...';

  @override
  String get dashboardFormulaVault => 'My Formula Vault';

  @override
  String get dashboardRetryCurriculumOptions => 'Retry board/class options';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deliveryChannels => 'Delivery Channels';

  @override
  String get dismissAnnouncement => 'Dismiss Announcement';

  @override
  String get done => 'Done';

  @override
  String get duration => 'Duration';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get editProfileSubtitle =>
      'Update your display name and avatar from one place.';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get emailNotificationsDesc => 'Receive updates via email';

  @override
  String get emailNotificationsLabel => 'Email Notifications';

  @override
  String get emailUs => 'Email';

  @override
  String get emptyBookmarksDesc => 'Empty Bookmarks Desc';

  @override
  String get encouragementMessage =>
      'You\'re in the top 5% of 9th graders this week. Keep flowing!';

  @override
  String get exploreTools => 'Explore Tools';

  @override
  String get faq1Answer =>
      'Go to Profile → Account Information to update your grade. Your curriculum will automatically adjust to match.';

  @override
  String get faq1Question => 'How do I change my grade?';

  @override
  String get faq2Answer =>
      'Yes! Previously viewed formulas and chapters are cached for offline access. Bookmarks are always available offline.';

  @override
  String get faq2Question => 'Can I use the app offline?';

  @override
  String get faq3Answer =>
      'Your streak counts consecutive days with at least 5 minutes of study time. The counter resets at midnight local time.';

  @override
  String get faq3Question => 'How are streaks calculated?';

  @override
  String get faq4Answer =>
      'Pro unlocks advanced features like 3D visualizers, unlimited practice quizzes, and priority access to new content.';

  @override
  String get faq4Question => 'What is Formula Scholar Pro?';

  @override
  String get faqLabel => 'FAQ';

  @override
  String get featuredAnnouncements => 'Featured Announcements';

  @override
  String get flashcardSessionComplete => 'Session Complete!';

  @override
  String get flashcardSessionDesc =>
      'Great work! Keep practicing to master all formulas.';

  @override
  String get flashcardStudy => 'Study Mode';

  @override
  String get formulaFlow => 'FormulaFlow';

  @override
  String get freeAccount => 'Free';

  @override
  String get frequentlyAsked => 'Frequently Asked';

  @override
  String get fullName => 'Full Name';

  @override
  String get goBack => 'Go Back';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get helpHeroSubtitle => 'Browse FAQs or contact our support team.';

  @override
  String get helpHeroTitle => 'How can we help?';

  @override
  String get incorrectLabel => 'Incorrect';

  @override
  String get legalAcceptance => 'Acceptance of Terms';

  @override
  String get legalAcceptanceContent =>
      'By creating an account or using Formula Scholar, you agree to these Terms of Service. If you do not agree, please do not use the service. We may update these terms and will notify you of significant changes.';

  @override
  String get legalChanges => 'Changes to This Policy';

  @override
  String get legalChangesContent =>
      'We may update this Privacy Policy from time to time. We will notify you of any material changes through the app and update the effective date. Your continued use of Formula Scholar after changes indicates acceptance of the updated policy.';

  @override
  String get legalChildrenPrivacy => 'Children\'s Privacy';

  @override
  String get legalChildrenPrivacyContent =>
      'Formula Scholar is designed for students of all ages. For users under 13, we collect only the minimum information necessary for the service. We do not knowingly collect sensitive personal information from children. Parents may contact us to review or delete their child\'s data.';

  @override
  String get legalContact => 'Contact Us';

  @override
  String get legalContactContent =>
      'If you have questions about this Privacy Policy or your data, please contact us through the Help & Support section in the app, or email us at support@formulascholar.app.';

  @override
  String get legalDataStorage => 'Data Storage & Security';

  @override
  String get legalDataStorageContent =>
      'Your data is stored securely on Google Firebase servers with encryption at rest and in transit. We use industry-standard security measures to protect your personal information. You can request data export or deletion at any time through the app settings.';

  @override
  String get legalDisclaimer => 'Disclaimer';

  @override
  String get legalDisclaimerContent =>
      'Formula Scholar is an educational aid and should supplement, not replace, formal education. We strive for accuracy but do not guarantee that all content is error-free. We are not liable for academic outcomes based on use of this application.';

  @override
  String get legalGoverningLaw => 'Governing Law';

  @override
  String get legalGoverningLawContent =>
      'These Terms of Service are governed by applicable law. Any disputes arising from these terms will be resolved through appropriate legal channels in the jurisdiction where the service provider is located.';

  @override
  String get legalHowWeUse => 'How We Use Your Information';

  @override
  String get legalHowWeUseContent =>
      'Your information is used to: personalize your learning dashboard, track your study progress and mastery levels, recommend relevant formulas and chapters, send study reminders (with your consent), and improve our educational content and features.';

  @override
  String get legalInfoWeCollect => 'Information We Collect';

  @override
  String get legalInfoWeCollectContent =>
      'We collect information you provide directly, such as your name, email address, and academic preferences (board, grade, subjects) when you create an account. We also collect usage data including formulas viewed, quiz scores, and study progress to personalize your experience.';

  @override
  String get legalIntellectualProperty => 'Intellectual Property';

  @override
  String get legalIntellectualPropertyContent =>
      'All content, design, and code within Formula Scholar are protected by intellectual property laws. Educational formulas themselves are in the public domain, but our presentation, explanations, and quiz content are proprietary. You may not reproduce or distribute our content without permission.';

  @override
  String get legalTermination => 'Termination';

  @override
  String get legalTerminationContent =>
      'We may suspend or terminate your access if you violate these terms. You may terminate your account at any time. Upon termination, your right to use the service ceases and your data will be deleted per our retention policy.';

  @override
  String get legalThirdParty => 'Third-Party Services';

  @override
  String get legalThirdPartyContent =>
      'We use the following third-party services: Firebase (authentication and data storage by Google), Google Sign-In (optional account linking). These services have their own privacy policies which we encourage you to review.';

  @override
  String get legalUseOfService => 'Use of Service';

  @override
  String get legalUseOfServiceContent =>
      'Formula Scholar provides educational tools for learning mathematical and scientific formulas. The service is provided \"as is\" for personal, non-commercial educational use. You agree not to: share your account credentials, use the service for unauthorized purposes, or attempt to reverse-engineer any part of the application.';

  @override
  String get legalUserAccounts => 'User Accounts';

  @override
  String get legalUserAccountsContent =>
      'You are responsible for maintaining the security of your account and password. You must provide accurate information during registration. You may delete your account at any time, which will permanently remove your data from our systems.';

  @override
  String get legalYourRights => 'Your Rights';

  @override
  String get legalYourRightsContent =>
      'You have the right to: access your personal data, correct inaccurate data, request deletion of your account and data, export your data in a portable format, and opt out of non-essential communications. To exercise these rights, contact us through the Help & Support section.';

  @override
  String get newContent => 'New Content';

  @override
  String get newContentDesc => 'When new chapters are available';

  @override
  String get nextQuestion => 'Next Question';

  @override
  String get noBookmarksFoundDesc =>
      'Try a different search term or clear the filter to see all saved formulas and chapters.';

  @override
  String get noBookmarksFoundTitle => 'No bookmarks found';

  @override
  String get noFormulasLabel => 'No Formulas Label';

  @override
  String get noSubjectsAvailable => 'No Subjects Available';

  @override
  String get nothingHereYet => 'Nothing here yet';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsEnabled => 'Notifications Active';

  @override
  String get notificationsEnabledDesc => 'Notifications Enabled Desc';

  @override
  String get onboardingAppBrand => 'Formula Sanctuary';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String onboardingStepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get pause => 'Pause';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get play => 'Play';

  @override
  String get practiceChooseSubject => 'Choose Subject';

  @override
  String get practiceNoQuestionsDesc =>
      'Your current curriculum does not have practice questions available yet. Try again soon or open Chapters to keep learning.';

  @override
  String get practiceNoQuestionsTitle => 'No practice questions yet';

  @override
  String get practiceReadyDesc =>
      'Choose a subject and test your knowledge with practice questions.';

  @override
  String get practiceReadyTitle => 'Ready to Practice?';

  @override
  String get privacyPolicyDesc => 'How we protect your data';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get proTip => 'Pro Tip';

  @override
  String get proTipContent => 'Pro Tip Content';

  @override
  String get profileAvatarUrlLabel => 'Avatar URL';

  @override
  String get profileNameLabel => 'Display Name';

  @override
  String get profileNameRequired => 'Display name is required';

  @override
  String get profileUpdatedSuccess => 'Profile updated successfully.';

  @override
  String get pushNotificationsDesc => 'Receive alerts on your device';

  @override
  String get pushNotificationsLabel => 'Push Notifications';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get readyForMore => 'Ready for more?';

  @override
  String get refreshBookmarks => 'Refresh Bookmarks';

  @override
  String get reset => 'Reset';

  @override
  String get resources => 'Resources';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get searchBookmarks => 'Search Bookmarks';

  @override
  String get settings => 'Settings';

  @override
  String get step3Subtitle =>
      'Choose your academic year to tailor formulas and practice sets to your curriculum.';

  @override
  String get step3Tag => 'Grade Selection';

  @override
  String get step3Title => 'Select Your Class';

  @override
  String get step4EnterSanctuary => 'Enter Sanctuary';

  @override
  String get step4Subtitle =>
      'Consistency is the key to mastery. How much time can you dedicate?';

  @override
  String get step4Tag => 'Commitment';

  @override
  String get step4Title => 'Set your weekly goal';

  @override
  String get streakAlerts => 'Streak Alerts';

  @override
  String get streakAlertsDesc => 'Streak Alerts Desc';

  @override
  String get studyAgain => 'Study Again';

  @override
  String get studyNotifications => 'Study Notifications';

  @override
  String get studyReminders => 'Study Reminders';

  @override
  String get studyRemindersDesc => 'Daily reminders to keep learning';

  @override
  String get termsOfServiceDesc => 'Rules and guidelines for app usage';

  @override
  String get termsOfServiceTitle => 'Terms of Service';

  @override
  String get timedMode => 'Timed Mode';

  @override
  String get timedModeDesc => 'Set a time limit for this quiz';

  @override
  String get toggleDarkMode => 'Toggle Dark Mode';

  @override
  String get userGuide => 'User Guide';

  @override
  String get userGuideDesc => 'Learn how to use Formula Scholar';

  @override
  String get verifiedAccount => 'VERIFIED';

  @override
  String get videoTutorials => 'Video Tutorials';

  @override
  String get videoTutorialsDesc => 'Watch step-by-step guides';

  @override
  String get viewTopics => 'View Topics';

  @override
  String get weeklyReport => 'Weekly Report';

  @override
  String get weeklyReportDesc => 'Summary of your weekly progress';

  @override
  String get dart => 'Dart';

  @override
  String get dashboardSanctuary => 'Formula Sanctuary';

  @override
  String get forgotPasswordCancel => 'Cancel';

  @override
  String get forgotPasswordDesc =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get forgotPasswordSend => 'Send Reset Link';

  @override
  String get forgotPasswordSuccess =>
      'Password reset link sent! Check your email inbox.';

  @override
  String get forgotPasswordTitle => 'Reset Password';

  @override
  String get signupBrandDesc =>
      'Join a sanctuary designed for focused learning. Transform complex equations into intuitive steps.';

  @override
  String get signupBrandHeadline => 'Master the Flow of Knowledge.';

  @override
  String get signupBrandTitle => 'Formula Sanctuary';

  @override
  String get signupTestimonial =>
      '\"The formulas finally make sense. It doesn\'t feel like studying; it feels like exploring.\"';

  @override
  String get signupTestimonialName => 'Ishita Sharma';

  @override
  String get signupTestimonialRole => 'Class 9 Student';

  @override
  String get step4Casual => 'Casual Learner';

  @override
  String get step4CasualDesc => '15 mins / day';

  @override
  String get step4Intensive => 'Intensive Mastery';

  @override
  String get step4IntensiveDesc => '60+ mins / day';

  @override
  String get step4Regular => 'Regular Scholar';

  @override
  String get step4RegularDesc => '30 mins / day';

  @override
  String get validationInvalidEmail => 'Please enter a valid email address';

  @override
  String get validationPasswordMinLength =>
      'Password must be at least 6 characters';

  @override
  String get validationPasswordMismatch => 'Passwords do not match';

  @override
  String get validationRequired => 'This field is required';

  @override
  String get aboutApp => 'About';

  @override
  String get aboutAppSubtitle => 'App info, licenses & legal';

  @override
  String get aboutAppTitle => 'About Formula Scholar';

  @override
  String get aboutAppTagline => 'Master every formula with confidence';

  @override
  String get aboutDeveloperSection => 'Developer';

  @override
  String get aboutDeveloperName => 'Formula Scholar Team';

  @override
  String get aboutDeveloperEmail => 'support@formulascholar.app';

  @override
  String get aboutLegalSection => 'Legal & Compliance';

  @override
  String get aboutOpenSourceLicenses => 'Open Source Licenses';

  @override
  String get aboutOpenSourceDesc => 'View third-party software licenses';

  @override
  String get aboutPrivacyDesc => 'How we handle your data';

  @override
  String get aboutTermsDesc => 'Rules for using this app';

  @override
  String get aboutRateApp => 'Rate This App';

  @override
  String get aboutRateDesc => 'Help us improve with your feedback';

  @override
  String get aboutShareApp => 'Share Formula Scholar';

  @override
  String get aboutShareDesc => 'Tell your friends about this app';

  @override
  String get myBookmarks => 'My Bookmarks';

  @override
  String get studyPlannerSubtitle => 'Plan and track your study sessions';

  @override
  String get appearance => 'Appearance';

  @override
  String get languageAndLocalizationSubtitle =>
      'Control app labels and backend content language independently';

  @override
  String get logout => 'Logout';

  @override
  String get formulasMastered => 'Formulas Mastered';

  @override
  String get daysStreak => 'Days Streak';

  @override
  String get totalPoints => 'Total Points';

  @override
  String get academicViewAllLabel => 'View All';

  @override
  String get continueStudyingLabel => 'Continue Studying';

  @override
  String get noRecentTitle => 'No Recent Studies';

  @override
  String get noRecentDescription =>
      'Start exploring chapters to see your history here.';

  @override
  String get openChaptersLabel => 'Open Chapters';

  @override
  String get boardReadyQuizTitle => 'Board Ready Quiz';

  @override
  String get boardReadyQuizDescription =>
      'Test your knowledge for the upcoming exams';

  @override
  String get startNowLabel => 'Start Now';

  @override
  String get onboardingNeedHelp => 'Need Help?';

  @override
  String get onboardingBoardSubtitle =>
      'Personalize your journey by selecting your academic board. We\'ll tailor your formulas and practice sets to your specific curriculum.';

  @override
  String get onboardingSelectBoard => 'Select Board';

  @override
  String get onboardingBoardChangeHint =>
      'Selected board can be changed later in Profile.';

  @override
  String get onboardingBoardSelected => 'BOARD SELECTED';

  @override
  String get onboardingJourneyProgress => 'Journey Progress';

  @override
  String get onboardingGradeSubtitle =>
      'We\'ll customize your FormulaFlow experience based on your current curriculum.';

  @override
  String get onboardingMostPopular => 'MOST POPULAR';

  @override
  String get onboardingGradeChangeHint =>
      'You can always change your grade in Profile settings later.';

  @override
  String get circlesAndAreas => 'Circles & Areas';

  @override
  String get geometryBasics => 'GEOMETRY BASICS';

  @override
  String get areaOfCircleQuestion =>
      'Which of the following formulas correctly represents the area of a circle with radius r?';

  @override
  String get privacyPolicy => 'Privacy Policy';
}
