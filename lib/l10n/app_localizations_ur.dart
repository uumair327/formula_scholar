// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appName => 'فارمولا اسکالر';

  @override
  String get dashboardHeroBadge => 'CBSE نصاب • جماعت 9';

  @override
  String get dashboardHeroTitle => 'حرکت اور\\nقوانینِ قوت میں مہارت';

  @override
  String dashboardHeroDescription(Object progress) {
    return 'فزکس میں اپنا سفر جاری رکھیں۔ آپ اس باب کا $progress% مکمل کر چکے ہیں۔';
  }

  @override
  String get dashboardResumeLesson => 'سبق دوبارہ شروع کریں';

  @override
  String get dashboardResumeSemantic => 'مطالعہ دوبارہ شروع کریں';

  @override
  String get quickActionsTitle => 'ٹولز دریافت کریں';

  @override
  String get studyPlanner => 'مطالعہ منصوبہ ساز';

  @override
  String get viewAnalytics => 'تجزیات دیکھیں';

  @override
  String get flashcards => 'فلیش کارڈز';
}
