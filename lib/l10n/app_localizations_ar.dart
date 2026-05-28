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
}
