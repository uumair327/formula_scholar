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
}
