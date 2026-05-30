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
    return 'Onboardingstepof';
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
