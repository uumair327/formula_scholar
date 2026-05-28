// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'فورمولا سكولار';

  @override
  String get dashboardHeroBadge => 'مناهج CBSE • الصف 9';

  @override
  String get dashboardHeroTitle => 'إتقان الحركة و\\nقوانين القوة';

  @override
  String dashboardHeroDescription(Object progress) {
    return 'تابع رحلتك في الفيزياء. أنت $progress% خلال الفصل الحالي.';
  }

  @override
  String get dashboardResumeLesson => 'استئناف الدرس';

  @override
  String get dashboardResumeSemantic => 'استئناف التعلم';

  @override
  String get quickActionsTitle => 'استكشف الأدوات';

  @override
  String get studyPlanner => 'مخطط الدراسة';

  @override
  String get viewAnalytics => 'عرض التحليلات';

  @override
  String get flashcards => 'بطاقات المراجعة';

  @override
  String get welcomeBack => 'مرحبًا بعودتك ✨';

  @override
  String get searchLabel => 'بحث';

  @override
  String get searchFormulas => 'ابحث عن الصيغ';

  @override
  String get searchFormulasTitle => 'ابحث عن الصيغ';

  @override
  String get searchEmptyDescription => 'اكتب للبحث في جميع المواد والفصول';

  @override
  String get noResultsFound => 'لا توجد نتائج';

  @override
  String get tryDifferentSearch => 'جرّب عبارة بحث مختلفة';

  @override
  String get clearSearch => 'مسح البحث';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navSubjects => 'المواد';

  @override
  String get navPractice => 'التدريب';

  @override
  String get navSaved => 'المحفوظات';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get labelsLocalizationTitle => 'تعريب تسميات التطبيق';

  @override
  String get labelsLocalizationSubtitle =>
      'تحكم في تسميات التطبيق ولغة محتوى الواجهة الخلفية بشكل مستقل';

  @override
  String get enableLabelsLocalization => 'تفعيل تعريب تسميات التطبيق';

  @override
  String get enableLabelsLocalizationDesc =>
      'تبديل تسميات التطبيق إلى اللغة المحددة';

  @override
  String get useSystemLanguage => 'استخدام لغة النظام';

  @override
  String get currentSystemLanguage => 'لغة النظام الحالية';

  @override
  String get appLabelLanguage => 'لغة تسميات التطبيق';

  @override
  String get contentLocalizationTitle => 'تعريب محتوى الواجهة الخلفية';

  @override
  String get contentLocalizationSubtitle =>
      'اختر لغة محتوى Firestore بشكل منفصل عن تسميات التطبيق';

  @override
  String get enableContentLocalization => 'تفعيل تعريب محتوى الواجهة الخلفية';

  @override
  String get enableContentLocalizationDesc =>
      'تحميل محتوى لوحة التحكم للغة المحددة';

  @override
  String get contentLanguage => 'لغة المحتوى';

  @override
  String get contentLocalizationFallbackInfo =>
      'إذا لم توجد ترجمة، يعود التطبيق إلى الإنجليزية (الهند).';

  @override
  String get localizationEffectiveSummary => 'التعريب الفعلي';

  @override
  String get appLabels => 'تسميات التطبيق';

  @override
  String get backendContent => 'محتوى الواجهة الخلفية';

  @override
  String get languageAndLocalization => 'اللغة والتعريب';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageUrdu => 'الأردية';

  @override
  String get languageMarathi => 'الماراثية';

  @override
  String get languageEnglishIndia => 'الإنجليزية (الهند)';

  @override
  String get viewInsights => 'عرض الرؤى';

  @override
  String get loginTitle => 'مرحبًا بعودتك';

  @override
  String get loginSubtitle => 'أدخل بياناتك للوصول إلى ملاذك.';

  @override
  String get loginEmailLabel => 'البريد الإلكتروني أو اسم المستخدم';

  @override
  String get loginEmailHint => 'scholar@formulaflow.com';

  @override
  String get loginPasswordLabel => 'كلمة المرور';

  @override
  String get loginPasswordHint => '••••••••••••';

  @override
  String get loginForgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get loginSignIn => 'تسجيل الدخول';

  @override
  String get loginOr => 'أو';

  @override
  String get loginGoogle => 'Google';

  @override
  String get loginSchoolId => 'الرقم المدرسي';

  @override
  String get loginNoAccount => 'ليس لديك حساب؟';

  @override
  String get loginSignUp => 'إنشاء حساب';

  @override
  String get signupTitle => 'أنشئ حسابك';

  @override
  String get signupSubtitle => 'ابدأ رحلتك في الملاذ المعرفي.';

  @override
  String get signupFullName => 'الاسم الكامل';

  @override
  String get signupFullNameHint => 'John Doe';

  @override
  String get signupEmail => 'البريد الإلكتروني';

  @override
  String get signupEmailHint => 'name@school.com';

  @override
  String get signupPassword => 'كلمة المرور';

  @override
  String get signupConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get signupPasswordHint => '••••••••';

  @override
  String get signupCreateAccount => 'إنشاء حساب';

  @override
  String get signupHasAccount => 'هل لديك حساب بالفعل؟';

  @override
  String get signupSignIn => 'تسجيل الدخول';

  @override
  String get forgotPasswordTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get forgotPasswordDesc =>
      'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور.';

  @override
  String get forgotPasswordSend => 'إرسال رابط إعادة التعيين';

  @override
  String get forgotPasswordSuccess =>
      'تم إرسال رابط إعادة تعيين كلمة المرور! تحقق من صندوق الوارد.';

  @override
  String get forgotPasswordCancel => 'إلغاء';

  @override
  String get signupBrandTitle => 'ملاذ الفورمولا';

  @override
  String get signupBrandHeadline => 'أتقن تدفق المعرفة.';

  @override
  String get signupBrandDesc =>
      'انضم إلى ملاذ مصمم للتعلم المركّز. حوّل المعادلات المعقدة إلى خطوات بديهية.';

  @override
  String get signupTestimonial =>
      '"أصبحت الصيغ أخيرًا مفهومة. لا يبدو الأمر كأنه دراسة؛ بل كأنه استكشاف."';

  @override
  String get signupTestimonialName => 'إشيطا شارما';

  @override
  String get signupTestimonialRole => 'طالبة صف 9';

  @override
  String get proBadge => 'احترافي';

  @override
  String get currentGrade => 'الصف الحالي';

  @override
  String get pageNotFound => 'الصفحة غير موجودة';

  @override
  String get pageNotFoundDescription =>
      'الصفحة التي تبحث عنها غير موجودة. ربما تم نقلها أو أن الرابط غير صحيح.';

  @override
  String get goHome => 'العودة للرئيسية';

  @override
  String get loginStudentPortal => 'بوابة الطالب';

  @override
  String get loginBrandTagline => 'أتقن كل\nقانون بسهولة.';

  @override
  String get loginBrandDesc =>
      'الملاذ المعرفي الأمثل لطلاب المرحلة الثانوية. نظم وتعلم وتفوق في رحلتك الرياضية.';

  @override
  String get signupTerms => 'أوافق على ';

  @override
  String get signupTermsLink => 'شروط الخدمة';

  @override
  String get signupAnd => ' و ';

  @override
  String get signupPrivacy => 'سياسة الخصوصية';

  @override
  String get signupOrJoin => 'أو انضم عبر';

  @override
  String get signupFacebook => 'Facebook';

  @override
  String get profileInsightsTitle => 'رؤى الملف الشخصي';

  @override
  String get profileInsightsSubtitle =>
      'تقدم مدفوع من الواجهة الخلفية لمحة سريعة';

  @override
  String get profileInsightsSource => 'مزامنة من Firestore';

  @override
  String get profileStatsPending =>
      'ستظهر إحصاءات ملفك الشخصي هنا بعد اكتمال مزامنة الواجهة الخلفية.';

  @override
  String get continuePracticing => 'تابع الممارسة';

  @override
  String get browseChapters => 'تصفح الفصول';

  @override
  String get viewFullAnalytics => 'عرض التحليلات الكاملة';
}
