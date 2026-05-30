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
    return 'Continue your journey through Physics. You\'re $progress% through the current chapter.';
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
  String get noResultsFound => 'No results found';

  @override
  String get tryDifferentSearch => 'Try a different search term';

  @override
  String get clearSearch => 'Clear search';

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
  String get useSystemLanguage => 'Use system language';

  @override
  String get currentSystemLanguage => 'Current system language';

  @override
  String get appLabelLanguage => 'App label language';

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
  String get contentLanguage => 'Content language';

  @override
  String get contentLocalizationFallbackInfo =>
      'If a translation is missing, the app falls back to English (India).';

  @override
  String get localizationEffectiveSummary => 'Effective localization';

  @override
  String get appLabels => 'App labels';

  @override
  String get backendContent => 'Backend content';

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
  String get viewInsights => 'View insights';

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
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

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
  String get loginBrandTagline => 'Master every\nformula with\nease.';

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
  String get deletePlan => 'Delete plan';

  @override
  String get noPlansYet => 'No plans yet';

  @override
  String get createPlan => 'Create Plan';

  @override
  String get planTitle => 'Plan title';

  @override
  String get planTitleHint => 'e.g. Cover chapters 1-3';

  @override
  String get editPlan => 'Edit Plan';

  @override
  String get newPlan => 'New Plan';

  @override
  String get swapFormulas => 'Swap formulas';

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
  String get masteryLevelIncreasing => 'Mastery level increasing';

  @override
  String get wrongAnswer => 'Wrong answer';

  @override
  String get tryNextTime => 'Try next time';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get failedToLoadProfile => 'Failed to load profile';

  @override
  String get failedToUpdateProfile => 'Failed to update profile';

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
  String get gotIt => 'Got it';

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
  String get viewProfile => 'View profile';

  @override
  String get chapterLabel => 'Chapter';

  @override
  String get unknownSubject => 'Unknown subject';

  @override
  String get generateCheatSheet => 'Generate cheat sheet';

  @override
  String get studyAsFlashcards => 'Study as flashcards';

  @override
  String get searchChaptersHint => 'Search chapters';

  @override
  String get toggleSortDirection => 'Toggle sort direction';

  @override
  String get sortDescending => 'Sort descending';

  @override
  String get sortAscending => 'Sort ascending';

  @override
  String get continueLearning => 'Continue learning';

  @override
  String get startNow => 'Start now';

  @override
  String get formulasLabel => 'formulas';

  @override
  String get removeBookmark => 'Remove bookmark';

  @override
  String get bookmarkChapter => 'Bookmark chapter';

  @override
  String get removeSavedChapter => 'Remove saved chapter';

  @override
  String percentDone(Object percent) {
    return '$percent% done';
  }

  @override
  String completedOfFormulas(Object completed, Object total) {
    return '$completed of $total formulas';
  }

  @override
  String get nearlyThere => 'Nearly there';

  @override
  String get keepGoing => 'Keep going';

  @override
  String get justStarted => 'Just started';

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
  String get madeWithLove => 'Made with love';

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
  String get startQuiz => 'Start quiz';

  @override
  String get welcomeScholar => 'Welcome Scholar';

  @override
  String get myProgress => 'My progress';

  @override
  String get viewHistory => 'View history';

  @override
  String get noFormulasAvailable => 'No formulas available';

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
  String get playAgain => 'Play again';

  @override
  String get retryIncorrect => 'Retry incorrect questions';

  @override
  String get backToDashboard => 'Back to dashboard';

  @override
  String get savedChapters => 'Saved chapters';

  @override
  String get savedFormulas => 'Saved formulas';

  @override
  String get savedNotes => 'Saved notes';

  @override
  String get editNote => 'Edit note';

  @override
  String get addNote => 'Add note';

  @override
  String get save => 'Save';

  @override
  String get noteTitleHint => 'Note title';

  @override
  String get noteHint => 'Write your note here';

  @override
  String get genericError => 'Something went wrong';

  @override
  String get unknownCurriculum => 'Unknown curriculum';

  @override
  String get creating => 'Creating...';

  @override
  String get supportEmail => 'support@formulaflow.com';

  @override
  String get masteryTools => 'Mastery Tools';

  @override
  String get masteryToolsSyncing => 'Syncing mastery tools...';

  @override
  String get videoLessons => 'Video lessons';

  @override
  String get cheatSheets => 'Cheat sheets';

  @override
  String get academicInfo => 'Academicinfo';

  @override
  String get accountActions => 'Accountactions';

  @override
  String get accountInformation => 'Accountinformation';

  @override
  String get accountType => 'Accounttype';

  @override
  String get achievementNotifications => 'Achievementnotifications';

  @override
  String get achievements => 'Achievements';

  @override
  String get achievementsDesc => 'Achievementsdesc';

  @override
  String get allSubjects => 'Allsubjects';

  @override
  String get browseLessons => 'Browselessons';

  @override
  String get changePassword => 'Changepassword';

  @override
  String get chatWithUs => 'Chatwithus';

  @override
  String get closeLabel => 'Closelabel';

  @override
  String get closePractice => 'Closepractice';

  @override
  String get closeQuiz => 'Closequiz';

  @override
  String get dailyChallenge => 'Dailychallenge';

  @override
  String get dailyChallengeDesc => 'Dailychallengedesc';

  @override
  String get dashboardAcademicViewAll => 'View All';

  @override
  String dashboardVaultDescWithCounts(int formulas, int subjects) {
    return '$formulas formulas across $subjects subjects';
  }

  @override
  String get dashboardAcademicPath => 'Dashboardacademicpath';

  @override
  String get dashboardAvailableBoards => 'Boards for your region';

  @override
  String get dashboardNoBoardsAvailable => 'No boards available';

  @override
  String get dashboardAvailableClasses => 'Classes for your board';

  @override
  String get dashboardNoClassesAvailable => 'No classes available';

  @override
  String get dashboardActiveCurriculum => 'Dashboardactivecurriculum';

  @override
  String get dashboardCurriculumPending => 'Dashboardcurriculumpending';

  @override
  String get dashboardFormulaVault => 'Dashboardformulavault';

  @override
  String get dashboardRetryCurriculumOptions =>
      'Dashboardretrycurriculumoptions';

  @override
  String get deleteAccount => 'Deleteaccount';

  @override
  String get deliveryChannels => 'Deliverychannels';

  @override
  String get dismissAnnouncement => 'Dismissannouncement';

  @override
  String get done => 'Done';

  @override
  String get duration => 'Duration';

  @override
  String get editProfile => 'Editprofile';

  @override
  String get editProfileSubtitle => 'Editprofilesubtitle';

  @override
  String get editProfileTitle => 'Editprofiletitle';

  @override
  String get emailAddress => 'Emailaddress';

  @override
  String get emailNotificationsDesc => 'Emailnotificationsdesc';

  @override
  String get emailNotificationsLabel => 'Emailnotificationslabel';

  @override
  String get emailUs => 'Emailus';

  @override
  String get emptyBookmarksDesc => 'Emptybookmarksdesc';

  @override
  String get encouragementMessage => 'Encouragementmessage';

  @override
  String get exploreTools => 'Exploretools';

  @override
  String get faq1Answer => 'Faq1answer';

  @override
  String get faq1Question => 'Faq1question';

  @override
  String get faq2Answer => 'Faq2answer';

  @override
  String get faq2Question => 'Faq2question';

  @override
  String get faq3Answer => 'Faq3answer';

  @override
  String get faq3Question => 'Faq3question';

  @override
  String get faq4Answer => 'Faq4answer';

  @override
  String get faq4Question => 'Faq4question';

  @override
  String get faqLabel => 'Faqlabel';

  @override
  String get featuredAnnouncements => 'Featuredannouncements';

  @override
  String get flashcardSessionComplete => 'Flashcardsessioncomplete';

  @override
  String get flashcardSessionDesc => 'Flashcardsessiondesc';

  @override
  String get flashcardStudy => 'Flashcardstudy';

  @override
  String get formulaFlow => 'Formulaflow';

  @override
  String get freeAccount => 'Freeaccount';

  @override
  String get frequentlyAsked => 'Frequentlyasked';

  @override
  String get fullName => 'Fullname';

  @override
  String get goBack => 'Goback';

  @override
  String get helpAndSupport => 'Helpandsupport';

  @override
  String get helpHeroSubtitle => 'Helpherosubtitle';

  @override
  String get helpHeroTitle => 'Helpherotitle';

  @override
  String get incorrectLabel => 'Incorrectlabel';

  @override
  String get legalAcceptance => 'Legalacceptance';

  @override
  String get legalAcceptanceContent => 'Legalacceptancecontent';

  @override
  String get legalChanges => 'Legalchanges';

  @override
  String get legalChangesContent => 'Legalchangescontent';

  @override
  String get legalChildrenPrivacy => 'Legalchildrenprivacy';

  @override
  String get legalChildrenPrivacyContent => 'Legalchildrenprivacycontent';

  @override
  String get legalContact => 'Legalcontact';

  @override
  String get legalContactContent => 'Legalcontactcontent';

  @override
  String get legalDataStorage => 'Legaldatastorage';

  @override
  String get legalDataStorageContent => 'Legaldatastoragecontent';

  @override
  String get legalDisclaimer => 'Legaldisclaimer';

  @override
  String get legalDisclaimerContent => 'Legaldisclaimercontent';

  @override
  String get legalGoverningLaw => 'Legalgoverninglaw';

  @override
  String get legalGoverningLawContent => 'Legalgoverninglawcontent';

  @override
  String get legalHowWeUse => 'Legalhowweuse';

  @override
  String get legalHowWeUseContent => 'Legalhowweusecontent';

  @override
  String get legalInfoWeCollect => 'Legalinfowecollect';

  @override
  String get legalInfoWeCollectContent => 'Legalinfowecollectcontent';

  @override
  String get legalIntellectualProperty => 'Legalintellectualproperty';

  @override
  String get legalIntellectualPropertyContent =>
      'Legalintellectualpropertycontent';

  @override
  String get legalTermination => 'Legaltermination';

  @override
  String get legalTerminationContent => 'Legalterminationcontent';

  @override
  String get legalThirdParty => 'Legalthirdparty';

  @override
  String get legalThirdPartyContent => 'Legalthirdpartycontent';

  @override
  String get legalUseOfService => 'Legaluseofservice';

  @override
  String get legalUseOfServiceContent => 'Legaluseofservicecontent';

  @override
  String get legalUserAccounts => 'Legaluseraccounts';

  @override
  String get legalUserAccountsContent => 'Legaluseraccountscontent';

  @override
  String get legalYourRights => 'Legalyourrights';

  @override
  String get legalYourRightsContent => 'Legalyourrightscontent';

  @override
  String get newContent => 'Newcontent';

  @override
  String get newContentDesc => 'Newcontentdesc';

  @override
  String get nextQuestion => 'Nextquestion';

  @override
  String get noBookmarksFoundDesc => 'Nobookmarksfounddesc';

  @override
  String get noBookmarksFoundTitle => 'Nobookmarksfoundtitle';

  @override
  String get noFormulasLabel => 'Noformulaslabel';

  @override
  String get noSubjectsAvailable => 'Nosubjectsavailable';

  @override
  String get nothingHereYet => 'Nothinghereyet';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsEnabled => 'Notificationsenabled';

  @override
  String get notificationsEnabledDesc => 'Notificationsenableddesc';

  @override
  String get onboardingAppBrand => 'Onboardingappbrand';

  @override
  String get onboardingBack => 'Onboardingback';

  @override
  String get onboardingContinue => 'Onboardingcontinue';

  @override
  String onboardingStepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get pause => 'Pause';

  @override
  String get personalInfo => 'Personalinfo';

  @override
  String get play => 'Play';

  @override
  String get practiceChooseSubject => 'Practicechoosesubject';

  @override
  String get practiceNoQuestionsDesc => 'Practicenoquestionsdesc';

  @override
  String get practiceNoQuestionsTitle => 'Practicenoquestionstitle';

  @override
  String get practiceReadyDesc => 'Practicereadydesc';

  @override
  String get practiceReadyTitle => 'Practicereadytitle';

  @override
  String get privacyPolicyDesc => 'Privacypolicydesc';

  @override
  String get privacyPolicyTitle => 'Privacypolicytitle';

  @override
  String get proTip => 'Protip';

  @override
  String get proTipContent => 'Protipcontent';

  @override
  String get profileAvatarUrlLabel => 'Profileavatarurllabel';

  @override
  String get profileNameLabel => 'Profilenamelabel';

  @override
  String get profileNameRequired => 'Profilenamerequired';

  @override
  String get profileUpdatedSuccess => 'Profileupdatedsuccess';

  @override
  String get pushNotificationsDesc => 'Pushnotificationsdesc';

  @override
  String get pushNotificationsLabel => 'Pushnotificationslabel';

  @override
  String get quickActions => 'Quickactions';

  @override
  String get readyForMore => 'Readyformore';

  @override
  String get refreshBookmarks => 'Refreshbookmarks';

  @override
  String get reset => 'Reset';

  @override
  String get resources => 'Resources';

  @override
  String get saveChanges => 'Savechanges';

  @override
  String get searchBookmarks => 'Searchbookmarks';

  @override
  String get settings => 'Settings';

  @override
  String get step3Subtitle => 'Step3subtitle';

  @override
  String get step3Tag => 'Step3tag';

  @override
  String get step3Title => 'Step3title';

  @override
  String get step4EnterSanctuary => 'Step4entersanctuary';

  @override
  String get step4Subtitle => 'Step4subtitle';

  @override
  String get step4Tag => 'Step4tag';

  @override
  String get step4Title => 'Step4title';

  @override
  String get streakAlerts => 'Streakalerts';

  @override
  String get streakAlertsDesc => 'Streakalertsdesc';

  @override
  String get studyAgain => 'Studyagain';

  @override
  String get studyNotifications => 'Studynotifications';

  @override
  String get studyReminders => 'Studyreminders';

  @override
  String get studyRemindersDesc => 'Studyremindersdesc';

  @override
  String get termsOfServiceDesc => 'Termsofservicedesc';

  @override
  String get termsOfServiceTitle => 'Termsofservicetitle';

  @override
  String get timedMode => 'Timedmode';

  @override
  String get timedModeDesc => 'Timedmodedesc';

  @override
  String get toggleDarkMode => 'Toggledarkmode';

  @override
  String get userGuide => 'Userguide';

  @override
  String get userGuideDesc => 'Userguidedesc';

  @override
  String get verifiedAccount => 'Verifiedaccount';

  @override
  String get videoTutorials => 'Videotutorials';

  @override
  String get videoTutorialsDesc => 'Videotutorialsdesc';

  @override
  String get viewTopics => 'Viewtopics';

  @override
  String get weeklyReport => 'Weeklyreport';

  @override
  String get weeklyReportDesc => 'Weeklyreportdesc';

  @override
  String get dart => 'Dart';

  @override
  String get dashboardSanctuary => 'Dashboardsanctuary';

  @override
  String get forgotPasswordCancel => 'Forgotpasswordcancel';

  @override
  String get forgotPasswordDesc => 'Forgotpassworddesc';

  @override
  String get forgotPasswordSend => 'Forgotpasswordsend';

  @override
  String get forgotPasswordSuccess => 'Forgotpasswordsuccess';

  @override
  String get forgotPasswordTitle => 'Forgotpasswordtitle';

  @override
  String get signupBrandDesc => 'Signupbranddesc';

  @override
  String get signupBrandHeadline => 'Signupbrandheadline';

  @override
  String get signupBrandTitle => 'Signupbrandtitle';

  @override
  String get signupTestimonial => 'Signuptestimonial';

  @override
  String get signupTestimonialName => 'Signuptestimonialname';

  @override
  String get signupTestimonialRole => 'Signuptestimonialrole';

  @override
  String get step4Casual => 'Step4casual';

  @override
  String get step4CasualDesc => 'Step4casualdesc';

  @override
  String get step4Intensive => 'Step4intensive';

  @override
  String get step4IntensiveDesc => 'Step4intensivedesc';

  @override
  String get step4Regular => 'Step4regular';

  @override
  String get step4RegularDesc => 'Step4regulardesc';

  @override
  String get validationInvalidEmail => 'Validationinvalidemail';

  @override
  String get validationPasswordMinLength => 'Validationpasswordminlength';

  @override
  String get validationPasswordMismatch => 'Validationpasswordmismatch';

  @override
  String get validationRequired => 'Validationrequired';

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
  String get studyPlannerSubtitle => 'Organize your study schedule';

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
}
