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
  /// **'Search formulas'**
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
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearch;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
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
  /// **'Use system language'**
  String get useSystemLanguage;

  /// No description provided for @currentSystemLanguage.
  ///
  /// In en, this message translates to:
  /// **'Current system language'**
  String get currentSystemLanguage;

  /// No description provided for @appLabelLanguage.
  ///
  /// In en, this message translates to:
  /// **'App label language'**
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
  /// **'Content language'**
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
  /// **'App labels'**
  String get appLabels;

  /// No description provided for @backendContent.
  ///
  /// In en, this message translates to:
  /// **'Backend content'**
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
  /// **'View insights'**
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
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
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
  /// **'Delete plan'**
  String get deletePlan;

  /// No description provided for @noPlansYet.
  ///
  /// In en, this message translates to:
  /// **'No plans yet'**
  String get noPlansYet;

  /// No description provided for @createPlan.
  ///
  /// In en, this message translates to:
  /// **'Create Plan'**
  String get createPlan;

  /// No description provided for @planTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan title'**
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
  /// **'Swap formulas'**
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
  /// **'Mastery level increasing'**
  String get masteryLevelIncreasing;

  /// No description provided for @wrongAnswer.
  ///
  /// In en, this message translates to:
  /// **'Wrong answer'**
  String get wrongAnswer;

  /// No description provided for @tryNextTime.
  ///
  /// In en, this message translates to:
  /// **'Try next time'**
  String get tryNextTime;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @failedToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get failedToLoadProfile;

  /// No description provided for @failedToUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
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
  /// **'Failed to load dashboard'**
  String get failedToLoadDashboard;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'COMING SOON'**
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
  /// **'Got it'**
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
  /// **'View profile'**
  String get viewProfile;

  /// No description provided for @chapterLabel.
  ///
  /// In en, this message translates to:
  /// **'Chapter'**
  String get chapterLabel;

  /// No description provided for @unknownSubject.
  ///
  /// In en, this message translates to:
  /// **'Unknown subject'**
  String get unknownSubject;

  /// No description provided for @generateCheatSheet.
  ///
  /// In en, this message translates to:
  /// **'Generate cheat sheet'**
  String get generateCheatSheet;

  /// No description provided for @studyAsFlashcards.
  ///
  /// In en, this message translates to:
  /// **'Study as flashcards'**
  String get studyAsFlashcards;

  /// No description provided for @searchChaptersHint.
  ///
  /// In en, this message translates to:
  /// **'Search chapters'**
  String get searchChaptersHint;

  /// No description provided for @toggleSortDirection.
  ///
  /// In en, this message translates to:
  /// **'Toggle sort direction'**
  String get toggleSortDirection;

  /// No description provided for @sortDescending.
  ///
  /// In en, this message translates to:
  /// **'Sort descending'**
  String get sortDescending;

  /// No description provided for @sortAscending.
  ///
  /// In en, this message translates to:
  /// **'Sort ascending'**
  String get sortAscending;

  /// No description provided for @continueLearning.
  ///
  /// In en, this message translates to:
  /// **'Continue learning'**
  String get continueLearning;

  /// No description provided for @startNow.
  ///
  /// In en, this message translates to:
  /// **'Start now'**
  String get startNow;

  /// No description provided for @formulasLabel.
  ///
  /// In en, this message translates to:
  /// **'formulas'**
  String get formulasLabel;

  /// No description provided for @removeBookmark.
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark'**
  String get removeBookmark;

  /// No description provided for @bookmarkChapter.
  ///
  /// In en, this message translates to:
  /// **'Bookmark chapter'**
  String get bookmarkChapter;

  /// No description provided for @removeSavedChapter.
  ///
  /// In en, this message translates to:
  /// **'Remove saved chapter'**
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
  /// **'Nearly there'**
  String get nearlyThere;

  /// No description provided for @keepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going'**
  String get keepGoing;

  /// No description provided for @justStarted.
  ///
  /// In en, this message translates to:
  /// **'Just started'**
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
  /// **'Made with love'**
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
  /// **'Start quiz'**
  String get startQuiz;

  /// No description provided for @welcomeScholar.
  ///
  /// In en, this message translates to:
  /// **'Welcome Scholar'**
  String get welcomeScholar;

  /// No description provided for @myProgress.
  ///
  /// In en, this message translates to:
  /// **'My progress'**
  String get myProgress;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View history'**
  String get viewHistory;

  /// No description provided for @noFormulasAvailable.
  ///
  /// In en, this message translates to:
  /// **'No formulas available'**
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
  /// **'Play again'**
  String get playAgain;

  /// No description provided for @retryIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Retry incorrect questions'**
  String get retryIncorrect;

  /// No description provided for @backToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Back to dashboard'**
  String get backToDashboard;

  /// No description provided for @savedChapters.
  ///
  /// In en, this message translates to:
  /// **'Saved chapters'**
  String get savedChapters;

  /// No description provided for @savedFormulas.
  ///
  /// In en, this message translates to:
  /// **'Saved formulas'**
  String get savedFormulas;

  /// No description provided for @savedNotes.
  ///
  /// In en, this message translates to:
  /// **'Saved notes'**
  String get savedNotes;

  /// No description provided for @editNote.
  ///
  /// In en, this message translates to:
  /// **'Edit note'**
  String get editNote;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
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
  /// **'Unknown curriculum'**
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
  /// **'Video lessons'**
  String get videoLessons;

  /// No description provided for @cheatSheets.
  ///
  /// In en, this message translates to:
  /// **'Cheat sheets'**
  String get cheatSheets;

  /// No description provided for @academicInfo.
  ///
  /// In en, this message translates to:
  /// **'Academicinfo'**
  String get academicInfo;

  /// No description provided for @accountActions.
  ///
  /// In en, this message translates to:
  /// **'Accountactions'**
  String get accountActions;

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Accountinformation'**
  String get accountInformation;

  /// No description provided for @accountType.
  ///
  /// In en, this message translates to:
  /// **'Accounttype'**
  String get accountType;

  /// No description provided for @achievementNotifications.
  ///
  /// In en, this message translates to:
  /// **'Achievementnotifications'**
  String get achievementNotifications;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @achievementsDesc.
  ///
  /// In en, this message translates to:
  /// **'Achievementsdesc'**
  String get achievementsDesc;

  /// No description provided for @allSubjects.
  ///
  /// In en, this message translates to:
  /// **'Allsubjects'**
  String get allSubjects;

  /// No description provided for @browseLessons.
  ///
  /// In en, this message translates to:
  /// **'Browselessons'**
  String get browseLessons;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Changepassword'**
  String get changePassword;

  /// No description provided for @chatWithUs.
  ///
  /// In en, this message translates to:
  /// **'Chatwithus'**
  String get chatWithUs;

  /// No description provided for @closeLabel.
  ///
  /// In en, this message translates to:
  /// **'Closelabel'**
  String get closeLabel;

  /// No description provided for @closePractice.
  ///
  /// In en, this message translates to:
  /// **'Closepractice'**
  String get closePractice;

  /// No description provided for @closeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Closequiz'**
  String get closeQuiz;

  /// No description provided for @dailyChallenge.
  ///
  /// In en, this message translates to:
  /// **'Dailychallenge'**
  String get dailyChallenge;

  /// No description provided for @dailyChallengeDesc.
  ///
  /// In en, this message translates to:
  /// **'Dailychallengedesc'**
  String get dailyChallengeDesc;

  /// No description provided for @dashboardAcademicPath.
  ///
  /// In en, this message translates to:
  /// **'Dashboardacademicpath'**
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
  /// **'Dashboardactivecurriculum'**
  String get dashboardActiveCurriculum;

  /// No description provided for @dashboardCurriculumPending.
  ///
  /// In en, this message translates to:
  /// **'Dashboardcurriculumpending'**
  String get dashboardCurriculumPending;

  /// No description provided for @dashboardFormulaVault.
  ///
  /// In en, this message translates to:
  /// **'Dashboardformulavault'**
  String get dashboardFormulaVault;

  /// No description provided for @dashboardRetryCurriculumOptions.
  ///
  /// In en, this message translates to:
  /// **'Dashboardretrycurriculumoptions'**
  String get dashboardRetryCurriculumOptions;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Deleteaccount'**
  String get deleteAccount;

  /// No description provided for @deliveryChannels.
  ///
  /// In en, this message translates to:
  /// **'Deliverychannels'**
  String get deliveryChannels;

  /// No description provided for @dismissAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Dismissannouncement'**
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
  /// **'Editprofile'**
  String get editProfile;

  /// No description provided for @editProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Editprofilesubtitle'**
  String get editProfileSubtitle;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Editprofiletitle'**
  String get editProfileTitle;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Emailaddress'**
  String get emailAddress;

  /// No description provided for @emailNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Emailnotificationsdesc'**
  String get emailNotificationsDesc;

  /// No description provided for @emailNotificationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Emailnotificationslabel'**
  String get emailNotificationsLabel;

  /// No description provided for @emailUs.
  ///
  /// In en, this message translates to:
  /// **'Emailus'**
  String get emailUs;

  /// No description provided for @emptyBookmarksDesc.
  ///
  /// In en, this message translates to:
  /// **'Emptybookmarksdesc'**
  String get emptyBookmarksDesc;

  /// No description provided for @encouragementMessage.
  ///
  /// In en, this message translates to:
  /// **'Encouragementmessage'**
  String get encouragementMessage;

  /// No description provided for @exploreTools.
  ///
  /// In en, this message translates to:
  /// **'Exploretools'**
  String get exploreTools;

  /// No description provided for @faq1Answer.
  ///
  /// In en, this message translates to:
  /// **'Faq1answer'**
  String get faq1Answer;

  /// No description provided for @faq1Question.
  ///
  /// In en, this message translates to:
  /// **'Faq1question'**
  String get faq1Question;

  /// No description provided for @faq2Answer.
  ///
  /// In en, this message translates to:
  /// **'Faq2answer'**
  String get faq2Answer;

  /// No description provided for @faq2Question.
  ///
  /// In en, this message translates to:
  /// **'Faq2question'**
  String get faq2Question;

  /// No description provided for @faq3Answer.
  ///
  /// In en, this message translates to:
  /// **'Faq3answer'**
  String get faq3Answer;

  /// No description provided for @faq3Question.
  ///
  /// In en, this message translates to:
  /// **'Faq3question'**
  String get faq3Question;

  /// No description provided for @faq4Answer.
  ///
  /// In en, this message translates to:
  /// **'Faq4answer'**
  String get faq4Answer;

  /// No description provided for @faq4Question.
  ///
  /// In en, this message translates to:
  /// **'Faq4question'**
  String get faq4Question;

  /// No description provided for @faqLabel.
  ///
  /// In en, this message translates to:
  /// **'Faqlabel'**
  String get faqLabel;

  /// No description provided for @featuredAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Featuredannouncements'**
  String get featuredAnnouncements;

  /// No description provided for @flashcardSessionComplete.
  ///
  /// In en, this message translates to:
  /// **'Flashcardsessioncomplete'**
  String get flashcardSessionComplete;

  /// No description provided for @flashcardSessionDesc.
  ///
  /// In en, this message translates to:
  /// **'Flashcardsessiondesc'**
  String get flashcardSessionDesc;

  /// No description provided for @flashcardStudy.
  ///
  /// In en, this message translates to:
  /// **'Flashcardstudy'**
  String get flashcardStudy;

  /// No description provided for @formulaFlow.
  ///
  /// In en, this message translates to:
  /// **'Formulaflow'**
  String get formulaFlow;

  /// No description provided for @freeAccount.
  ///
  /// In en, this message translates to:
  /// **'Freeaccount'**
  String get freeAccount;

  /// No description provided for @frequentlyAsked.
  ///
  /// In en, this message translates to:
  /// **'Frequentlyasked'**
  String get frequentlyAsked;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Fullname'**
  String get fullName;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Goback'**
  String get goBack;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Helpandsupport'**
  String get helpAndSupport;

  /// No description provided for @helpHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Helpherosubtitle'**
  String get helpHeroSubtitle;

  /// No description provided for @helpHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Helpherotitle'**
  String get helpHeroTitle;

  /// No description provided for @incorrectLabel.
  ///
  /// In en, this message translates to:
  /// **'Incorrectlabel'**
  String get incorrectLabel;

  /// No description provided for @legalAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Legalacceptance'**
  String get legalAcceptance;

  /// No description provided for @legalAcceptanceContent.
  ///
  /// In en, this message translates to:
  /// **'Legalacceptancecontent'**
  String get legalAcceptanceContent;

  /// No description provided for @legalChanges.
  ///
  /// In en, this message translates to:
  /// **'Legalchanges'**
  String get legalChanges;

  /// No description provided for @legalChangesContent.
  ///
  /// In en, this message translates to:
  /// **'Legalchangescontent'**
  String get legalChangesContent;

  /// No description provided for @legalChildrenPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Legalchildrenprivacy'**
  String get legalChildrenPrivacy;

  /// No description provided for @legalChildrenPrivacyContent.
  ///
  /// In en, this message translates to:
  /// **'Legalchildrenprivacycontent'**
  String get legalChildrenPrivacyContent;

  /// No description provided for @legalContact.
  ///
  /// In en, this message translates to:
  /// **'Legalcontact'**
  String get legalContact;

  /// No description provided for @legalContactContent.
  ///
  /// In en, this message translates to:
  /// **'Legalcontactcontent'**
  String get legalContactContent;

  /// No description provided for @legalDataStorage.
  ///
  /// In en, this message translates to:
  /// **'Legaldatastorage'**
  String get legalDataStorage;

  /// No description provided for @legalDataStorageContent.
  ///
  /// In en, this message translates to:
  /// **'Legaldatastoragecontent'**
  String get legalDataStorageContent;

  /// No description provided for @legalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Legaldisclaimer'**
  String get legalDisclaimer;

  /// No description provided for @legalDisclaimerContent.
  ///
  /// In en, this message translates to:
  /// **'Legaldisclaimercontent'**
  String get legalDisclaimerContent;

  /// No description provided for @legalGoverningLaw.
  ///
  /// In en, this message translates to:
  /// **'Legalgoverninglaw'**
  String get legalGoverningLaw;

  /// No description provided for @legalGoverningLawContent.
  ///
  /// In en, this message translates to:
  /// **'Legalgoverninglawcontent'**
  String get legalGoverningLawContent;

  /// No description provided for @legalHowWeUse.
  ///
  /// In en, this message translates to:
  /// **'Legalhowweuse'**
  String get legalHowWeUse;

  /// No description provided for @legalHowWeUseContent.
  ///
  /// In en, this message translates to:
  /// **'Legalhowweusecontent'**
  String get legalHowWeUseContent;

  /// No description provided for @legalInfoWeCollect.
  ///
  /// In en, this message translates to:
  /// **'Legalinfowecollect'**
  String get legalInfoWeCollect;

  /// No description provided for @legalInfoWeCollectContent.
  ///
  /// In en, this message translates to:
  /// **'Legalinfowecollectcontent'**
  String get legalInfoWeCollectContent;

  /// No description provided for @legalIntellectualProperty.
  ///
  /// In en, this message translates to:
  /// **'Legalintellectualproperty'**
  String get legalIntellectualProperty;

  /// No description provided for @legalIntellectualPropertyContent.
  ///
  /// In en, this message translates to:
  /// **'Legalintellectualpropertycontent'**
  String get legalIntellectualPropertyContent;

  /// No description provided for @legalTermination.
  ///
  /// In en, this message translates to:
  /// **'Legaltermination'**
  String get legalTermination;

  /// No description provided for @legalTerminationContent.
  ///
  /// In en, this message translates to:
  /// **'Legalterminationcontent'**
  String get legalTerminationContent;

  /// No description provided for @legalThirdParty.
  ///
  /// In en, this message translates to:
  /// **'Legalthirdparty'**
  String get legalThirdParty;

  /// No description provided for @legalThirdPartyContent.
  ///
  /// In en, this message translates to:
  /// **'Legalthirdpartycontent'**
  String get legalThirdPartyContent;

  /// No description provided for @legalUseOfService.
  ///
  /// In en, this message translates to:
  /// **'Legaluseofservice'**
  String get legalUseOfService;

  /// No description provided for @legalUseOfServiceContent.
  ///
  /// In en, this message translates to:
  /// **'Legaluseofservicecontent'**
  String get legalUseOfServiceContent;

  /// No description provided for @legalUserAccounts.
  ///
  /// In en, this message translates to:
  /// **'Legaluseraccounts'**
  String get legalUserAccounts;

  /// No description provided for @legalUserAccountsContent.
  ///
  /// In en, this message translates to:
  /// **'Legaluseraccountscontent'**
  String get legalUserAccountsContent;

  /// No description provided for @legalYourRights.
  ///
  /// In en, this message translates to:
  /// **'Legalyourrights'**
  String get legalYourRights;

  /// No description provided for @legalYourRightsContent.
  ///
  /// In en, this message translates to:
  /// **'Legalyourrightscontent'**
  String get legalYourRightsContent;

  /// No description provided for @newContent.
  ///
  /// In en, this message translates to:
  /// **'Newcontent'**
  String get newContent;

  /// No description provided for @newContentDesc.
  ///
  /// In en, this message translates to:
  /// **'Newcontentdesc'**
  String get newContentDesc;

  /// No description provided for @nextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Nextquestion'**
  String get nextQuestion;

  /// No description provided for @noBookmarksFoundDesc.
  ///
  /// In en, this message translates to:
  /// **'Nobookmarksfounddesc'**
  String get noBookmarksFoundDesc;

  /// No description provided for @noBookmarksFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Nobookmarksfoundtitle'**
  String get noBookmarksFoundTitle;

  /// No description provided for @noFormulasLabel.
  ///
  /// In en, this message translates to:
  /// **'Noformulaslabel'**
  String get noFormulasLabel;

  /// No description provided for @noSubjectsAvailable.
  ///
  /// In en, this message translates to:
  /// **'Nosubjectsavailable'**
  String get noSubjectsAvailable;

  /// No description provided for @nothingHereYet.
  ///
  /// In en, this message translates to:
  /// **'Nothinghereyet'**
  String get nothingHereYet;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notificationsenabled'**
  String get notificationsEnabled;

  /// No description provided for @notificationsEnabledDesc.
  ///
  /// In en, this message translates to:
  /// **'Notificationsenableddesc'**
  String get notificationsEnabledDesc;

  /// No description provided for @onboardingAppBrand.
  ///
  /// In en, this message translates to:
  /// **'Onboardingappbrand'**
  String get onboardingAppBrand;

  /// No description provided for @onboardingBack.
  ///
  /// In en, this message translates to:
  /// **'Onboardingback'**
  String get onboardingBack;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Onboardingcontinue'**
  String get onboardingContinue;

  /// No description provided for @onboardingStepOf.
  ///
  /// In en, this message translates to:
  /// **'Onboardingstepof'**
  String get onboardingStepOf;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personalinfo'**
  String get personalInfo;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @practiceChooseSubject.
  ///
  /// In en, this message translates to:
  /// **'Practicechoosesubject'**
  String get practiceChooseSubject;

  /// No description provided for @practiceNoQuestionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Practicenoquestionsdesc'**
  String get practiceNoQuestionsDesc;

  /// No description provided for @practiceNoQuestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Practicenoquestionstitle'**
  String get practiceNoQuestionsTitle;

  /// No description provided for @practiceReadyDesc.
  ///
  /// In en, this message translates to:
  /// **'Practicereadydesc'**
  String get practiceReadyDesc;

  /// No description provided for @practiceReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Practicereadytitle'**
  String get practiceReadyTitle;

  /// No description provided for @privacyPolicyDesc.
  ///
  /// In en, this message translates to:
  /// **'Privacypolicydesc'**
  String get privacyPolicyDesc;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacypolicytitle'**
  String get privacyPolicyTitle;

  /// No description provided for @proTip.
  ///
  /// In en, this message translates to:
  /// **'Protip'**
  String get proTip;

  /// No description provided for @proTipContent.
  ///
  /// In en, this message translates to:
  /// **'Protipcontent'**
  String get proTipContent;

  /// No description provided for @profileAvatarUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Profileavatarurllabel'**
  String get profileAvatarUrlLabel;

  /// No description provided for @profileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Profilenamelabel'**
  String get profileNameLabel;

  /// No description provided for @profileNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Profilenamerequired'**
  String get profileNameRequired;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profileupdatedsuccess'**
  String get profileUpdatedSuccess;

  /// No description provided for @pushNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Pushnotificationsdesc'**
  String get pushNotificationsDesc;

  /// No description provided for @pushNotificationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Pushnotificationslabel'**
  String get pushNotificationsLabel;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quickactions'**
  String get quickActions;

  /// No description provided for @readyForMore.
  ///
  /// In en, this message translates to:
  /// **'Readyformore'**
  String get readyForMore;

  /// No description provided for @refreshBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Refreshbookmarks'**
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
  /// **'Savechanges'**
  String get saveChanges;

  /// No description provided for @searchBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Searchbookmarks'**
  String get searchBookmarks;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @step3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Step3subtitle'**
  String get step3Subtitle;

  /// No description provided for @step3Tag.
  ///
  /// In en, this message translates to:
  /// **'Step3tag'**
  String get step3Tag;

  /// No description provided for @step3Title.
  ///
  /// In en, this message translates to:
  /// **'Step3title'**
  String get step3Title;

  /// No description provided for @step4EnterSanctuary.
  ///
  /// In en, this message translates to:
  /// **'Step4entersanctuary'**
  String get step4EnterSanctuary;

  /// No description provided for @step4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Step4subtitle'**
  String get step4Subtitle;

  /// No description provided for @step4Tag.
  ///
  /// In en, this message translates to:
  /// **'Step4tag'**
  String get step4Tag;

  /// No description provided for @step4Title.
  ///
  /// In en, this message translates to:
  /// **'Step4title'**
  String get step4Title;

  /// No description provided for @streakAlerts.
  ///
  /// In en, this message translates to:
  /// **'Streakalerts'**
  String get streakAlerts;

  /// No description provided for @streakAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Streakalertsdesc'**
  String get streakAlertsDesc;

  /// No description provided for @studyAgain.
  ///
  /// In en, this message translates to:
  /// **'Studyagain'**
  String get studyAgain;

  /// No description provided for @studyNotifications.
  ///
  /// In en, this message translates to:
  /// **'Studynotifications'**
  String get studyNotifications;

  /// No description provided for @studyReminders.
  ///
  /// In en, this message translates to:
  /// **'Studyreminders'**
  String get studyReminders;

  /// No description provided for @studyRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Studyremindersdesc'**
  String get studyRemindersDesc;

  /// No description provided for @termsOfServiceDesc.
  ///
  /// In en, this message translates to:
  /// **'Termsofservicedesc'**
  String get termsOfServiceDesc;

  /// No description provided for @termsOfServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Termsofservicetitle'**
  String get termsOfServiceTitle;

  /// No description provided for @timedMode.
  ///
  /// In en, this message translates to:
  /// **'Timedmode'**
  String get timedMode;

  /// No description provided for @timedModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Timedmodedesc'**
  String get timedModeDesc;

  /// No description provided for @toggleDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Toggledarkmode'**
  String get toggleDarkMode;

  /// No description provided for @userGuide.
  ///
  /// In en, this message translates to:
  /// **'Userguide'**
  String get userGuide;

  /// No description provided for @userGuideDesc.
  ///
  /// In en, this message translates to:
  /// **'Userguidedesc'**
  String get userGuideDesc;

  /// No description provided for @verifiedAccount.
  ///
  /// In en, this message translates to:
  /// **'Verifiedaccount'**
  String get verifiedAccount;

  /// No description provided for @videoTutorials.
  ///
  /// In en, this message translates to:
  /// **'Videotutorials'**
  String get videoTutorials;

  /// No description provided for @videoTutorialsDesc.
  ///
  /// In en, this message translates to:
  /// **'Videotutorialsdesc'**
  String get videoTutorialsDesc;

  /// No description provided for @viewTopics.
  ///
  /// In en, this message translates to:
  /// **'Viewtopics'**
  String get viewTopics;

  /// No description provided for @weeklyReport.
  ///
  /// In en, this message translates to:
  /// **'Weeklyreport'**
  String get weeklyReport;

  /// No description provided for @weeklyReportDesc.
  ///
  /// In en, this message translates to:
  /// **'Weeklyreportdesc'**
  String get weeklyReportDesc;

  /// No description provided for @dart.
  ///
  /// In en, this message translates to:
  /// **'Dart'**
  String get dart;

  /// No description provided for @dashboardSanctuary.
  ///
  /// In en, this message translates to:
  /// **'Dashboardsanctuary'**
  String get dashboardSanctuary;

  /// No description provided for @forgotPasswordCancel.
  ///
  /// In en, this message translates to:
  /// **'Forgotpasswordcancel'**
  String get forgotPasswordCancel;

  /// No description provided for @forgotPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Forgotpassworddesc'**
  String get forgotPasswordDesc;

  /// No description provided for @forgotPasswordSend.
  ///
  /// In en, this message translates to:
  /// **'Forgotpasswordsend'**
  String get forgotPasswordSend;

  /// No description provided for @forgotPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Forgotpasswordsuccess'**
  String get forgotPasswordSuccess;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgotpasswordtitle'**
  String get forgotPasswordTitle;

  /// No description provided for @signupBrandDesc.
  ///
  /// In en, this message translates to:
  /// **'Signupbranddesc'**
  String get signupBrandDesc;

  /// No description provided for @signupBrandHeadline.
  ///
  /// In en, this message translates to:
  /// **'Signupbrandheadline'**
  String get signupBrandHeadline;

  /// No description provided for @signupBrandTitle.
  ///
  /// In en, this message translates to:
  /// **'Signupbrandtitle'**
  String get signupBrandTitle;

  /// No description provided for @signupTestimonial.
  ///
  /// In en, this message translates to:
  /// **'Signuptestimonial'**
  String get signupTestimonial;

  /// No description provided for @signupTestimonialName.
  ///
  /// In en, this message translates to:
  /// **'Signuptestimonialname'**
  String get signupTestimonialName;

  /// No description provided for @signupTestimonialRole.
  ///
  /// In en, this message translates to:
  /// **'Signuptestimonialrole'**
  String get signupTestimonialRole;

  /// No description provided for @step4Casual.
  ///
  /// In en, this message translates to:
  /// **'Step4casual'**
  String get step4Casual;

  /// No description provided for @step4CasualDesc.
  ///
  /// In en, this message translates to:
  /// **'Step4casualdesc'**
  String get step4CasualDesc;

  /// No description provided for @step4Intensive.
  ///
  /// In en, this message translates to:
  /// **'Step4intensive'**
  String get step4Intensive;

  /// No description provided for @step4IntensiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Step4intensivedesc'**
  String get step4IntensiveDesc;

  /// No description provided for @step4Regular.
  ///
  /// In en, this message translates to:
  /// **'Step4regular'**
  String get step4Regular;

  /// No description provided for @step4RegularDesc.
  ///
  /// In en, this message translates to:
  /// **'Step4regulardesc'**
  String get step4RegularDesc;

  /// No description provided for @validationInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Validationinvalidemail'**
  String get validationInvalidEmail;

  /// No description provided for @validationPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Validationpasswordminlength'**
  String get validationPasswordMinLength;

  /// No description provided for @validationPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Validationpasswordmismatch'**
  String get validationPasswordMismatch;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'Validationrequired'**
  String get validationRequired;
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
