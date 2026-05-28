import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';
/// Hive-backed cache for chapters data, enabling offline-first access.
///
/// Follows the same pattern established by [DashboardHiveCache].
@LazySingleton(as: ChaptersCachePort)
class ChaptersHiveCache implements ChaptersCachePort {
  static const String _boxName = 'chapters_cache';

  Future<Box<dynamic>> _box() => Hive.openBox<dynamic>(_boxName);

  String _key(String subjectId, String curriculumKey) =>
      'chapters_${curriculumKey}_$subjectId';

  @override
  Future<void> cacheChapters(
    String subjectId,
    String curriculumKey,
    List<Chapter> chapters,
  ) async {
    final box = await _box();
    await box.put(
      _key(subjectId, curriculumKey),
      chapters
          .map(
            (c) => {
              'id': c.id,
              'name': c.name,
              'subtitle': c.subtitle,
              'completedFormulas': c.completedFormulas,
              'totalFormulas': c.totalFormulas,
              'progressPercent': c.progressPercent,
              'status': c.status.name,
              'isSaved': c.isSaved,
            },
          )
          .toList(),
    );
  }

  @override
  Future<List<Chapter>> getChapters(
    String subjectId,
    String curriculumKey,
  ) async {
    final box = await _box();
    final cached = box.get(_key(subjectId, curriculumKey)) as List<dynamic>?;
    if (cached == null) {
      return const [];
    }

    return cached
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map((item) {
          final statusStr = item['status'] as String? ?? 'notStarted';
          ChapterStatus status = ChapterStatus.notStarted;
          if (statusStr == 'inProgress') status = ChapterStatus.inProgress;
          if (statusStr == 'locked') status = ChapterStatus.locked;

          return Chapter(
            id: item['id'] as String? ?? '',
            name: item['name'] as String? ?? '',
            subtitle: item['subtitle'] as String? ?? '',
            completedFormulas:
                (item['completedFormulas'] as num?)?.toInt() ?? 0,
            totalFormulas: (item['totalFormulas'] as num?)?.toInt() ?? 1,
            progressPercent:
                (item['progressPercent'] as num?)?.toDouble() ?? 0.0,
            status: status,
            isSaved: item['isSaved'] as bool? ?? false,
          );
        })
        .toList();
  }
}
