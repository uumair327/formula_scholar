// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appName => 'फॉर्म्यूला स्कॉलर';

  @override
  String get dashboardHeroBadge => 'CBSE अभ्यासक्रम • इयत्ता 9';

  @override
  String get dashboardHeroTitle => 'गती आणि\\nबलाच्या नियमांमध्ये पारंगत';

  @override
  String dashboardHeroDescription(Object progress) {
    return 'भौतिकशास्त्रामध्ये आपला प्रवास सुरू ठेवा. आपण सध्याच्या प्रकरणाचा $progress% पूर्ण केला आहे.';
  }

  @override
  String get dashboardResumeLesson => 'पाठ पुन्हा सुरू करा';

  @override
  String get dashboardResumeSemantic => 'अभ्यास पुन्हा सुरू करा';

  @override
  String get quickActionsTitle => 'उपकरणे शोधा';

  @override
  String get studyPlanner => 'अभ्यास नियोजक';

  @override
  String get viewAnalytics => 'विश्लेषण पहा';

  @override
  String get flashcards => 'फ्लॅशकार्ड';

  @override
  String get welcomeBack => 'पुन्हा स्वागत आहे ✨';

  @override
  String get searchLabel => 'शोधा';

  @override
  String get searchFormulas => 'सूत्रे शोधा';

  @override
  String get searchFormulasTitle => 'सूत्रे शोधा';

  @override
  String get searchEmptyDescription =>
      'तुमच्या सर्व विषयांमध्ये आणि प्रकरणांमध्ये शोधण्यासाठी टाइप करा';

  @override
  String get noResultsFound => 'कोणतेही निकाल आढळले नाहीत';

  @override
  String get tryDifferentSearch => 'भिन्न शोध शब्द वापरून पहा';

  @override
  String get clearSearch => 'शोध साफ करा';

  @override
  String get navHome => 'होम';

  @override
  String get navSubjects => 'विषय';

  @override
  String get navPractice => 'सराव';

  @override
  String get navSaved => 'जतन केलेले';

  @override
  String get navProfile => 'प्रोफाइल';

  @override
  String get labelsLocalizationTitle => 'अॅप लेबल स्थानिकीकरण';

  @override
  String get labelsLocalizationSubtitle =>
      'अॅप लेबल्स आणि बॅकएंड सामग्री भाषा स्वतंत्रपणे नियंत्रित करा';

  @override
  String get enableLabelsLocalization => 'अॅप लेबल स्थानिकीकरण सक्षम करा';

  @override
  String get enableLabelsLocalizationDesc => 'अॅप लेबल्स निवडलेल्या भाषेत बदला';

  @override
  String get useSystemLanguage => 'सिस्टम भाषा वापरा';

  @override
  String get currentSystemLanguage => 'सध्याची सिस्टम भाषा';

  @override
  String get appLabelLanguage => 'अॅप लेबल भाषा';

  @override
  String get contentLocalizationTitle => 'बॅकएंड सामग्री स्थानिकीकरण';

  @override
  String get contentLocalizationSubtitle =>
      'अॅप लेबल्सपासून स्वतंत्रपणे Firestore सामग्री भाषा निवडा';

  @override
  String get enableContentLocalization =>
      'बॅकएंड सामग्री स्थानिकीकरण सक्षम करा';

  @override
  String get enableContentLocalizationDesc =>
      'निवडलेल्या भाषेसाठी डॅशबोर्ड सामग्री लोड करा';

  @override
  String get contentLanguage => 'सामग्री भाषा';

  @override
  String get contentLocalizationFallbackInfo =>
      'भाषांतर उपलब्ध नसल्यास अॅप English (India) वर परत जाईल.';

  @override
  String get localizationEffectiveSummary => 'प्रभावी स्थानिकीकरण';

  @override
  String get appLabels => 'अॅप लेबल्स';

  @override
  String get backendContent => 'बॅकएंड सामग्री';

  @override
  String get languageAndLocalization => 'भाषा आणि स्थानिकीकरण';

  @override
  String get languageEnglish => 'इंग्रजी';

  @override
  String get languageArabic => 'अरबी';

  @override
  String get languageUrdu => 'उर्दू';

  @override
  String get languageMarathi => 'मराठी';

  @override
  String get languageEnglishIndia => 'इंग्रजी (भारत)';

  @override
  String get viewInsights => 'इनसाइट्स पहा';

  @override
  String get loginTitle => 'पुन्हा स्वागत आहे';

  @override
  String get loginSubtitle =>
      'तुमच्या आश्रयस्थानात प्रवेश करण्यासाठी तुमची माहिती भरा.';

  @override
  String get loginEmailLabel => 'ईमेल किंवा वापरकर्ता नाव';

  @override
  String get loginEmailHint => 'scholar@formulaflow.com';

  @override
  String get loginPasswordLabel => 'पासवर्ड';

  @override
  String get loginPasswordHint => '••••••••••••';

  @override
  String get loginForgotPassword => 'पासवर्ड विसरलात?';

  @override
  String get showPassword => 'पासवर्ड दाखवा';

  @override
  String get hidePassword => 'पासवर्ड लपवा';

  @override
  String get loginSignIn => 'साइन इन';

  @override
  String get loginOr => 'किंवा';

  @override
  String get loginGoogle => 'Google';

  @override
  String get loginSchoolId => 'शाळा आयडी';

  @override
  String get loginNoAccount => 'खाते नाही का?';

  @override
  String get loginSignUp => 'साइन अप';

  @override
  String get signupTitle => 'तुमचे खाते तयार करा';

  @override
  String get signupSubtitle =>
      'संज्ञानात्मक आश्रयस्थानातील तुमचा प्रवास सुरू करा.';

  @override
  String get signupFullName => 'पूर्ण नाव';

  @override
  String get signupFullNameHint => 'John Doe';

  @override
  String get signupEmail => 'ईमेल पत्ता';

  @override
  String get signupEmailHint => 'name@school.com';

  @override
  String get signupPassword => 'पासवर्ड';

  @override
  String get signupConfirmPassword => 'पासवर्डची पुष्टी करा';

  @override
  String get signupPasswordHint => '••••••••';

  @override
  String get signupCreateAccount => 'खाते तयार करा';

  @override
  String get signupHasAccount => 'आधीपासून खाते आहे का?';

  @override
  String get signupSignIn => 'साइन इन';

  @override
  String get proBadge => 'PRO';

  @override
  String get currentGrade => 'सध्याची इयत्ता';

  @override
  String get pageNotFound => 'पृष्ठ सापडले नाही';

  @override
  String get pageNotFoundDescription =>
      'तुम्ही शोधत असलेले पृष्ठ अस्तित्वात नाही. ते हलवले गेले असू शकते किंवा URL चुकीचा आहे.';

  @override
  String get goHome => 'मुख्यपृष्ठावर जा';

  @override
  String get loginStudentPortal => 'विद्यार्थी पोर्टल';

  @override
  String get loginBrandTagline => 'प्रत्येक\nसूत्रात सहज पारंगत व्हा.';

  @override
  String get loginBrandDesc =>
      'हायस्कूल विद्यार्थ्यांसाठी अंतिम संज्ञानात्मक आश्रयस्थान. तुमच्या गणिती प्रवासात संघटित व्हा, शिका, आणि प्रगती करा.';

  @override
  String get signupTerms => 'मी सहमत आहे ';

  @override
  String get signupTermsLink => 'सेवा अटी';

  @override
  String get signupAnd => ' आणि ';

  @override
  String get signupPrivacy => 'गोपनीयता धोरण';

  @override
  String get signupOrJoin => 'किंवा याद्वारे सामील व्हा';

  @override
  String get signupFacebook => 'Facebook';

  @override
  String get profileInsightsTitle => 'प्रोफाइल इनसाइट्स';

  @override
  String get profileInsightsSubtitle => 'बॅकएंडमधील प्रगती एका नजरेत';

  @override
  String get profileInsightsSource => 'Firestore मधून समक्रमित';

  @override
  String get profileStatsPending =>
      'तुमचे प्रोफाइल आकडे येथे दिसतील जेव्हा बॅकएंड समक्रमण पूर्ण होईल.';

  @override
  String get continuePracticing => 'सराव सुरू ठेवा';

  @override
  String get browseChapters => 'प्रकरणे ब्राउझ करा';

  @override
  String get viewFullAnalytics => 'संपूर्ण विश्लेषण पहा';

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
  String get correct => 'Correct';

  @override
  String get masteryLevelIncreasing => 'Mastery Level Increasing';

  @override
  String get wrongAnswer => 'Wrong Answer';

  @override
  String get tryNextTime => 'Try Next Time';

  @override
  String get somethingWentWrong => 'Something Went Wrong';

  @override
  String get failedToLoadProfile => 'Failed To Load Profile';

  @override
  String get failedToUpdateProfile => 'Failed To Update Profile';

  @override
  String get dashboardCurriculumOptionsLoadFailed =>
      'Failed to load curriculum options';

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
      'Select your curriculum to continue';

  @override
  String get failedToLoadDashboard => 'Failed To Load Dashboard';

  @override
  String get retry => 'Retry';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get comingSoonChip1 => 'In Development';

  @override
  String get comingSoonChip2 => 'Stay Tuned';

  @override
  String get comingSoonChip3 => 'Exciting Updates';

  @override
  String get gotIt => 'Got It';

  @override
  String get legalFooterTitle => 'Safe, private, and reliable';

  @override
  String get legalFooterDesc =>
      'We prioritize your privacy and security — your data stays private.';

  @override
  String get legalEffectiveDate => 'Effective: Jan 1, 2026';

  @override
  String get selectSubjectTitle => 'Select a subject';

  @override
  String get selectSubjectDesc => 'Choose a subject to continue';

  @override
  String get selectSubjectFirst => 'Select a subject first';

  @override
  String get breadcrumbHome => 'Home';

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
  String get searchChaptersHint => 'Search chapters';

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
  String get formulasLabel => 'formulas';

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
  String get nearlyThere => 'Nearly There';

  @override
  String get keepGoing => 'Keep Going';

  @override
  String get justStarted => 'Just Started';

  @override
  String get locked => 'Locked';

  @override
  String get step1StateHint => 'State or region';

  @override
  String get step1LocalizedTitle => 'Localized content';

  @override
  String get step1LocalizedDesc => 'Content localized for your region';

  @override
  String get step1PrivacyTitle => 'Privacy';

  @override
  String get step1PrivacyDesc => 'Privacy details';

  @override
  String get step2Tag => 'Step 2';

  @override
  String get step2Title => 'Step 2';

  @override
  String get step2NotSureTitle => 'Not sure?';

  @override
  String get step2NotSureDesc =>
      'If you\'re not sure, select the recommended option.';

  @override
  String get step2LearnMore => 'Learn more';

  @override
  String get step1Continue => 'Continue';

  @override
  String get step1Tag => 'Step 1';

  @override
  String get step1Title => 'Step 1';

  @override
  String get step1Subtitle => 'Tell us where you\'re studying';

  @override
  String get flashcardFlip => 'Flip';

  @override
  String get flashcardAgain => 'Again';

  @override
  String get flashcardHard => 'Hard';

  @override
  String get flashcardGood => 'Good';

  @override
  String get flashcardEasy => 'Easy';

  @override
  String get appVersion => 'Version';

  @override
  String get madeWithLove => 'Made With Love';

  @override
  String get deleteAccountFailed => 'Failed to delete account';

  @override
  String get deleteAccountTitle => 'Delete account';

  @override
  String get deleteAccountConfirmation =>
      'Are you sure you want to delete your account?';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get deleteAccountButton => 'Delete';

  @override
  String get dashboardLive => 'Live';

  @override
  String get startQuiz => 'Start Quiz';

  @override
  String get welcomeScholar => 'Welcome Scholar';

  @override
  String get myProgress => 'My Progress';

  @override
  String get viewHistory => 'View History';

  @override
  String get noFormulasAvailable => 'No Formulas Available';

  @override
  String get formulasTitle => 'Formulas';

  @override
  String get chaptersNoContentTitle => 'No chapters';

  @override
  String get chaptersNoContentDescription =>
      'No content available in this subject';

  @override
  String get chaptersBrowseSubjects => 'Browse subjects';

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
  String get practiceQuestionLabel => 'Question';

  @override
  String get ofLabel => 'of';

  @override
  String get quizCompleteTitle => 'Quiz complete';

  @override
  String get quizCompleteDesc => 'You completed the quiz';

  @override
  String get playAgain => 'Play Again';

  @override
  String get retryIncorrect => 'Retry incorrect questions';

  @override
  String get backToDashboard => 'Back To Dashboard';

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
  String get noteHint => 'Write your note here';

  @override
  String get genericError => 'Something went wrong';

  @override
  String get unknownCurriculum => 'Unknown Curriculum';

  @override
  String get creating => 'Creating...';

  @override
  String get supportEmail => 'support@formulaflow.com';

  @override
  String get masteryTools => 'Mastery Tools';

  @override
  String get masteryToolsSyncing => 'Syncing mastery tools...';

  @override
  String get videoLessons => 'Video Lessons';

  @override
  String get cheatSheets => 'Cheat Sheets';

  @override
  String get academicInfo => 'Academic Info';

  @override
  String get accountActions => 'Account Actions';

  @override
  String get accountInformation => 'Account Information';

  @override
  String get accountType => 'Account Type';

  @override
  String get achievementNotifications => 'Achievement Notifications';

  @override
  String get achievements => 'Achievements';

  @override
  String get achievementsDesc => 'Achievements Desc';

  @override
  String get allSubjects => 'All Subjects';

  @override
  String get browseLessons => 'Browse Lessons';

  @override
  String get changePassword => 'Change Password';

  @override
  String get chatWithUs => 'Chat With Us';

  @override
  String get closeLabel => 'Close Label';

  @override
  String get closePractice => 'Close Practice';

  @override
  String get closeQuiz => 'Close Quiz';

  @override
  String get dailyChallenge => 'Daily Challenge';

  @override
  String get dailyChallengeDesc => 'Daily Challenge Desc';

  @override
  String get dashboardAcademicViewAll => 'View All';

  @override
  String dashboardVaultDescWithCounts(int formulas, int subjects) {
    return '$formulas formulas across $subjects subjects';
  }

  @override
  String get dashboardAcademicPath => 'Dashboard Academic Path';

  @override
  String get dashboardAvailableBoards => 'Boards for your region';

  @override
  String get dashboardNoBoardsAvailable => 'No boards available';

  @override
  String get dashboardAvailableClasses => 'Classes for your board';

  @override
  String get dashboardNoClassesAvailable => 'No classes available';

  @override
  String get dashboardActiveCurriculum => 'Dashboard Active Curriculum';

  @override
  String get dashboardCurriculumPending => 'Dashboard Curriculum Pending';

  @override
  String get dashboardFormulaVault => 'Dashboard Formula Vault';

  @override
  String get dashboardRetryCurriculumOptions =>
      'Dashboard Retry Curriculum Options';

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
  String get editProfileSubtitle => 'Edit Profile Subtitle';

  @override
  String get editProfileTitle => 'Edit Profile Title';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get emailNotificationsDesc => 'Email Notifications Desc';

  @override
  String get emailNotificationsLabel => 'Email Notifications Label';

  @override
  String get emailUs => 'Email Us';

  @override
  String get emptyBookmarksDesc => 'Empty Bookmarks Desc';

  @override
  String get encouragementMessage => 'Encouragement Message';

  @override
  String get exploreTools => 'Explore Tools';

  @override
  String get faq1Answer => 'Faq1 Answer';

  @override
  String get faq1Question => 'Faq1 Question';

  @override
  String get faq2Answer => 'Faq2 Answer';

  @override
  String get faq2Question => 'Faq2 Question';

  @override
  String get faq3Answer => 'Faq3 Answer';

  @override
  String get faq3Question => 'Faq3 Question';

  @override
  String get faq4Answer => 'Faq4 Answer';

  @override
  String get faq4Question => 'Faq4 Question';

  @override
  String get faqLabel => 'Faq Label';

  @override
  String get featuredAnnouncements => 'Featured Announcements';

  @override
  String get flashcardSessionComplete => 'Flashcard Session Complete';

  @override
  String get flashcardSessionDesc => 'Flashcard Session Desc';

  @override
  String get flashcardStudy => 'Flashcard Study';

  @override
  String get formulaFlow => 'Formula Flow';

  @override
  String get freeAccount => 'Free Account';

  @override
  String get frequentlyAsked => 'Frequently Asked';

  @override
  String get fullName => 'Full Name';

  @override
  String get goBack => 'Go Back';

  @override
  String get helpAndSupport => 'Help And Support';

  @override
  String get helpHeroSubtitle => 'Help Hero Subtitle';

  @override
  String get helpHeroTitle => 'Help Hero Title';

  @override
  String get incorrectLabel => 'Incorrect Label';

  @override
  String get legalAcceptance => 'Legal Acceptance';

  @override
  String get legalAcceptanceContent => 'Legal Acceptance Content';

  @override
  String get legalChanges => 'Legal Changes';

  @override
  String get legalChangesContent => 'Legal Changes Content';

  @override
  String get legalChildrenPrivacy => 'Legal Children Privacy';

  @override
  String get legalChildrenPrivacyContent => 'Legal Children Privacy Content';

  @override
  String get legalContact => 'Legal Contact';

  @override
  String get legalContactContent => 'Legal Contact Content';

  @override
  String get legalDataStorage => 'Legal Data Storage';

  @override
  String get legalDataStorageContent => 'Legal Data Storage Content';

  @override
  String get legalDisclaimer => 'Legal Disclaimer';

  @override
  String get legalDisclaimerContent => 'Legal Disclaimer Content';

  @override
  String get legalGoverningLaw => 'Legal Governing Law';

  @override
  String get legalGoverningLawContent => 'Legal Governing Law Content';

  @override
  String get legalHowWeUse => 'Legal How We Use';

  @override
  String get legalHowWeUseContent => 'Legal How We Use Content';

  @override
  String get legalInfoWeCollect => 'Legal Info We Collect';

  @override
  String get legalInfoWeCollectContent => 'Legal Info We Collect Content';

  @override
  String get legalIntellectualProperty => 'Legal Intellectual Property';

  @override
  String get legalIntellectualPropertyContent =>
      'Legal Intellectual Property Content';

  @override
  String get legalTermination => 'Legal Termination';

  @override
  String get legalTerminationContent => 'Legal Termination Content';

  @override
  String get legalThirdParty => 'Legal Third Party';

  @override
  String get legalThirdPartyContent => 'Legal Third Party Content';

  @override
  String get legalUseOfService => 'Legal Use Of Service';

  @override
  String get legalUseOfServiceContent => 'Legal Use Of Service Content';

  @override
  String get legalUserAccounts => 'Legal User Accounts';

  @override
  String get legalUserAccountsContent => 'Legal User Accounts Content';

  @override
  String get legalYourRights => 'Legal Your Rights';

  @override
  String get legalYourRightsContent => 'Legal Your Rights Content';

  @override
  String get newContent => 'New Content';

  @override
  String get newContentDesc => 'New Content Desc';

  @override
  String get nextQuestion => 'Next Question';

  @override
  String get noBookmarksFoundDesc => 'No Bookmarks Found Desc';

  @override
  String get noBookmarksFoundTitle => 'No Bookmarks Found Title';

  @override
  String get noFormulasLabel => 'No Formulas Label';

  @override
  String get noSubjectsAvailable => 'No Subjects Available';

  @override
  String get nothingHereYet => 'Nothing Here Yet';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsEnabled => 'Notifications Enabled';

  @override
  String get notificationsEnabledDesc => 'Notifications Enabled Desc';

  @override
  String get onboardingAppBrand => 'Onboarding App Brand';

  @override
  String get onboardingBack => 'Onboarding Back';

  @override
  String get onboardingContinue => 'Onboarding Continue';

  @override
  String onboardingStepOf(int current, int total) {
    return 'Onboarding Step Of';
  }

  @override
  String get pause => 'Pause';

  @override
  String get personalInfo => 'Personal Info';

  @override
  String get play => 'Play';

  @override
  String get practiceChooseSubject => 'Practice Choose Subject';

  @override
  String get practiceNoQuestionsDesc => 'Practice No Questions Desc';

  @override
  String get practiceNoQuestionsTitle => 'Practice No Questions Title';

  @override
  String get practiceReadyDesc => 'Practice Ready Desc';

  @override
  String get practiceReadyTitle => 'Practice Ready Title';

  @override
  String get privacyPolicyDesc => 'Privacy Policy Desc';

  @override
  String get privacyPolicyTitle => 'Privacy Policy Title';

  @override
  String get proTip => 'Pro Tip';

  @override
  String get proTipContent => 'Pro Tip Content';

  @override
  String get profileAvatarUrlLabel => 'Profile Avatar Url Label';

  @override
  String get profileNameLabel => 'Profile Name Label';

  @override
  String get profileNameRequired => 'Profile Name Required';

  @override
  String get profileUpdatedSuccess => 'Profile Updated Success';

  @override
  String get pushNotificationsDesc => 'Push Notifications Desc';

  @override
  String get pushNotificationsLabel => 'Push Notifications Label';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get readyForMore => 'Ready For More';

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
  String get step3Subtitle => 'Step3 Subtitle';

  @override
  String get step3Tag => 'Step3 Tag';

  @override
  String get step3Title => 'Step3 Title';

  @override
  String get step4EnterSanctuary => 'Step4 Enter Sanctuary';

  @override
  String get step4Subtitle => 'Step4 Subtitle';

  @override
  String get step4Tag => 'Step4 Tag';

  @override
  String get step4Title => 'Step4 Title';

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
  String get studyRemindersDesc => 'Study Reminders Desc';

  @override
  String get termsOfServiceDesc => 'Terms Of Service Desc';

  @override
  String get termsOfServiceTitle => 'Terms Of Service Title';

  @override
  String get timedMode => 'Timed Mode';

  @override
  String get timedModeDesc => 'Timed Mode Desc';

  @override
  String get toggleDarkMode => 'Toggle Dark Mode';

  @override
  String get userGuide => 'User Guide';

  @override
  String get userGuideDesc => 'User Guide Desc';

  @override
  String get verifiedAccount => 'Verified Account';

  @override
  String get videoTutorials => 'Video Tutorials';

  @override
  String get videoTutorialsDesc => 'Video Tutorials Desc';

  @override
  String get viewTopics => 'View Topics';

  @override
  String get weeklyReport => 'Weekly Report';

  @override
  String get weeklyReportDesc => 'Weekly Report Desc';

  @override
  String get dart => 'Dart';

  @override
  String get dashboardSanctuary => 'Dashboard Sanctuary';

  @override
  String get forgotPasswordCancel => 'Forgot Password Cancel';

  @override
  String get forgotPasswordDesc => 'Forgot Password Desc';

  @override
  String get forgotPasswordSend => 'Forgot Password Send';

  @override
  String get forgotPasswordSuccess => 'Forgot Password Success';

  @override
  String get forgotPasswordTitle => 'Forgot Password Title';

  @override
  String get signupBrandDesc => 'Signup Brand Desc';

  @override
  String get signupBrandHeadline => 'Signup Brand Headline';

  @override
  String get signupBrandTitle => 'Signup Brand Title';

  @override
  String get signupTestimonial => 'Signup Testimonial';

  @override
  String get signupTestimonialName => 'Signup Testimonial Name';

  @override
  String get signupTestimonialRole => 'Signup Testimonial Role';

  @override
  String get step4Casual => 'Step4 Casual';

  @override
  String get step4CasualDesc => 'Step4 Casual Desc';

  @override
  String get step4Intensive => 'Step4 Intensive';

  @override
  String get step4IntensiveDesc => 'Step4 Intensive Desc';

  @override
  String get step4Regular => 'Step4 Regular';

  @override
  String get step4RegularDesc => 'Step4 Regular Desc';

  @override
  String get validationInvalidEmail => 'Validation Invalid Email';

  @override
  String get validationPasswordMinLength => 'Validation Password Min Length';

  @override
  String get validationPasswordMismatch => 'Validation Password Mismatch';

  @override
  String get validationRequired => 'Validation Required';

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
