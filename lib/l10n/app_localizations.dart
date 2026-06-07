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
  /// **'Continue your journey through Physics. You\'re 65% through the current chapter.'**
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
  /// **'Formula Vault'**
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
  /// **'Master every\\nformula with\\nease.'**
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
  /// **'Correct!'**
  String get correct;

  /// No description provided for @masteryLevelIncreasing.
  ///
  /// In en, this message translates to:
  /// **'Mastery level increasing'**
  String get masteryLevelIncreasing;

  /// No description provided for @wrongAnswer.
  ///
  /// In en, this message translates to:
  /// **'Incorrect'**
  String get wrongAnswer;

  /// No description provided for @tryNextTime.
  ///
  /// In en, this message translates to:
  /// **'Review and try again next time'**
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
  /// **'Unable to load boards and classes right now.'**
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

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @supportAndAbout.
  ///
  /// In en, this message translates to:
  /// **'Support & About'**
  String get supportAndAbout;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

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
  /// **'Select your board and grade to unlock your dashboard.'**
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
  /// **'Got It'**
  String get gotIt;

  /// No description provided for @legalFooterTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Privacy & Security Matter to Us'**
  String get legalFooterTitle;

  /// No description provided for @legalFooterDesc.
  ///
  /// In en, this message translates to:
  /// **'We are committed to protecting your personal information and providing a safe learning environment.'**
  String get legalFooterDesc;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Milestone Alerts'**
  String get achievements;

  /// No description provided for @achievementsDesc.
  ///
  /// In en, this message translates to:
  /// **'When you hit learning milestones'**
  String get achievementsDesc;

  /// No description provided for @legalEffectiveDate.
  ///
  /// In en, this message translates to:
  /// **'Effective: April 2026'**
  String get legalEffectiveDate;

  /// No description provided for @selectSubjectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a Subject'**
  String get selectSubjectTitle;

  /// No description provided for @selectSubjectDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap on a subject from the Home tab to start exploring chapters and formulas.'**
  String get selectSubjectDesc;

  /// No description provided for @selectSubjectFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a subject first'**
  String get selectSubjectFirst;

  /// No description provided for @breadcrumbHome.
  ///
  /// In en, this message translates to:
  /// **'HOME'**
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
  /// **'Search chapters...'**
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
  /// **'Remove from Vault'**
  String get removeBookmark;

  /// No description provided for @bookmarkChapter.
  ///
  /// In en, this message translates to:
  /// **'Add to Vault'**
  String get bookmarkChapter;

  /// No description provided for @removeSavedChapter.
  ///
  /// In en, this message translates to:
  /// **'Remove from Vault'**
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
  /// **'Nearly there!'**
  String get nearlyThere;

  /// No description provided for @keepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep Going'**
  String get keepGoing;

  /// No description provided for @justStarted.
  ///
  /// In en, this message translates to:
  /// **'Just getting started'**
  String get justStarted;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'LOCKED'**
  String get locked;

  /// No description provided for @step1StateHint.
  ///
  /// In en, this message translates to:
  /// **'Search state (e.g. Maharashtra)'**
  String get step1StateHint;

  /// No description provided for @step1LocalizedTitle.
  ///
  /// In en, this message translates to:
  /// **'Localized Content'**
  String get step1LocalizedTitle;

  /// No description provided for @step1LocalizedDesc.
  ///
  /// In en, this message translates to:
  /// **'We automatically sync with CBSE, ICSE, and various State Board syllabi based on your choice.'**
  String get step1LocalizedDesc;

  /// No description provided for @step1PrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Guaranteed'**
  String get step1PrivacyTitle;

  /// No description provided for @step1PrivacyDesc.
  ///
  /// In en, this message translates to:
  /// **'Your location is only used to personalize your curriculum roadmap.'**
  String get step1PrivacyDesc;

  /// No description provided for @step2Tag.
  ///
  /// In en, this message translates to:
  /// **'Curriculum Selection'**
  String get step2Tag;

  /// No description provided for @step2Title.
  ///
  /// In en, this message translates to:
  /// **'Select Your Curriculum'**
  String get step2Title;

  /// No description provided for @step2NotSureTitle.
  ///
  /// In en, this message translates to:
  /// **'Not sure about your board?'**
  String get step2NotSureTitle;

  /// No description provided for @step2NotSureDesc.
  ///
  /// In en, this message translates to:
  /// **'Check your school ID card or textbook covers for the official board affiliation.'**
  String get step2NotSureDesc;

  /// No description provided for @step2LearnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get step2LearnMore;

  /// No description provided for @step1Continue.
  ///
  /// In en, this message translates to:
  /// **'Continue to Step 2'**
  String get step1Continue;

  /// No description provided for @step1Tag.
  ///
  /// In en, this message translates to:
  /// **'Location Preference'**
  String get step1Tag;

  /// No description provided for @step1Title.
  ///
  /// In en, this message translates to:
  /// **'Where are you studying?'**
  String get step1Title;

  /// No description provided for @step1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll tailor your formulas and curriculum based on your region\'s educational standards.'**
  String get step1Subtitle;

  /// No description provided for @flashcardFlip.
  ///
  /// In en, this message translates to:
  /// **'Tap to flip'**
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
  /// **'Version 1.0.0 (Beta)'**
  String get appVersion;

  /// No description provided for @madeWithLove.
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ for scholars'**
  String get madeWithLove;

  /// No description provided for @deleteAccountFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account'**
  String get deleteAccountFailed;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
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
  /// **'Delete Permanently'**
  String get deleteAccountButton;

  /// No description provided for @dashboardLive.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get dashboardLive;

  /// No description provided for @startQuiz.
  ///
  /// In en, this message translates to:
  /// **'Start Quiz'**
  String get startQuiz;

  /// No description provided for @welcomeScholar.
  ///
  /// In en, this message translates to:
  /// **'Welcome, Scholar'**
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
  /// **'No chapters available yet'**
  String get chaptersNoContentTitle;

  /// No description provided for @chaptersNoContentDescription.
  ///
  /// In en, this message translates to:
  /// **'This subject has not been populated with chapters yet. Try another subject or check back after the backend sync finishes.'**
  String get chaptersNoContentDescription;

  /// No description provided for @chaptersBrowseSubjects.
  ///
  /// In en, this message translates to:
  /// **'Browse Subjects'**
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
  /// **'QUESTION'**
  String get practiceQuestionLabel;

  /// No description provided for @ofLabel.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofLabel;

  /// No description provided for @quizCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiz Complete!'**
  String get quizCompleteTitle;

  /// No description provided for @quizCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'Great effort! Review your results below.'**
  String get quizCompleteDesc;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// No description provided for @retryIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Retry Incorrect'**
  String get retryIncorrect;

  /// No description provided for @backToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Back to Dashboard'**
  String get backToDashboard;

  /// No description provided for @savedChapters.
  ///
  /// In en, this message translates to:
  /// **'Vaulted Chapters'**
  String get savedChapters;

  /// No description provided for @savedFormulas.
  ///
  /// In en, this message translates to:
  /// **'Vaulted Formulas'**
  String get savedFormulas;

  /// No description provided for @savedNotes.
  ///
  /// In en, this message translates to:
  /// **'Vaulted Notes'**
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
  /// **'Write your note here...'**
  String get noteHint;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// No description provided for @unknownCurriculum.
  ///
  /// In en, this message translates to:
  /// **'unknown_curriculum'**
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
  /// **'Mastery tools are syncing from backend. Please try again in a moment.'**
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
  /// **'Academic Information'**
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
  /// **'Achievements'**
  String get achievementNotifications;

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

  /// No description provided for @chatWithUs.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
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
  /// **'Test your knowledge with 5 quick formulas.'**
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
  /// **'Academic Path'**
  String get dashboardAcademicPath;

  /// No description provided for @dashboardAvailableBoards.
  ///
  /// In en, this message translates to:
  /// **'Boards for your region'**
  String get dashboardAvailableBoards;

  /// No description provided for @dashboardNoBoardsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No boards available for your region.'**
  String get dashboardNoBoardsAvailable;

  /// No description provided for @dashboardAvailableClasses.
  ///
  /// In en, this message translates to:
  /// **'Classes for selected board'**
  String get dashboardAvailableClasses;

  /// No description provided for @dashboardNoClassesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No classes available for this board.'**
  String get dashboardNoClassesAvailable;

  /// No description provided for @dashboardActiveCurriculum.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE CURRICULUM'**
  String get dashboardActiveCurriculum;

  /// No description provided for @dashboardCurriculumPending.
  ///
  /// In en, this message translates to:
  /// **'Syncing your board and grade...'**
  String get dashboardCurriculumPending;

  /// No description provided for @dashboardFormulaVault.
  ///
  /// In en, this message translates to:
  /// **'My Formula Vault'**
  String get dashboardFormulaVault;

  /// No description provided for @dashboardRetryCurriculumOptions.
  ///
  /// In en, this message translates to:
  /// **'Retry board/class options'**
  String get dashboardRetryCurriculumOptions;

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
  /// **'Update your display name and avatar from one place.'**
  String get editProfileSubtitle;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @emailNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive updates via email'**
  String get emailNotificationsDesc;

  /// No description provided for @emailNotificationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotificationsLabel;

  /// No description provided for @emailUs.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailUs;

  /// No description provided for @emptyBookmarksDesc.
  ///
  /// In en, this message translates to:
  /// **'Your vault is empty. Start adding formulas to quickly access them here.'**
  String get emptyBookmarksDesc;

  /// No description provided for @encouragementMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'re in the top 5% of 9th graders this week. Keep flowing!'**
  String get encouragementMessage;

  /// No description provided for @exploreTools.
  ///
  /// In en, this message translates to:
  /// **'Explore Tools'**
  String get exploreTools;

  /// No description provided for @faq1Answer.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile → Account Information to update your grade. Your curriculum will automatically adjust to match.'**
  String get faq1Answer;

  /// No description provided for @faq1Question.
  ///
  /// In en, this message translates to:
  /// **'How do I change my grade?'**
  String get faq1Question;

  /// No description provided for @faq2Answer.
  ///
  /// In en, this message translates to:
  /// **'Yes! Previously viewed formulas and chapters are cached for offline access. Bookmarks are always available offline.'**
  String get faq2Answer;

  /// No description provided for @faq2Question.
  ///
  /// In en, this message translates to:
  /// **'Can I use the app offline?'**
  String get faq2Question;

  /// No description provided for @faq3Answer.
  ///
  /// In en, this message translates to:
  /// **'Your streak counts consecutive days with at least 5 minutes of study time. The counter resets at midnight local time.'**
  String get faq3Answer;

  /// No description provided for @faq3Question.
  ///
  /// In en, this message translates to:
  /// **'How are streaks calculated?'**
  String get faq3Question;

  /// No description provided for @faq4Answer.
  ///
  /// In en, this message translates to:
  /// **'Pro unlocks advanced features like 3D visualizers, unlimited practice quizzes, and priority access to new content.'**
  String get faq4Answer;

  /// No description provided for @faq4Question.
  ///
  /// In en, this message translates to:
  /// **'What is Formula Scholar Pro?'**
  String get faq4Question;

  /// No description provided for @faqLabel.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faqLabel;

  /// No description provided for @featuredAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Featured Announcements'**
  String get featuredAnnouncements;

  /// No description provided for @flashcardSessionComplete.
  ///
  /// In en, this message translates to:
  /// **'Session Complete!'**
  String get flashcardSessionComplete;

  /// No description provided for @flashcardSessionDesc.
  ///
  /// In en, this message translates to:
  /// **'Great work! Keep practicing to master all formulas.'**
  String get flashcardSessionDesc;

  /// No description provided for @flashcardStudy.
  ///
  /// In en, this message translates to:
  /// **'Study Mode'**
  String get flashcardStudy;

  /// No description provided for @formulaFlow.
  ///
  /// In en, this message translates to:
  /// **'FormulaFlow'**
  String get formulaFlow;

  /// No description provided for @freeAccount.
  ///
  /// In en, this message translates to:
  /// **'Free'**
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
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @helpHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse FAQs or contact our support team.'**
  String get helpHeroSubtitle;

  /// No description provided for @helpHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'How can we help?'**
  String get helpHeroTitle;

  /// No description provided for @incorrectLabel.
  ///
  /// In en, this message translates to:
  /// **'Incorrect'**
  String get incorrectLabel;

  /// No description provided for @legalAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Acceptance of Terms'**
  String get legalAcceptance;

  /// No description provided for @legalAcceptanceContent.
  ///
  /// In en, this message translates to:
  /// **'By creating an account or using Formula Scholar, you agree to these Terms of Service. If you do not agree, please do not use the service. We may update these terms and will notify you of significant changes.'**
  String get legalAcceptanceContent;

  /// No description provided for @legalChanges.
  ///
  /// In en, this message translates to:
  /// **'Changes to This Policy'**
  String get legalChanges;

  /// No description provided for @legalChangesContent.
  ///
  /// In en, this message translates to:
  /// **'We may update this Privacy Policy from time to time. We will notify you of any material changes through the app and update the effective date. Your continued use of Formula Scholar after changes indicates acceptance of the updated policy.'**
  String get legalChangesContent;

  /// No description provided for @legalChildrenPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Children\'s Privacy'**
  String get legalChildrenPrivacy;

  /// No description provided for @legalChildrenPrivacyContent.
  ///
  /// In en, this message translates to:
  /// **'Formula Scholar is designed for students of all ages. For users under 13, we collect only the minimum information necessary for the service. We do not knowingly collect sensitive personal information from children. Parents may contact us to review or delete their child\'s data.'**
  String get legalChildrenPrivacyContent;

  /// No description provided for @legalContact.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get legalContact;

  /// No description provided for @legalContactContent.
  ///
  /// In en, this message translates to:
  /// **'If you have questions about this Privacy Policy or your data, please contact us through the Help & Support section in the app, or email us at support@formulascholar.app.'**
  String get legalContactContent;

  /// No description provided for @legalDataStorage.
  ///
  /// In en, this message translates to:
  /// **'Data Storage & Security'**
  String get legalDataStorage;

  /// No description provided for @legalDataStorageContent.
  ///
  /// In en, this message translates to:
  /// **'Your data is stored securely on Google Firebase servers with encryption at rest and in transit. We use industry-standard security measures to protect your personal information. You can request data export or deletion at any time through the app settings.'**
  String get legalDataStorageContent;

  /// No description provided for @legalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get legalDisclaimer;

  /// No description provided for @legalDisclaimerContent.
  ///
  /// In en, this message translates to:
  /// **'Formula Scholar is an educational aid and should supplement, not replace, formal education. We strive for accuracy but do not guarantee that all content is error-free. We are not liable for academic outcomes based on use of this application.'**
  String get legalDisclaimerContent;

  /// No description provided for @legalGoverningLaw.
  ///
  /// In en, this message translates to:
  /// **'Governing Law'**
  String get legalGoverningLaw;

  /// No description provided for @legalGoverningLawContent.
  ///
  /// In en, this message translates to:
  /// **'These Terms of Service are governed by applicable law. Any disputes arising from these terms will be resolved through appropriate legal channels in the jurisdiction where the service provider is located.'**
  String get legalGoverningLawContent;

  /// No description provided for @legalHowWeUse.
  ///
  /// In en, this message translates to:
  /// **'How We Use Your Information'**
  String get legalHowWeUse;

  /// No description provided for @legalHowWeUseContent.
  ///
  /// In en, this message translates to:
  /// **'Your information is used to: personalize your learning dashboard, track your study progress and mastery levels, recommend relevant formulas and chapters, send study reminders (with your consent), and improve our educational content and features.'**
  String get legalHowWeUseContent;

  /// No description provided for @legalInfoWeCollect.
  ///
  /// In en, this message translates to:
  /// **'Information We Collect'**
  String get legalInfoWeCollect;

  /// No description provided for @legalInfoWeCollectContent.
  ///
  /// In en, this message translates to:
  /// **'We collect information you provide directly, such as your name, email address, and academic preferences (board, grade, subjects) when you create an account. We also collect usage data including formulas viewed, quiz scores, and study progress to personalize your experience.'**
  String get legalInfoWeCollectContent;

  /// No description provided for @legalIntellectualProperty.
  ///
  /// In en, this message translates to:
  /// **'Intellectual Property'**
  String get legalIntellectualProperty;

  /// No description provided for @legalIntellectualPropertyContent.
  ///
  /// In en, this message translates to:
  /// **'All content, design, and code within Formula Scholar are protected by intellectual property laws. Educational formulas themselves are in the public domain, but our presentation, explanations, and quiz content are proprietary. You may not reproduce or distribute our content without permission.'**
  String get legalIntellectualPropertyContent;

  /// No description provided for @legalTermination.
  ///
  /// In en, this message translates to:
  /// **'Termination'**
  String get legalTermination;

  /// No description provided for @legalTerminationContent.
  ///
  /// In en, this message translates to:
  /// **'We may suspend or terminate your access if you violate these terms. You may terminate your account at any time. Upon termination, your right to use the service ceases and your data will be deleted per our retention policy.'**
  String get legalTerminationContent;

  /// No description provided for @legalThirdParty.
  ///
  /// In en, this message translates to:
  /// **'Third-Party Services'**
  String get legalThirdParty;

  /// No description provided for @legalThirdPartyContent.
  ///
  /// In en, this message translates to:
  /// **'We use the following third-party services: Firebase (authentication and data storage by Google), Google Sign-In (optional account linking). These services have their own privacy policies which we encourage you to review.'**
  String get legalThirdPartyContent;

  /// No description provided for @legalUseOfService.
  ///
  /// In en, this message translates to:
  /// **'Use of Service'**
  String get legalUseOfService;

  /// No description provided for @legalUseOfServiceContent.
  ///
  /// In en, this message translates to:
  /// **'Formula Scholar provides educational tools for learning mathematical and scientific formulas. The service is provided \"as is\" for personal, non-commercial educational use. You agree not to: share your account credentials, use the service for unauthorized purposes, or attempt to reverse-engineer any part of the application.'**
  String get legalUseOfServiceContent;

  /// No description provided for @legalUserAccounts.
  ///
  /// In en, this message translates to:
  /// **'User Accounts'**
  String get legalUserAccounts;

  /// No description provided for @legalUserAccountsContent.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for maintaining the security of your account and password. You must provide accurate information during registration. You may delete your account at any time, which will permanently remove your data from our systems.'**
  String get legalUserAccountsContent;

  /// No description provided for @legalYourRights.
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get legalYourRights;

  /// No description provided for @legalYourRightsContent.
  ///
  /// In en, this message translates to:
  /// **'You have the right to: access your personal data, correct inaccurate data, request deletion of your account and data, export your data in a portable format, and opt out of non-essential communications. To exercise these rights, contact us through the Help & Support section.'**
  String get legalYourRightsContent;

  /// No description provided for @newContent.
  ///
  /// In en, this message translates to:
  /// **'New Content'**
  String get newContent;

  /// No description provided for @newContentDesc.
  ///
  /// In en, this message translates to:
  /// **'When new chapters are available'**
  String get newContentDesc;

  /// No description provided for @nextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next Question'**
  String get nextQuestion;

  /// No description provided for @noBookmarksFoundDesc.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term or clear the filter to see all vaulted formulas and chapters.'**
  String get noBookmarksFoundDesc;

  /// No description provided for @noBookmarksFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'No items in vault'**
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
  /// **'Nothing here yet'**
  String get nothingHereYet;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications Active'**
  String get notificationsEnabled;

  /// No description provided for @notificationsEnabledDesc.
  ///
  /// In en, this message translates to:
  /// **'Notifications Enabled Desc'**
  String get notificationsEnabledDesc;

  /// No description provided for @onboardingAppBrand.
  ///
  /// In en, this message translates to:
  /// **'Formula Sanctuary'**
  String get onboardingAppBrand;

  /// No description provided for @onboardingBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboardingBack;

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
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
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @practiceChooseSubject.
  ///
  /// In en, this message translates to:
  /// **'Choose Subject'**
  String get practiceChooseSubject;

  /// No description provided for @practiceNoQuestionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Your current curriculum does not have practice questions available yet. Try again soon or open Chapters to keep learning.'**
  String get practiceNoQuestionsDesc;

  /// No description provided for @practiceNoQuestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'No practice questions yet'**
  String get practiceNoQuestionsTitle;

  /// No description provided for @practiceReadyDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose a subject and test your knowledge with practice questions.'**
  String get practiceReadyDesc;

  /// No description provided for @practiceReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to Practice?'**
  String get practiceReadyTitle;

  /// No description provided for @privacyPolicyDesc.
  ///
  /// In en, this message translates to:
  /// **'How we protect your data'**
  String get privacyPolicyDesc;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
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
  /// **'Avatar URL'**
  String get profileAvatarUrlLabel;

  /// No description provided for @profileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get profileNameLabel;

  /// No description provided for @profileNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Display name is required'**
  String get profileNameRequired;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully.'**
  String get profileUpdatedSuccess;

  /// No description provided for @pushNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Receive alerts on your device'**
  String get pushNotificationsDesc;

  /// No description provided for @pushNotificationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotificationsLabel;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @readyForMore.
  ///
  /// In en, this message translates to:
  /// **'Ready for more?'**
  String get readyForMore;

  /// No description provided for @refreshBookmarks.
  ///
  /// In en, this message translates to:
  /// **'Refresh Vault'**
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
  /// **'Search Vault'**
  String get searchBookmarks;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @step3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your academic year to tailor formulas and practice sets to your curriculum.'**
  String get step3Subtitle;

  /// No description provided for @step3Tag.
  ///
  /// In en, this message translates to:
  /// **'Grade Selection'**
  String get step3Tag;

  /// No description provided for @step3Title.
  ///
  /// In en, this message translates to:
  /// **'Select Your Class'**
  String get step3Title;

  /// No description provided for @step4EnterSanctuary.
  ///
  /// In en, this message translates to:
  /// **'Enter Sanctuary'**
  String get step4EnterSanctuary;

  /// No description provided for @step4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Consistency is the key to mastery. How much time can you dedicate?'**
  String get step4Subtitle;

  /// No description provided for @step4Tag.
  ///
  /// In en, this message translates to:
  /// **'Commitment'**
  String get step4Tag;

  /// No description provided for @step4Title.
  ///
  /// In en, this message translates to:
  /// **'Set your weekly goal'**
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
  /// **'Daily reminders to keep learning'**
  String get studyRemindersDesc;

  /// No description provided for @termsOfServiceDesc.
  ///
  /// In en, this message translates to:
  /// **'Rules and guidelines for app usage'**
  String get termsOfServiceDesc;

  /// No description provided for @termsOfServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfServiceTitle;

  /// No description provided for @timedMode.
  ///
  /// In en, this message translates to:
  /// **'Timed Mode'**
  String get timedMode;

  /// No description provided for @timedModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Set a time limit for this quiz'**
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
  /// **'Learn how to use Formula Scholar'**
  String get userGuideDesc;

  /// No description provided for @verifiedAccount.
  ///
  /// In en, this message translates to:
  /// **'VERIFIED'**
  String get verifiedAccount;

  /// No description provided for @videoTutorials.
  ///
  /// In en, this message translates to:
  /// **'Video Tutorials'**
  String get videoTutorials;

  /// No description provided for @videoTutorialsDesc.
  ///
  /// In en, this message translates to:
  /// **'Watch step-by-step guides'**
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
  /// **'Summary of your weekly progress'**
  String get weeklyReportDesc;

  /// No description provided for @dart.
  ///
  /// In en, this message translates to:
  /// **'Dart'**
  String get dart;

  /// No description provided for @dashboardSanctuary.
  ///
  /// In en, this message translates to:
  /// **'Formula Sanctuary'**
  String get dashboardSanctuary;

  /// No description provided for @forgotPasswordCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get forgotPasswordCancel;

  /// No description provided for @forgotPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get forgotPasswordDesc;

  /// No description provided for @forgotPasswordSend.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get forgotPasswordSend;

  /// No description provided for @forgotPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent! Check your email inbox.'**
  String get forgotPasswordSuccess;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get forgotPasswordTitle;

  /// No description provided for @signupBrandDesc.
  ///
  /// In en, this message translates to:
  /// **'Join a sanctuary designed for focused learning. Transform complex equations into intuitive steps.'**
  String get signupBrandDesc;

  /// No description provided for @signupBrandHeadline.
  ///
  /// In en, this message translates to:
  /// **'Master the Flow of Knowledge.'**
  String get signupBrandHeadline;

  /// No description provided for @signupBrandTitle.
  ///
  /// In en, this message translates to:
  /// **'Formula Sanctuary'**
  String get signupBrandTitle;

  /// No description provided for @signupTestimonial.
  ///
  /// In en, this message translates to:
  /// **'\"The formulas finally make sense. It doesn\'t feel like studying; it feels like exploring.\"'**
  String get signupTestimonial;

  /// No description provided for @signupTestimonialName.
  ///
  /// In en, this message translates to:
  /// **'Ishita Sharma'**
  String get signupTestimonialName;

  /// No description provided for @signupTestimonialRole.
  ///
  /// In en, this message translates to:
  /// **'Class 9 Student'**
  String get signupTestimonialRole;

  /// No description provided for @step4Casual.
  ///
  /// In en, this message translates to:
  /// **'Casual Learner'**
  String get step4Casual;

  /// No description provided for @step4CasualDesc.
  ///
  /// In en, this message translates to:
  /// **'15 mins / day'**
  String get step4CasualDesc;

  /// No description provided for @step4Intensive.
  ///
  /// In en, this message translates to:
  /// **'Intensive Mastery'**
  String get step4Intensive;

  /// No description provided for @step4IntensiveDesc.
  ///
  /// In en, this message translates to:
  /// **'60+ mins / day'**
  String get step4IntensiveDesc;

  /// No description provided for @step4Regular.
  ///
  /// In en, this message translates to:
  /// **'Regular Scholar'**
  String get step4Regular;

  /// No description provided for @step4RegularDesc.
  ///
  /// In en, this message translates to:
  /// **'30 mins / day'**
  String get step4RegularDesc;

  /// No description provided for @validationInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validationInvalidEmail;

  /// No description provided for @validationPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get validationPasswordMinLength;

  /// No description provided for @validationPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordMismatch;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
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
  /// **'My Formula Vault'**
  String get myBookmarks;

  /// No description provided for @studyPlannerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Plan and track your study sessions'**
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

  /// No description provided for @onboardingNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'Need Help?'**
  String get onboardingNeedHelp;

  /// No description provided for @onboardingBoardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personalize your journey by selecting your academic board. We\'ll tailor your formulas and practice sets to your specific curriculum.'**
  String get onboardingBoardSubtitle;

  /// No description provided for @onboardingSelectBoard.
  ///
  /// In en, this message translates to:
  /// **'Select Board'**
  String get onboardingSelectBoard;

  /// No description provided for @onboardingBoardChangeHint.
  ///
  /// In en, this message translates to:
  /// **'Selected board can be changed later in Profile.'**
  String get onboardingBoardChangeHint;

  /// No description provided for @onboardingBoardSelected.
  ///
  /// In en, this message translates to:
  /// **'BOARD SELECTED'**
  String get onboardingBoardSelected;

  /// No description provided for @onboardingJourneyProgress.
  ///
  /// In en, this message translates to:
  /// **'Journey Progress'**
  String get onboardingJourneyProgress;

  /// No description provided for @onboardingGradeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll customize your FormulaFlow experience based on your current curriculum.'**
  String get onboardingGradeSubtitle;

  /// No description provided for @onboardingMostPopular.
  ///
  /// In en, this message translates to:
  /// **'MOST POPULAR'**
  String get onboardingMostPopular;

  /// No description provided for @onboardingGradeChangeHint.
  ///
  /// In en, this message translates to:
  /// **'You can always change your grade in Profile settings later.'**
  String get onboardingGradeChangeHint;

  /// No description provided for @circlesAndAreas.
  ///
  /// In en, this message translates to:
  /// **'Circles & Areas'**
  String get circlesAndAreas;

  /// No description provided for @geometryBasics.
  ///
  /// In en, this message translates to:
  /// **'GEOMETRY BASICS'**
  String get geometryBasics;

  /// No description provided for @areaOfCircleQuestion.
  ///
  /// In en, this message translates to:
  /// **'Which of the following formulas correctly represents the area of a circle with radius r?'**
  String get areaOfCircleQuestion;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @doneLabel.
  ///
  /// In en, this message translates to:
  /// **'{percent}% done'**
  String doneLabel(Object percent);

  /// No description provided for @formulasCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} formulas'**
  String formulasCountLabel(Object completed, Object total);

  /// No description provided for @sortNameAZ.
  ///
  /// In en, this message translates to:
  /// **'Name A-Z'**
  String get sortNameAZ;

  /// No description provided for @sortNameZA.
  ///
  /// In en, this message translates to:
  /// **'Name Z-A'**
  String get sortNameZA;

  /// No description provided for @sortProgressHigh.
  ///
  /// In en, this message translates to:
  /// **'Progress High'**
  String get sortProgressHigh;

  /// No description provided for @sortProgressLow.
  ///
  /// In en, this message translates to:
  /// **'Progress Low'**
  String get sortProgressLow;

  /// No description provided for @sortMostFormulas.
  ///
  /// In en, this message translates to:
  /// **'Most Formulas'**
  String get sortMostFormulas;

  /// No description provided for @sortFewestFormulas.
  ///
  /// In en, this message translates to:
  /// **'Fewest Formulas'**
  String get sortFewestFormulas;

  /// No description provided for @vaultStatsFormulas.
  ///
  /// In en, this message translates to:
  /// **'Formulas'**
  String get vaultStatsFormulas;

  /// No description provided for @vaultStatsChapters.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get vaultStatsChapters;

  /// No description provided for @vaultStatsNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get vaultStatsNotes;

  /// No description provided for @vaultStatsSubjects.
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get vaultStatsSubjects;

  /// No description provided for @vaultFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get vaultFilterAll;

  /// No description provided for @quickRevisionTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Revision'**
  String get quickRevisionTitle;

  /// No description provided for @quickRevisionEmpty.
  ///
  /// In en, this message translates to:
  /// **'Vault some formulas first to start a quick revision session.'**
  String get quickRevisionEmpty;

  /// No description provided for @quickRevisionProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String quickRevisionProgress(int current, int total);

  /// No description provided for @shareVault.
  ///
  /// In en, this message translates to:
  /// **'Share Vault'**
  String get shareVault;

  /// No description provided for @vaultCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Vault summary copied to clipboard!'**
  String get vaultCopiedToClipboard;

  /// No description provided for @vaultSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'My Formula Vault'**
  String get vaultSummaryTitle;

  /// No description provided for @vaultedOn.
  ///
  /// In en, this message translates to:
  /// **'VAULTED'**
  String get vaultedOn;

  /// No description provided for @undoLabel.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undoLabel;

  /// No description provided for @formulaRemovedFromVault.
  ///
  /// In en, this message translates to:
  /// **'Formula removed from vault'**
  String get formulaRemovedFromVault;

  /// No description provided for @chapterRemovedFromVault.
  ///
  /// In en, this message translates to:
  /// **'Chapter removed from vault'**
  String get chapterRemovedFromVault;

  /// No description provided for @noteRemovedFromVault.
  ///
  /// In en, this message translates to:
  /// **'Note removed from vault'**
  String get noteRemovedFromVault;

  /// No description provided for @swipeToRemoveHint.
  ///
  /// In en, this message translates to:
  /// **'Swipe left to remove'**
  String get swipeToRemoveHint;
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
