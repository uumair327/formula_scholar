import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Concrete implementation of [ChaptersRepositoryPort].
///
/// Uses [safeOperation] to eliminate boilerplate and [ChaptersCachePort]
/// for offline-first fallback when Firestore is unreachable.
@LazySingleton(as: ChaptersRepositoryPort)
class ChaptersRepositoryImpl implements ChaptersRepositoryPort {
  final ChaptersDataSourcePort _dataSource;
  final ChaptersCachePort _cache;

  const ChaptersRepositoryImpl({
    required ChaptersDataSourcePort dataSource,
    required ChaptersCachePort cache,
  }) : _dataSource = dataSource,
       _cache = cache;

  @override
  Future<Result<List<Chapter>>> getChapters(String subjectId) async {
    AppLogger.trace(
      'getChapters($subjectId) called',
      tag: AppLogTags.chaptersRepo,
    );

    return safeOperation(
      tag: AppLogTags.chaptersRepo,
      operation: 'getChapters($subjectId)',
      execute: () async {
        final result = await _dataSource.getChapters(subjectId);
        await _cache.cacheChapters(subjectId, result);
        return result;
      },
      fallback: () async {
        final cached = await _cache.getChapters(subjectId);
        return cached.isNotEmpty ? cached : null;
      },
    );
  }
}
