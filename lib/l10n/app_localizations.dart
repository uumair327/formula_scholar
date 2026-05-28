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

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **"Enter your email address and we'll send you a link to reset your password."**
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

  /// No description provided for @forgotPasswordCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get forgotPasswordCancel;

  /// No description provided for @signupBrandTitle.
  ///
  /// In en, this message translates to:
  /// **'Formula Sanctuary'**
  String get signupBrandTitle;

  /// No description provided for @signupBrandHeadline.
  ///
  /// In en, this message translates to:
  /// **'Master the Flow of Knowledge.'**
  String get signupBrandHeadline;

  /// No description provided for @signupBrandDesc.
  ///
  /// In en, this message translates to:
  /// **'Join a sanctuary designed for focused learning. Transform complex equations into intuitive steps.'**
  String get signupBrandDesc;

  /// No description provided for @signupTestimonial.
  ///
  /// In en, this message translates to:
  /// **'"The formulas finally make sense. It doesn\'t feel like studying; it feels like exploring."'**
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
