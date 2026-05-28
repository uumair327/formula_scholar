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
  String get forgotPasswordTitle => 'पासवर्ड रीसेट करा';

  @override
  String get forgotPasswordDesc =>
      'तुमचा ईमेल पत्ता टाका आणि आम्ही पासवर्ड रीसेट करण्यासाठी एक दुवा पाठवू.';

  @override
  String get forgotPasswordSend => 'रीसेट लिंक पाठवा';

  @override
  String get forgotPasswordSuccess =>
      'पासवर्ड रीसेट लिंक पाठवली आहे! तुमचा इनबॉक्स तपासा.';

  @override
  String get forgotPasswordCancel => 'रद्द करा';

  @override
  String get signupBrandTitle => 'फॉर्म्युला सँक्च्युरी';

  @override
  String get signupBrandHeadline => 'ज्ञानाच्या प्रवाहावर प्रभुत्व मिळवा.';

  @override
  String get signupBrandDesc =>
      'एकाग्र शिक्षणासाठी डिझाइन केलेल्या आश्रयस्थानात सामील व्हा. गुंतागुंतीच्या समीकरणांना सहज समजणाऱ्या पायऱ्यांमध्ये बदला.';

  @override
  String get signupTestimonial =>
      '"सूत्रे शेवटी समजू लागली आहेत. हे अभ्यासासारखे वाटत नाही; हे शोधासारखे वाटते."';

  @override
  String get signupTestimonialName => 'इशिता शर्मा';

  @override
  String get signupTestimonialRole => 'इयत्ता 9 विद्यार्थी';

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
}
