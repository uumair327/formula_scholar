import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';
/// Hive-backed cache for formulas data, enabling offline-first access.
///
/// Follows the same pattern established by [ChaptersHiveCache].
@LazySingleton(as: FormulasCachePort)
class FormulasHiveCache implements FormulasCachePort {
  static const String _boxName = 'formulas_cache';

  Future<Box<dynamic>> _box() => Hive.openBox<dynamic>(_boxName);

  String _key(String subjectId, String chapterId, String curriculumKey) =>
      'formulas_${curriculumKey}_${subjectId}_$chapterId';

  @override
  Future<void> cacheFormulas(
    String subjectId,
    String chapterId,
    String curriculumKey,
    List<Formula> formulas,
  ) async {
    final box = await _box();
    await box.put(
      _key(subjectId, chapterId, curriculumKey),
      formulas
          .map(
            (f) => {
              'id': f.id,
              'title': f.title,
              'latex': f.latex,
              'description': f.description,
              'isMastered': f.isMastered,
              'isBookmarked': f.isBookmarked,
              'audiences': f.audiences,
              'isGeneralContent': f.isGeneralContent,
              'canonicalFormulaId': f.canonicalFormulaId,
              'widgetConfig': f.widgetConfig,
            },
          )
          .toList(),
    );
  }

  @override
  Future<List<Formula>> getFormulas(
    String subjectId,
    String chapterId,
    String curriculumKey,
  ) async {
    final box = await _box();
    final cached =
        box.get(_key(subjectId, chapterId, curriculumKey)) as List<dynamic>?;
    if (cached == null) {
      return const [];
    }

    return cached
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(
          (item) => Formula(
            id: item['id'] as String? ?? '',
            title: item['title'] as String? ?? '',
            latex: item['latex'] as String? ?? '',
            description: item['description'] as String? ?? '',
            isMastered: item['isMastered'] as bool? ?? false,
            isBookmarked: item['isBookmarked'] as bool? ?? false,
            audiences:
                (item['audiences'] as List<dynamic>?)
                    ?.whereType<String>()
                    .toList() ??
                const [],
            isGeneralContent: item['isGeneralContent'] as bool? ?? false,
            canonicalFormulaId: item['canonicalFormulaId'] as String?,
            widgetConfig: item['widgetConfig'] != null
                ? Map<String, dynamic>.from(item['widgetConfig'] as Map)
                : null,
          ),
        )
        .toList();
  }
}
