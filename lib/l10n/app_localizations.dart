import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('mr'),
    Locale('ur'),
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'Formula Scholar'**
  String get appName;

  /// No description provided for @dashboardHeroBadge.
  ///
  /// In en, this message translates to:
  /// **'CBSE Syllabus • Grade 9'**
  String get dashboardHeroBadge;

  /// No description provided for @dashboardHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Mastering Motion &\\nLaws of Forces'**
  String get dashboardHeroTitle;

  /// No description provided for @dashboardHeroDescription.
  ///
  /// In en, this message translates to:
  /// **'Continue your journey through Physics. You\'re {progress}% through the current chapter.'**
  String dashboardHeroDescription(Object progress);

  /// No description provided for @dashboardResumeLesson.
  ///
  /// In en, this message translates to:
  /// **'Resume Lesson'**
  String get dashboardResumeLesson;

  /// No description provided for @dashboardResumeSemantic.
  ///
  /// In en, this message translates to:
  /// **'Resume learning'**
  String get dashboardResumeSemantic;

  /// No description provided for @quickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore Tools'**
  String get quickActionsTitle;

  /// No description provided for @studyPlanner.
  ///
  /// In en, this message translates to:
  /// **'Study Planner'**
  String get studyPlanner;

  /// No description provided for @viewAnalytics.
  ///
  /// In en, this message translates to:
  /// **'View Analytics'**
  String get viewAnalytics;

  /// No description provided for @flashcards.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get flashcards;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back ✨'**
  String get welcomeBack;

  /// No description provided for @searchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchLabel;

  /// No description provided for @searchFormulas.
  ///
  /// In en, this message translates to:
  /// **'Search Formulas'**
  String get searchFormulas;

  /// No description provided for @searchFormulasTitle.
  ///
  /// In en, this message translates to:
  /// **'Search formulas'**
  String get searchFormulasTitle;

  /// No description provided for @searchEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Type to search across all your subjects and chapters'**
  String get searchEmptyDescription;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No Results Found'**
  String get noResultsFound;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearch;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get clearSearch;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSubjects.
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get navSubjects;

  /// No description provided for @navPractice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get navPractice;

  /// No description provided for @navSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get navSaved;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @labelsLocalizationTitle.
  ///
  /// In en, this message translates to:
  /// **'App label localization'**
  String get labelsLocalizationTitle;

  /// No description provided for @labelsLocalizationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Control app labels and backend content language independently'**
  String get labelsLocalizationSubtitle;

  /// No description provided for @enableLabelsLocalization.
  ///
  /// In en, this message translates to:
  /// **'Enable app label localization'**
  String get enableLabelsLocalization;

  /// No description provided for @enableLabelsLocalizationDesc.
  ///
  /// In en, this message translates to:
  /// **'Switch the app labels to the selected language'**
  String get enableLabelsLocalizationDesc;

  /// No description provided for @useSystemLanguage.
  ///
  /// In en, this message translates to:
  /// **'Use System Language'**
  String get useSystemLanguage;

  /// No description provided for @currentSystemLanguage.
  ///
  /// In en, this message translates to:
  /// **'Current System Language'**
  String get currentSystemLanguage;

  /// No description provided for @appLabelLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Label Language'**
  String get appLabelLanguage;

  /// No description provided for @contentLocalizationTitle.
  ///
  /// In en, this message translates to:
  /// **'Backend content localization'**
  String get contentLocalizationTitle;

  /// No description provided for @contentLocalizationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the Firestore content language separately from app labels'**
  String get contentLocalizationSubtitle;

  /// No description provided for @enableContentLocalization.
  ///
  /// In en, this message translates to:
  /// **'Enable backend content localization'**
  String get enableContentLocalization;

  /// No description provided for @enableContentLocalizationDesc.
  ///
  /// In en, this message translates to:
  /// **'Load dashboard content for the selected locale'**
  String get enableContentLocalizationDesc;

  /// No description provided for @contentLanguage.
  ///
  /// In en, this message translates to:
  /// **'Content Language'**
  String get contentLanguage;

  /// No description provided for @contentLocalizationFallbackInfo.
  ///
  /// In en, this message translates to:
  /// **'If a translation is missing, the app falls back to English (India).'**
  String get contentLocalizationFallbackInfo;

  /// No description provided for @localizationEffectiveSummary.
  ///
  /// In en, this message translates to:
  /// **'Effective localization'**
  String get localizationEffectiveSummary;

  /// No description provided for @appLabels.
  ///
  /// In en, this message translates to:
  /// **'App Labels'**
  String get appLabels;

  /// No description provided for @backendContent.
  ///
  /// In en, this message translates to:
  /// **'Backend Content'**
  String get backendContent;

  /// No description provided for @languageAndLocalization.
  ///
  /// In en, this message translates to:
  /// **'Language & Localization'**
  String get languageAndLocalization;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @languageUrdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get languageUrdu;

  /// No description provided for @languageMarathi.
  ///
  /// In en, this message translates to:
  /// **'Marathi'**
  String get languageMarathi;

  /// No description provided for @languageEnglishIndia.
  ///
  /// In en, this message translates to:
  /// **'English (India)'**
  String get languageEnglishIndia;

  /// No description provided for @viewInsights.
  ///
  /// In en, this message translates to:
  /// **'View Insights'**
  String get viewInsights;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your credentials to access your sanctuary.'**
  String get loginSubtitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email or Username'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'scholar@formulaflow.com'**
  String get loginEmailHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'••••••••••••'**
  String get loginPasswordHint;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get loginForgotPassword;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show Password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide Password'**
  String get hidePassword;

  /// No description provided for @loginSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginSignIn;

  /// No description provided for @loginOr.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get loginOr;

  /// No description provided for @loginGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get loginGoogle;

  /// No description provided for @loginSchoolId.
  ///
  /// In en, this message translates to:
  /// **'School ID'**
  String get loginSchoolId;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get loginNoAccount;

  /// No description provided for @loginSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get loginSignUp;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get signupTitle;

  /// No description provided for @signupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your journey into the Cognitive Sanctuary.'**
  String get signupSubtitle;

  /// No description provided for @signupFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get signupFullName;

  /// No description provided for @signupFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get signupFullNameHint;

  /// No description provided for @signupEmail.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get signupEmail;

  /// No description provided for @signupEmailHint.
  ///
  /// In en, this message translates to:
  /// **'name@school.com'**
  String get signupEmailHint;

  /// No description provided for @signupPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signupPassword;

  /// No description provided for @signupConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get signupConfirmPassword;

  /// No description provided for @signupPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get signupPasswordHint;

  /// No description provided for @signupCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get signupCreateAccount;

  /// No description provided for @signupHasAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get signupHasAccount;

  /// No description provided for @signupSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signupSignIn;

  /// No description provided for @proBadge.
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get proBadge;

  /// No description provided for @currentGrade.
  ///
  /// In en, this message translates to:
  /// **'Current Grade'**
  String get currentGrade;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page Not Found'**
  String get pageNotFound;

  /// No description provided for @pageNotFoundDescription.
  ///
  /// In en, this message translates to:
  /// **'The page you\'re looking for doesn\'t exist. It might have been moved or the URL is incorrect.'**
  String get pageNotFoundDescription;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get goHome;

  /// No description provided for @loginStudentPortal.
  ///
  /// In en, this message translates to:
  /// **'STUDENT PORTAL'**
  String get loginStudentPortal;

  /// No description provided for @loginBrandTagline.
  ///
  /// In en, this message translates to:
  /// **'Master every\nformula with\nease.'**
  String get loginBrandTagline;

  /// No description provided for @loginBrandDesc.
  ///
  /// In en, this message translates to:
  /// **'The ultimate cognitive sanctuary for high school scholars. Organize, learn, and excel in your mathematical journey.'**
  String get loginBrandDesc;

  /// No description provided for @signupTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get signupTerms;

  /// No description provided for @signupTermsLink.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get signupTermsLink;

  /// No description provided for @signupAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get signupAnd;

  /// No description provided for @signupPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get signupPrivacy;

  /// No description provided for @signupOrJoin.
  ///
  /// In en, this message translates to:
  /// **'Or join with'**
  String get signupOrJoin;

  /// No description provided for @signupFacebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get signupFacebook;

  /// No description provided for @profileInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Insights'**
  String get profileInsightsTitle;

  /// No description provided for @profileInsightsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Backend-fed progress at a glance'**
  String get profileInsightsSubtitle;

  /// No description provided for @profileInsightsSource.
  ///
  /// In en, this message translates to:
  /// **'Synced from Firestore'**
  String get profileInsightsSource;

  /// No description provided for @profileStatsPending.
  ///
  /// In en, this message translates to:
  /// **'Your profile stats will appear here once your backend sync completes.'**
  String get profileStatsPending;

  /// No description provided for @continuePracticing.
  ///
  /// In en, this message translates to:
  /// **'Continue Practicing'**
  String get continuePracticing;

  /// No description provided for @browseChapters.
  ///
  /// In en, this message translates to:
  /// **'Browse Chapters'**
  String get browseChapters;

  /// No description provided for @viewFullAnalytics.
  ///
  /// In en, this message translates to:
  /// **'View Full Analytics'**
  String get viewFullAnalytics;

  /// No description provided for @deletePlan.
  ///
  /// In en, this message translates to:
  /// **'Delete Plan'**
  String get deletePlan;

  /// No description provided for @noPlansYet.
  ///
  /// In en, this message translates to:
  /// **'No Plans Yet'**
  String get noPlansYet;

  /// No description provided for @createPlan.
  ///
  /// In en, this message translates to:
  /// **'Create Plan'**
  String get createPlan;

  /// No description provided for @planTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan Title'**
  String get planTitle;

  /// No description provided for @planTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Cover chapters 1-3'**
  String get planTitleHint;

  /// No description provided for @editPlan.
  ///
  /// In en, this message translates to:
  /// **'Edit Plan'**
  String get editPlan;

  /// No description provided for @newPlan.
  ///
  /// In en, this message translates to:
  /// **'New Plan'**
  String get newPlan;

  /// No description provided for @swapFormulas.
  ///
  /// In en, this message translates to:
  /// **'Swap Formulas'**
  String get swapFormulas;

  /// No description provided for @step1CountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get step1CountryLabel;

  /// No description provided for @step1StateLabel.
  ///
  /// In en, this message translates to:
  /// **'Select State or Region'**
  String get step1StateLabel;

  /// No description provided for @perCategory.
  ///
  /// In en, this message translates to:
  /// **'Per Category'**
  String get perCategory;

  /// No description provided for @timeTaken.
  ///
  /// In en, this message translates to:
  /// **'Time Taken'**
  String get timeTaken;

  /// No description provided for @practiceHistory.
  ///
  /// In en, this message translates to:
  /// **'Practice History'**
  String get practiceHistory;

  /// No description provided for @noPracticeHistory.
  ///
  /// In en, this message translates to:
  /// **'No practice history yet'**
  String get noPracticeHistory;

  /// No description provided for @noPracticeHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t completed any practice sessions yet.'**
  String get noPracticeHistoryDesc;

  /// No description provided for @scoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get scoreLabel;

  /// No description provided for @ptsLabel.
  ///
  /// In en, this message translates to:
  /// **'pts'**
  String get ptsLabel;

  /// No description provided for @correctLabel.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correctLabel;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @plusPointsTemplate.
  ///
  /// In en, this message translates to:
  /// **'+10 Points'**
  String get plusPointsTemplate;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correct;

  /// No description provided for @masteryLevelIncreasing.
  ///
  /// In en, this message translates to:
  /// **'Mastery Level Increasing'**
  String get masteryLevelIncreasing;

  /// No description provided for @wrongAnswer.
  ///
  /// In en, this message translates to:
  /// **'Wrong Answer'**
  String get wrongAnswer;

  /// No description provided for @tryNextTime.
  ///
  /// In en, this message translates to:
  /// **'Try Next Time'**
  String get tryNextTime;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get somethingWentWrong;

  /// No description provided for @failedToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed To Load Profile'**
  String get failedToLoadProfile;

  /// No description provided for @failedToUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed To Update Profile'**
  String get failedToUpdateProfile;

  /// No description provided for @dashboardCurriculumOptionsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load curriculum options'**
  String get dashboardCurriculumOptionsLoadFailed;

  /// No description provided for @chaptersFormulasLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load formulas'**
  String get chaptersFormulasLoadFailed;

  /// No description provided for @chaptersToggleMasteryFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update mastery progress'**
  String get chaptersToggleMasteryFailed;

  /// No description provided for @chaptersToggleBookmarkFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to bookmark formula'**
  String get chaptersToggleBookmarkFailed;

  /// No description provided for @chaptersToggleChapterBookmarkFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to bookmark chapter'**
  String get chaptersToggleChapterBookmarkFailed;

  /// No description provided for @dashboardCurriculumRequired.
  ///
  /// In en, this message translates to:
  /// **'Select your curriculum to continue'**
  String get dashboardCurriculumRequired;

  /// No description provided for @failedToLoadDashboard.
  ///
  /// In en, this message translates to:
  /// **'Failed To Load Dashboard'**
  String get failedToLoadDashboard;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @comingSoonChip1.
  ///
  /// In en, this message translates to:
  /// **'In Development'**
  String get comingSoonChip1;

  /// No description provided for @comingSoonChip2.
  ///
  /// In en, this message translates to:
  /// **'Stay Tuned'**
  String get comingSoonChip2;

  /// No description provided for @comingSoonChip3.
  ///
  /// In en, this message translates to:
  /// **'Exciting Updates'**
  String get comingSoonChip3;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got It'**
  String get gotIt;

  /// No description provided for @legalFooterTitle.
  ///
  /// In en, this message translates to:
  /// **'Safe, private, and reliable'**
  String get legalFooterTitle;

  /// No description provided for @legalFooterDesc.
  ///
  /// In en, this message translates to:
  /// **'We prioritize your privacy and security — your data stays private.'**
  String get legalFooterDesc;

  /// No description provided for @legalEffectiveDate.
  ///
  /// In en, this message translates to:
  /// **'Effective: Jan 1, 2026'**
  String get legalEffectiveDate;

  /// No description provided for @selectSubjectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a subject'**
  String get selectSubjectTitle;

  /// No description provided for @selectSubjectDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose a subject to continue'**
  String get selectSubjectDesc;

  /// No description provided for @selectSubjectFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a subject first'**
  String get selectSubjectFirst;

  /// No description provided for @breadcrumbHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get breadcrumbHome;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfile;

  /// No description provided for @chapterLabel.
  ///
  /// In en, this message translates to:
  /// **'Chapter'**
  String get chapterLabel;

  /// No description provided for @unknownSubject.
  ///
  /// In en, this message translates to:
  /// **'Unknown Subject'**
  String get unknownSubject;

  /// No description provided for @generateCheatSheet.
  ///
  /// In en, this message translates to:
  /// **'Generate Cheat Sheet'**
  String get generateCheatSheet;

  /// No description provided for @studyAsFlashcards.
  ///
  /// In en, this message translates to:
  /// **'Study As Flashcards'**
  String get studyAsFlashcards;

  /// No description provided for @searchChaptersHint.
  ///
  /// In en, this message translates to:
  /// **'Search chapters'**
  String get searchChaptersHint;

  /// No description provided for @toggleSortDirection.
  ///
  /// In en, this message translates to:
  /// **'Toggle Sort Direction'**
  String get toggleSortDirection;

  /// No description provided for @sortDescending.
  ///
  /// In en, this message translates to:
  /// **'Sort Descending'**
  String get sortDescending;

  /// No description provided for @sortAscending.
  ///
  /// In en, this message translates to:
  /// **'Sort Ascending'**
  String get sortAscending;

  /// No description provided for @continueLearning.
  ///
  /// In en, this message translates to:
  /// **'Continue Learning'**
  String get continueLearning;

  /// No description provided for @startNow.
  ///
  /// In en, this message translates to:
  /// **'Start Now'**
  String get startNow;

  /// No description provided for @formulasLabel.
  ///
  /// In en, this message translates to:
  /// **'formulas'**
  String get formulasLabel;

  /// No description provided for @removeBookmark.
  ///
  /// In en, this message translates to:
  /// **'Remove Bookmark'**
  String get removeBookmark;

  /// No description provided for @bookmarkChapter.
  ///
  /// In en, this message translates to:
  /// **'Bookmark Chapter'**
  String get bookmarkChapter;

  /// No description provided for @removeSavedChapter.
  ///
  /// In en, this message translates to:
  /// **'Remove Saved Chapter'**
  String get removeSavedChapter;

  /// No description provided for @percentDone.
  ///
  /// In en, this message translates to:
  /// **'{percent}% done'**
  String percentDone(Object percent);

  /// No description provided for @completedOfFormulas.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} formulas'**
  String completedOfFormulas(Object completed, Object total);

  /// No description provided for @nearlyThere.
  ///
  /// In en, this message translates to:
  /// **'Nearly There'**
  String get nearlyThere;

  /// No description provided for @keepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep Going'**
  String get keepGoing;

  /// No description provided for @justStarted.
  ///
  /// In en, this message translates to:
  /// **'Just Started'**
  String get justStarted;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @step1StateHint.
  ///
  /// In en, this message translates to:
  /// **'State or region'**
  String get step1StateHint;

  /// No description provided for @step1LocalizedTitle.
  ///
  /// In en, this message translates to:
  /// **'Localized content'**
  String get step1LocalizedTitle;

  /// No description provided for @step1LocalizedDesc.
  ///
  /// In en, this message translates to:
  /// **'Content localized for your region'**
  String get step1LocalizedDesc;

  /// No description provided for @step1PrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get step1PrivacyTitle;

  /// No description provided for @step1PrivacyDesc.
  ///
  /// In en, this message translates to:
  /// **'Privacy details'**
  String get step1PrivacyDesc;

  /// No description provided for @step2Tag.
  ///
  /// In en, this message translates to:
  /// **'Step 2'**
  String get step2Tag;

  /// No description provided for @step2Title.
  ///
  /// In en, this message translates to:
  /// **'Step 2'**
  String get step2Title;

  /// No description provided for @step2NotSureTitle.
  ///
  /// In en, this message translates to:
  /// **'Not sure?'**
  String get step2NotSureTitle;

  /// No description provided for @step2NotSureDesc.
  ///
  /// In en, this message translates to:
  /// **'If you\'re not sure, select the recommended option.'**
  String get step2NotSureDesc;

  /// No description provided for @step2LearnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get step2LearnMore;

  /// No description provided for @step1Continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get step1Continue;

  /// No description provided for @step1Tag.
  ///
  /// In en, this message translates to:
  /// **'Step 1'**
  String get step1Tag;

  /// No description provided for @step1Title.
  ///
  /// In en, this message translates to:
  /// **'Step 1'**
  String get step1Title;

  /// No description provided for @step1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us where you\'re studying'**
  String get step1Subtitle;

  /// No description provided for @flashcardFlip.
  ///
  /// In en, this message translates to:
  /// **'Flip'**
  String get flashcardFlip;

  /// No description provided for @flashcardAgain.
  ///
  /// In en, this message translates to:
  /// **'Again'**
  String get flashcardAgain;

  /// No description provided for @flashcardHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get flashcardHard;

  /// No description provided for @flashcardGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get flashcardGood;

  /// No description provided for @flashcardEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get flashcardEasy;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get appVersion;

  /// No description provided for @madeWithLove.
  ///
  /// In en, this message translates to:
  /// **'Made With Love'**
  String get madeWithLove;

  /// No description provided for @deleteAccountFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account'**
  String get deleteAccountFailed;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get deleteAccountConfirmation;

  /// No description provided for @cancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// No description provided for @deleteAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAccountButton;

  /// No description provided for @dashboardLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get dashboardLive;

  /// No description provided for @startQuiz.
  ///
  /// In en, this message translates to:
  /// **'Start Quiz'**
  String get startQuiz;

  /// No description provided for @welcomeScholar.
  ///
  /// In en, this message translates to:
  /// **'Welcome Scholar'**
  String get welcomeScholar;

  /// No description provided for @myProgress.
  ///
  /// In en, this message translates to:
  /// **'My Progress'**
  String get myProgress;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistory;

  /// No description provided for @noFormulasAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Formulas Available'**
  String get noFormulasAvailable;

  /// No description provided for @formulasTitle.
  ///
  /// In en, this message translates to:
  /// **'Formulas'**
  String get formulasTitle;

  /// No description provided for @chaptersNoContentTitle.
  ///
  /// In en, this message translates to:
  /// **'No chapters'**
  String get chaptersNoContentTitle;

  /// No description provided for @chaptersNoContentDescription.
  ///
  /// In en, this message translates to:
  /// **'No content available in this subject'**
  String get chaptersNoContentDescription;

  /// No description provided for @chaptersBrowseSubjects.
  ///
  /// In en, this message translates to:
  /// **'Browse subjects'**
  String get chaptersBrowseSubjects;

  /// No description provided for @printLabel.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get printLabel;

  /// No description provided for @formulaCheatSheets.
  ///
  /// In en, this message translates to:
  /// **'Formula Cheat Sheets'**
  String get formulaCheatSheets;

  /// No description provided for @previousFormula.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previousFormula;

  /// No description provided for @nextFormula.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextFormula;

  /// No description provided for @visualizer3d.
  ///
  /// In en, this message translates to:
  /// **'3D Visualizer'**
  String get visualizer3d;

  /// No description provided for @autoRotatePause.
  ///
  /// In en, this message translates to:
  /// **'Pause auto-rotate'**
  String get autoRotatePause;

  /// No description provided for @autoRotateStart.
  ///
  /// In en, this message translates to:
  /// **'Start auto-rotate'**
  String get autoRotateStart;

  /// No description provided for @practiceQuestionLabel.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get practiceQuestionLabel;

  /// No description provided for @ofLabel.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofLabel;

  /// No description provided for @quizCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiz complete'**
  String get quizCompleteTitle;

  /// No description provided for @quizCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'You completed the quiz'**
  String get quizCompleteDesc;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// No description provided for @retryIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Retry incorrect questions'**
  String get retryIncorrect;

  /// No description provided for @backToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Back To Dashboard'**
  String get backToDashboard;

  /// No description provided for @savedChapters.
  ///
  /// In en, this message translates to:
  /// **'Saved Chapters'**
  String get savedChapters;

  /// No description provided for @savedFormulas.
  ///
  /// In en, this message translates to:
  /// **'Saved Formulas'**
  String get savedFormulas;

  /// No description provided for @savedNotes.
  ///
  /// In en, this message translates to:
  /// **'Saved Notes'**
  String get savedNotes;

  /// No description provided for @editNote.
  ///
  /// In en, this message translates to:
  /// **'Edit Note'**
  String get editNote;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @noteTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Note title'**
  String get noteTitleHint;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'Write your note here'**
  String get noteHint;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get genericError;

  /// No description provided for @unknownCurriculum.
  ///
  /// In en, this message translates to:
  /// **'Unknown Curriculum'**
  String get unknownCurriculum;

  /// No description provided for @creating.
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get creating;

  /// No description provided for @supportEmail.
  ///
  /// In en, this message translates to:
  /// **'support@formulaflow.com'**
  String get supportEmail;

  /// No description provided for @masteryTools.
  ///
  /// In en, this message translates to:
  /// **'Mastery Tools'**
  String get masteryTools;

  /// No description provided for @masteryToolsSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing mastery tools...'**
  String get masteryToolsSyncing;

  /// No description provided for @videoLessons.
  ///
  /// In en, this message translates to:
  /// **'Video Lessons'**
  String get videoLessons;

  /// No description provided for @cheatSheets.
  ///
  /// In en, this message translates to:
  /// **'Cheat Sheets'**
  String get cheatSheets;

  /// No description provided for @academicInfo.
  ///
  /// In en, this message translates to:
  /// **'Academic Info'**
  String get academicInfo;

  /// No description provided for @accountActions.
  ///
  /// In en, this message translates to:
  /// **'Account Actions'**
  String get accountActions;

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// No description provided for @accountType.
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get accountType;

  /// No description provided for @achievementNotifications.
  ///
  /// In en, this message translates to:
  /// **'Achievement Notifications'**
  String get achievementNotifications;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @achievementsDesc.
  ///
  /// In en, this message translates to:
  /// **'Achievements Desc'**
  String get achievementsDesc;

  /// No description provided for @allSubjects.
  ///
  /// In en, this message translates to:
  /// **'All Subjects'**
  String get allSubjects;

  /// No description provided for @browseLessons.
  ///
  /// In en, this message translates to:
  /// **'Browse Lessons'**
  String get browseLessons;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @chatWithUs.
  ///
  /// In en, this message translates to:
  /// **'Chat With Us'**
  String get chatWithUs;

  /// No description provided for @closeLabel.
  ///
  /// In en, this message translates to:
  /// **'Close Label'**
  String get closeLabel;

  /// No description provided for @closePractice.
  ///
  /// In en, this message translates to:
  /// **'Close Practice'**
  String get closePractice;

  /// No description provided for @closeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Close Quiz'**
  String get closeQuiz;

  /// No description provided for @dailyChallenge.
  ///
  /// In en, this message translates to:
  /// **'Daily Challenge'**
  String get dailyChallenge;

  /// No description provided for @dailyChallengeDesc.
  ///
  /// In en, this message translates to:
  /// **'Daily Challenge Desc'**
  String get dailyChallengeDesc;

  /// No description provided for @dashboardAcademicViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get dashboardAcademicViewAll;

  /// No description provided for @dashboardVaultDescWithCounts.
  ///
  /// In en, this message translates to:
  /// **'{formulas} formulas across {subjects} subjects'**
  String dashboardVaultDescWithCounts(int formulas, int subjects);

  /// No description provided for @dashboardAcademicPath.
  ///
  /// In en, this message translates to:
  /// **'Dashboard Academic Path'**
  String get dashboardAcademicPath;

  /// No description provided for @dashboardAvailableBoards.
  ///
  /// In en, this message translates to:
  /// **'Boards for your region'**
  String get dashboardAvailableBoards;

  /// No description provided for @dashboardNoBoardsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No boards available'**
  String get dashboardNoBoardsAvailable;

  /// No description provided for @dashboardAvailableClasses.
  ///
  /// In en, this message translates to:
  /// **'Classes for your board'**
  String get dashboardAvailableClasses;

  /// No description provided for @dashboardNoClassesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No classes available'**
  String get dashboardNoClassesAvailable;

  /// No description provided for @dashboardActiveCurriculum.
  ///
  /// In en, this message translates to:
  /// **'Dashboard Active Curriculum'**
  String get dashboardActiveCurriculum;

  /// No description provided for @dashboardCurriculumPending.
  ///
  /// In en, this message translates to:
  /// **'Dashboard Curriculum Pending'**
  String get dashboardCurriculumPending;

  /// No description provided for @dashboardFormulaVault.
  ///
  /// In en, this message translates to:
  /// **'Dashboard Formula Vault'**
  String get dashboardFormulaVault;

  /// No description provided for @dashboardRetryCurriculumOptions.
  ///
  /// In en, this message translates to:
  /// **'Dashboard Retry Curriculum Options'**
  String get dashboardRetryCurriculumOptions;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deliveryChannels.
  ///
  /// In en, this message translates to:
  /// **'Delivery Channels'**
  String get deliveryChannels;

  /// No description provided for @dismissAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Dismiss Announcement'**
  String get dismissAnnouncement;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @editProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile Subtitle'**
  String get editProfileSubtitle;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile Title'**
  String get editProfileTitle;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @emailNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications Desc'**
  String get emailNotificationsDesc;

  /// No description provided for @emailNotificationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications Label'**
  String get emailNotificationsLabel;

  /// No description provided for @emailUs.
  ///
  /// In en, this message translates to:
  /// **'Email Us'**
  String get emailUs;

  /// No description provided for @emptyBookmarksDesc.
  ///
  /// In en, this message translates to:
  /// **'Empty Bookmarks Desc'**
  String get emptyBookmarksDesc;

  /// No description provided for @encouragementMessage.
  ///
  /// In en, this message translates to:
  /// **'Encouragement Message'**
  String get encouragementMessage;

  /// No description provided for @exploreTools.
  ///
  /// In en, this message translates to:
  /// **'Explore Tools'**
  String get exploreTools;

  /// No description provided for @faq1Answer.
  ///
  /// In en, this message translates to:
  /// **'Faq1 Answer'**
  String get faq1Answer;

  /// No description provided for @faq1Question.
  ///
  /// In en, this message translates to:
  /// **'Faq1 Question'**
  String get faq1Question;

  /// No description provided for @faq2Answer.
  ///
  /// In en, this message translates to:
  /// **'Faq2 Answer'**
  String get faq2Answer;

  /// No description provided for @faq2Question.
  ///
  /// In en, this message translates to:
  /// **'Faq2 Question'**
  String get faq2Question;

  /// No description provided for @faq3Answer.
  ///
  /// In en, this message translates to:
  /// **'Faq3 Answer'**
  String get faq3Answer;

  /// No description provided for @faq3Question.
  ///
  /// In en, this message translates to:
  /// **'Faq3 Question'**
  String get faq3Question;

  /// No description provided for @faq4Answer.
  ///
  /// In en, this message translates to:
  /// **'Faq4 Answer'**
  String get faq4Answer;

  /// No description provided for @faq4Question.
  ///
  /// In en, this message translates to:
  /// **'Faq4 Question'**
  String get faq4Question;

  /// No description provided for @faqLabel.
  ///
  /// In en, this message translates to:
  /// **'Faq Label'**
  String get faqLabel;

  /// No description provided for @featuredAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Featured Announcements'**
  String get featuredAnnouncements;

  /// No description provided for @flashcardSessionComplete.
  ///
  /// In en, this message translates to:
  /// **'Flashcard Session Complete'**
  String get flashcardSessionComplete;

  /// No description provided for @flashcardSessionDesc.
  ///
  /// In en, this message translates to:
  /// **'Flashcard Session Desc'**
  String get flashcardSessionDesc;

  /// No description provided for @flashcardStudy.
  ///
  /// In en, this message translates to:
  /// **'Flashcard Study'**
  String get flashcardStudy;

  /// No description provided for @formulaFlow.
  ///
  /// In en, this message translates to:
  /// **'Formula Flow'**
  String get formulaFlow;

  /// No description provided for @freeAccount.
  ///
  /// In en, this message translates to:
  /// **'Free Account'**
  String get freeAccount;

  /// No description provided for @frequentlyAsked.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked'**
  String get frequentlyAsked;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help And Support'**
  String get helpAndSupport;

  /// No description provided for @helpHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help Hero Subtitle'**
  String get helpHeroSubtitle;

  /// No description provided for @helpHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Help Hero Title'**
  String get helpHeroTitle;

  /// No description provided for @incorrectLabel.
  ///
  /// In en, this message translates to:
  /// **'Incorrect Label'**
  String get incorrectLabel;

  /// No description provided for @legalAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Legal Acceptance'**
  String get legalAcceptance;

  /// No description provided for @legalAcceptanceContent.
  ///
  /// In en, this message translates to:
  /// **'Legal Acceptance Content'**
  String get legalAcceptanceContent;

  /// No description provided for @legalChanges.
  ///
  /// In en, this message translates to:
  /// **'Legal Changes'**
  String get legalChanges;

  /// No description provided for @legalChangesContent.
  ///
  /// In en, this message translates to:
  /// **'Legal Changes Content'**
  String get legalChangesContent;

  /// No description provided for @legalChildrenPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Legal Children Privacy'**
  String get legalChildrenPrivacy;

  /// No description provided for @legalChildrenPrivacyContent.
  ///
  /// In en, this message translates to:
  /// **'Legal Children Privacy Content'**
  String get legalChildrenPrivacyContent;

  /// No description provided for @legalContact.
  ///
  /// In en, this message translates to:
  /// **'Legal Contact'**
  String get legalContact;

  /// No description provided for @legalContactContent.
  ///
  /// In en, this message translates to:
  /// **'Legal Contact Content'**
  String get legalContactContent;

  /// No description provided for @legalDataStorage.
  ///
  /// In en, this message translates to:
  /// **'Legal Data Storage'**
  String get legalDataStorage;

  /// No description provided for @legalDataStorageContent.
  ///
  /// In en, this message translates to:
  /// **'Legal Data Storage Content'**
  String get legalDataStorageContent;

  /// No description provided for @legalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Legal Disclaimer'**
  String get legalDisclaimer;

  /// No description provided for @legalDisclaimerContent.
  ///
  /// In en, this message translates to:
  /// **'Legal Disclaimer Content'**
  String get legalDisclaimerContent;

  /// No description provided for @legalGoverningLaw.
  ///
  /// In en, this message translates to:
  /// **'Legal Governing Law'**
  String get legalGoverningLaw;

  /// No description provided for @legalGoverningLawContent.
  ///
  /// In en, this message translates to:
  /// **'Legal Governing Law Content'**
  String get legalGoverningLawContent;

  /// No description provided for @legalHowWeUse.
  ///
  /// In en, this message translates to:
  /// **'Legal How We Use'**
  String get legalHowWeUse;

  /// No description provided for @legalHowWeUseContent.
  ///
  /// In en, this message translates to:
  /// **'Legal How We Use Content'**
  String get legalHowWeUseContent;

  /// No description provided for @legalInfoWeCollect.
  ///
  /// In en, this message translates to:
  /// **'Legal Info We Collect'**
  String get legalInfoWeCollect;

  /// No description provided for @legalInfoWeCollectContent.
  ///
  /// In en, this message translates to:
  /// **'Legal Info We Collect Content'**
  String get legalInfoWeCollectContent;

  /// No description provided for @legalIntellectualProperty.
  ///
  /// In en, this message translates to:
  /// **'Legal Intellectual Property'**
  String get legalIntellectualProperty;

  /// No description provided for @legalIntellectualPropertyContent.
  ///
  /// In en, this message translates to:
  /// **'Legal Intellectual Property Content'**
  String get legalIntellectualPropertyContent;

  /// No description provided for @legalTermination.
  ///
  /// In en, this message translates to:
  /// **'Legal Termination'**
  String get legalTermination;

  /// No description provided for @legalTerminationContent.
  ///
  /// In en, this message translates to:
  /// **'Legal Termination Content'**
  String get legalTerminationContent;

  /// No description provided for @legalThirdParty.
  ///
  /// In en, this message translates to:
  /// **'Legal Third Party'**
  String get legalThirdParty;

  /// No description provided for @legalThirdPartyContent.
  ///
  /// In en, this message translates to:
  /// **'Legal Third Party Content'**
  String get legalThirdPartyContent;

  /// No description provided for @legalUseOfService.
  ///
  /// In en, this message translates to:
  /// **'Legal Use Of Service'**
  String get legalUseOfService;

  /// No description provided for @legalUseOfServiceContent.
  ///
  /// In en, this message translates to:
  /// **'Legal Use Of Service Content'**
  String get legalUseOfServiceContent;

  /// No description provided for @legalUserAccounts.
  ///
  /// In en, this message translates to:
  /// **'Legal User Accounts'**
  String get legalUserAccounts;

  /// No description provided for @legalUserAccountsContent.
  ///
  /// In en, this message translates to:
  /// **'Legal User Accounts Content'**
  String get legalUserAccountsContent;

  /// No description provided for @legalYourRights.
  ///
  /// In en, this message translates to:
  /// **'Legal Your Rights'**
  String get legalYourRights;

  /// No description provided for @legalYourRightsContent.
  ///
  /// In en, this message translates to:
  /// **'Legal Your Rights Content'**
  String get legalYourRightsContent;

  /// No description provided for @newContent.
  ///
  /// In en, this message translates to:
  /// **'New Content'**
  String get newContent;

  /// No description provided for @newContentDesc.
  ///
  /// In en, this message translates to:
  /// **'New Content Desc'**
  String get newContentDesc;

  /// No description provided for @nextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next Question'**
  String get nextQuestion;

  /// No description provided for @noBookmarksFoundDesc.
  ///
  /// In en, this message translates to:
  /// **'No Bookmarks Found Desc'**
  String get noBookmarksFoundDesc;

  /// No description provided for @noBookmarksFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'No Bookmarks Found Title'**
  String get noBookmarksFoundTitle;

  /// No description provided for @noFormulasLabel.
  ///
  /// In en, this message translates to:
  /// **'No Formulas Label'**
  String get noFormulasLabel;

  /// No description provided for @noSubjectsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Subjects Available'**
  String get noSubjectsAvailable;

  /// No description provided for @nothingHereYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing Here Yet'**
  String get nothingHereYet;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications Enabled'**
  String get notificationsEnabled;

  /// No description provided for @notificationsEnabledDesc.
  ///
  /// In en, this message translates to:
  /// **'Notifications Enabled Desc'**
  String get notificationsEnabledDesc;

  /// No description provided for @onboardingAppBrand.
  ///
  /// In en, this message translates to:
  /// **'Onboarding App Brand'**
  String get onboardingAppBrand;

  /// No description provided for @onboardingBack.
  ///
  /// In en, this message translates to:
  /// **'Onboarding Back'**
  String get onboardingBack;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Onboarding Continue'**
  String get onboardingContinue;

  /// No description provided for @onboardingStepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String onboardingStepOf(int current, int total);

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get personalInfo;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @practiceChooseSubject.
  ///
  /// In en, this message translates to:
  /// **'Practice Choose Subject'**
  String get practiceChooseSubject;

  /// No description provided for @practiceNoQuestionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Practice No Questions Desc'**
  String get practiceNoQuestionsDesc;

  /// No description provided for @practiceNoQuestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Practice No Questions Title'**
  String get practiceNoQuestionsTitle;

  /// No description provided for @practiceReadyDesc.
  ///
  /// In en, this message translates to:
  /// **'Practice Ready Desc'**
  String get practiceReadyDesc;

  /// No description provided for @practiceReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Practice Ready Title'**
  String get practiceReadyTitle;

  /// No description provided for @privacyPolicyDesc.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy Desc'**
  String get privacyPolicyDesc;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy Title'**
  String get privacyPolicyTitle;

  /// No description provided for @proTip.
  ///
  /// In en, this message translates to:
  /// **'Pro Tip'**
  String get proTip;

  /// No description provided for @proTipContent.
  ///
  /// In en, this message translates to:
  /// **'Pro Tip Content'**
  String get proTipContent;

  /// No description provided for @profileAvatarUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile Avatar Url Label'**
  String get profileAvatarUrlLabel;

  /// No description provided for @profileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile Name Label'**
  String get profileNameLabel;

  /// No description provided for @profileNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Profile Name Required'**
  String get profileNameRequired;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile Updated Success'**
  String get profileUpdatedSuccess;

  /// No description provided for @pushNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications Desc'**
  String get pushNotificationsDesc;

  /// No description provided for @pushNotificationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications Label'**
  String get pushNotificationsLabel;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @readyForMore.
  ///
  /// In en, this message translates to:
  /// **'Ready For More'**
  String get readyForMore;

  /// No description provided for @refreshBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Refresh Bookmarks'**
  String get refreshBookmarks;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @resources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get resources;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @searchBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Search Bookmarks'**
  String get searchBookmarks;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @step3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Step3 Subtitle'**
  String get step3Subtitle;

  /// No description provided for @step3Tag.
  ///
  /// In en, this message translates to:
  /// **'Step3 Tag'**
  String get step3Tag;

  /// No description provided for @step3Title.
  ///
  /// In en, this message translates to:
  /// **'Step3 Title'**
  String get step3Title;

  /// No description provided for @step4EnterSanctuary.
  ///
  /// In en, this message translates to:
  /// **'Step4 Enter Sanctuary'**
  String get step4EnterSanctuary;

  /// No description provided for @step4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Step4 Subtitle'**
  String get step4Subtitle;

  /// No description provided for @step4Tag.
  ///
  /// In en, this message translates to:
  /// **'Step4 Tag'**
  String get step4Tag;

  /// No description provided for @step4Title.
  ///
  /// In en, this message translates to:
  /// **'Step4 Title'**
  String get step4Title;

  /// No description provided for @streakAlerts.
  ///
  /// In en, this message translates to:
  /// **'Streak Alerts'**
  String get streakAlerts;

  /// No description provided for @streakAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Streak Alerts Desc'**
  String get streakAlertsDesc;

  /// No description provided for @studyAgain.
  ///
  /// In en, this message translates to:
  /// **'Study Again'**
  String get studyAgain;

  /// No description provided for @studyNotifications.
  ///
  /// In en, this message translates to:
  /// **'Study Notifications'**
  String get studyNotifications;

  /// No description provided for @studyReminders.
  ///
  /// In en, this message translates to:
  /// **'Study Reminders'**
  String get studyReminders;

  /// No description provided for @studyRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Study Reminders Desc'**
  String get studyRemindersDesc;

  /// No description provided for @termsOfServiceDesc.
  ///
  /// In en, this message translates to:
  /// **'Terms Of Service Desc'**
  String get termsOfServiceDesc;

  /// No description provided for @termsOfServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms Of Service Title'**
  String get termsOfServiceTitle;

  /// No description provided for @timedMode.
  ///
  /// In en, this message translates to:
  /// **'Timed Mode'**
  String get timedMode;

  /// No description provided for @timedModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Timed Mode Desc'**
  String get timedModeDesc;

  /// No description provided for @toggleDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Toggle Dark Mode'**
  String get toggleDarkMode;

  /// No description provided for @userGuide.
  ///
  /// In en, this message translates to:
  /// **'User Guide'**
  String get userGuide;

  /// No description provided for @userGuideDesc.
  ///
  /// In en, this message translates to:
  /// **'User Guide Desc'**
  String get userGuideDesc;

  /// No description provided for @verifiedAccount.
  ///
  /// In en, this message translates to:
  /// **'Verified Account'**
  String get verifiedAccount;

  /// No description provided for @videoTutorials.
  ///
  /// In en, this message translates to:
  /// **'Video Tutorials'**
  String get videoTutorials;

  /// No description provided for @videoTutorialsDesc.
  ///
  /// In en, this message translates to:
  /// **'Video Tutorials Desc'**
  String get videoTutorialsDesc;

  /// No description provided for @viewTopics.
  ///
  /// In en, this message translates to:
  /// **'View Topics'**
  String get viewTopics;

  /// No description provided for @weeklyReport.
  ///
  /// In en, this message translates to:
  /// **'Weekly Report'**
  String get weeklyReport;

  /// No description provided for @weeklyReportDesc.
  ///
  /// In en, this message translates to:
  /// **'Weekly Report Desc'**
  String get weeklyReportDesc;

  /// No description provided for @dart.
  ///
  /// In en, this message translates to:
  /// **'Dart'**
  String get dart;

  /// No description provided for @dashboardSanctuary.
  ///
  /// In en, this message translates to:
  /// **'Dashboard Sanctuary'**
  String get dashboardSanctuary;

  /// No description provided for @forgotPasswordCancel.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password Cancel'**
  String get forgotPasswordCancel;

  /// No description provided for @forgotPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password Desc'**
  String get forgotPasswordDesc;

  /// No description provided for @forgotPasswordSend.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password Send'**
  String get forgotPasswordSend;

  /// No description provided for @forgotPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password Success'**
  String get forgotPasswordSuccess;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password Title'**
  String get forgotPasswordTitle;

  /// No description provided for @signupBrandDesc.
  ///
  /// In en, this message translates to:
  /// **'Signup Brand Desc'**
  String get signupBrandDesc;

  /// No description provided for @signupBrandHeadline.
  ///
  /// In en, this message translates to:
  /// **'Signup Brand Headline'**
  String get signupBrandHeadline;

  /// No description provided for @signupBrandTitle.
  ///
  /// In en, this message translates to:
  /// **'Signup Brand Title'**
  String get signupBrandTitle;

  /// No description provided for @signupTestimonial.
  ///
  /// In en, this message translates to:
  /// **'Signup Testimonial'**
  String get signupTestimonial;

  /// No description provided for @signupTestimonialName.
  ///
  /// In en, this message translates to:
  /// **'Signup Testimonial Name'**
  String get signupTestimonialName;

  /// No description provided for @signupTestimonialRole.
  ///
  /// In en, this message translates to:
  /// **'Signup Testimonial Role'**
  String get signupTestimonialRole;

  /// No description provided for @step4Casual.
  ///
  /// In en, this message translates to:
  /// **'Step4 Casual'**
  String get step4Casual;

  /// No description provided for @step4CasualDesc.
  ///
  /// In en, this message translates to:
  /// **'Step4 Casual Desc'**
  String get step4CasualDesc;

  /// No description provided for @step4Intensive.
  ///
  /// In en, this message translates to:
  /// **'Step4 Intensive'**
  String get step4Intensive;

  /// No description provided for @step4IntensiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Step4 Intensive Desc'**
  String get step4IntensiveDesc;

  /// No description provided for @step4Regular.
  ///
  /// In en, this message translates to:
  /// **'Step4 Regular'**
  String get step4Regular;

  /// No description provided for @step4RegularDesc.
  ///
  /// In en, this message translates to:
  /// **'Step4 Regular Desc'**
  String get step4RegularDesc;

  /// No description provided for @validationInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Validation Invalid Email'**
  String get validationInvalidEmail;

  /// No description provided for @validationPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Validation Password Min Length'**
  String get validationPasswordMinLength;

  /// No description provided for @validationPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Validation Password Mismatch'**
  String get validationPasswordMismatch;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'Validation Required'**
  String get validationRequired;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutApp;

  /// No description provided for @aboutAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'App info, licenses & legal'**
  String get aboutAppSubtitle;

  /// No description provided for @aboutAppTitle.
  ///
  /// In en, this message translates to:
  /// **'About Formula Scholar'**
  String get aboutAppTitle;

  /// No description provided for @aboutAppTagline.
  ///
  /// In en, this message translates to:
  /// **'Master every formula with confidence'**
  String get aboutAppTagline;

  /// No description provided for @aboutDeveloperSection.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get aboutDeveloperSection;

  /// No description provided for @aboutDeveloperName.
  ///
  /// In en, this message translates to:
  /// **'Formula Scholar Team'**
  String get aboutDeveloperName;

  /// No description provided for @aboutDeveloperEmail.
  ///
  /// In en, this message translates to:
  /// **'support@formulascholar.app'**
  String get aboutDeveloperEmail;

  /// No description provided for @aboutLegalSection.
  ///
  /// In en, this message translates to:
  /// **'Legal & Compliance'**
  String get aboutLegalSection;

  /// No description provided for @aboutOpenSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get aboutOpenSourceLicenses;

  /// No description provided for @aboutOpenSourceDesc.
  ///
  /// In en, this message translates to:
  /// **'View third-party software licenses'**
  String get aboutOpenSourceDesc;

  /// No description provided for @aboutPrivacyDesc.
  ///
  /// In en, this message translates to:
  /// **'How we handle your data'**
  String get aboutPrivacyDesc;

  /// No description provided for @aboutTermsDesc.
  ///
  /// In en, this message translates to:
  /// **'Rules for using this app'**
  String get aboutTermsDesc;

  /// No description provided for @aboutRateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate This App'**
  String get aboutRateApp;

  /// No description provided for @aboutRateDesc.
  ///
  /// In en, this message translates to:
  /// **'Help us improve with your feedback'**
  String get aboutRateDesc;

  /// No description provided for @aboutShareApp.
  ///
  /// In en, this message translates to:
  /// **'Share Formula Scholar'**
  String get aboutShareApp;

  /// No description provided for @aboutShareDesc.
  ///
  /// In en, this message translates to:
  /// **'Tell your friends about this app'**
  String get aboutShareDesc;

  /// No description provided for @myBookmarks.
  ///
  /// In en, this message translates to:
  /// **'My Bookmarks'**
  String get myBookmarks;

  /// No description provided for @studyPlannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Organize your study schedule'**
  String get studyPlannerSubtitle;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @languageAndLocalizationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Control app labels and backend content language independently'**
  String get languageAndLocalizationSubtitle;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @formulasMastered.
  ///
  /// In en, this message translates to:
  /// **'Formulas Mastered'**
  String get formulasMastered;

  /// No description provided for @daysStreak.
  ///
  /// In en, this message translates to:
  /// **'Days Streak'**
  String get daysStreak;

  /// No description provided for @totalPoints.
  ///
  /// In en, this message translates to:
  /// **'Total Points'**
  String get totalPoints;

  /// No description provided for @academicViewAllLabel.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get academicViewAllLabel;

  /// No description provided for @continueStudyingLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue Studying'**
  String get continueStudyingLabel;

  /// No description provided for @noRecentTitle.
  ///
  /// In en, this message translates to:
  /// **'No Recent Studies'**
  String get noRecentTitle;

  /// No description provided for @noRecentDescription.
  ///
  /// In en, this message translates to:
  /// **'Start exploring chapters to see your history here.'**
  String get noRecentDescription;

  /// No description provided for @openChaptersLabel.
  ///
  /// In en, this message translates to:
  /// **'Open Chapters'**
  String get openChaptersLabel;

  /// No description provided for @boardReadyQuizTitle.
  ///
  /// In en, this message translates to:
  /// **'Board Ready Quiz'**
  String get boardReadyQuizTitle;

  /// No description provided for @boardReadyQuizDescription.
  ///
  /// In en, this message translates to:
  /// **'Test your knowledge for the upcoming exams'**
  String get boardReadyQuizDescription;

  /// No description provided for @startNowLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Now'**
  String get startNowLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'mr', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'mr':
      return AppLocalizationsMr();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
