import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

@LazySingleton(as: FormulasDataSourcePort)
class FormulasApiAdapter implements FormulasDataSourcePort {
  final ApiClient _apiClient;

  FormulasApiAdapter(this._apiClient);

  @override
  Future<List<Formula>> getFormulas(
    String subjectId,
    String chapterId, {
    String? curriculumKey,
  }) async {
    try {
      final response = await _apiClient.get('/formulas?domain=$subjectId&tag=$chapterId');
      
      final items = response['items'] as List<dynamic>? ?? [];
      
      return items.map((data) => Formula(
        id: data['formula_id'] ?? '',
        title: data['name'] ?? '',
        latex: data['expression'] ?? '', // Assuming expression holds latex
        description: data['description'] ?? '',
        isMastered: false, // User-specific data missing from REST API
        isBookmarked: false, // User-specific data missing from REST API
        isGeneralContent: false,
        audiences: (data['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
        canonicalFormulaId: data['formula_id'],
        widgetConfig: null,
      )).toList();
    } catch (e) {
      AppLogger.error('Failed to fetch formulas from API: $e', tag: AppLogTags.formulasDataSource);
      return [];
    }
  }

  @override
  Future<void> toggleBookmark(
    Formula formula,
    String subjectName, {
    required String curriculumKey,
  }) async {
    // TODO: Implement user bookmark via REST when endpoint is available
    AppLogger.warning('toggleBookmark not yet supported by REST API', tag: AppLogTags.formulasDataSource);
  }

  @override
  Future<void> markChapterStarted(
    String subjectId,
    String chapterId, {
    required String chapterName,
    required int totalFormulas,
  }) async {
    // TODO: Implement user progress tracking via REST
    AppLogger.warning('markChapterStarted not yet supported by REST API', tag: AppLogTags.formulasDataSource);
  }

  @override
  Future<void> toggleFormulaMastery(
    String subjectId,
    String chapterId,
    String formulaId, {
    required bool isMastered,
    required int totalFormulas,
    required String chapterName,
  }) async {
    // TODO: Implement formula mastery tracking via REST
    AppLogger.warning('toggleFormulaMastery not yet supported by REST API', tag: AppLogTags.formulasDataSource);
  }

  @override
  Future<FormulaNote?> getFormulaNote(String formulaId) async {
    return null;
  }

  @override
  Future<void> saveFormulaNote(FormulaNote note) async {
    AppLogger.warning('saveFormulaNote not yet supported by REST API', tag: AppLogTags.formulasDataSource);
  }

  @override
  Future<void> deleteFormulaNote(String formulaId) async {
    AppLogger.warning('deleteFormulaNote not yet supported by REST API', tag: AppLogTags.formulasDataSource);
  }
}
