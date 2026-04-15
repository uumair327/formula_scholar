import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Concrete implementation of [ChaptersRepositoryPort].
///
/// Uses [safeOperation] to eliminate boilerplate and [ChaptersCachePort]
/// for offline-first fallback when Firestore is unreachable.
@LazySingleton(as: ChaptersRepositoryPort)
class ChaptersRepositoryImpl implements ChaptersRepositoryPort {
  const ChaptersRepositoryImpl({
    required ChaptersDataSourcePort dataSource,
    required ChaptersCachePort cache,
  }) : _dataSource = dataSource,
       _cache = cache;

  final ChaptersDataSourcePort _dataSource;
  final ChaptersCachePort _cache;

  @override
  Future<Result<List<Chapter>>> getChapters(
    String subjectId, {
    required String curriculumKey,
  }) async {
    AppLogger.trace(
      'getChapters($subjectId, curriculum=$curriculumKey) called',
      tag: AppLogTags.chaptersRepo,
    );

    return safeOperation(
      tag: AppLogTags.chaptersRepo,
      operation: 'getChapters($subjectId, curriculum=$curriculumKey)',
      execute: () async {
        final result = await _dataSource.getChapters(subjectId, curriculumKey);
        await _cache.cacheChapters(subjectId, curriculumKey, result);
        return result;
      },
      fallback: () async {
        final cached = await _cache.getChapters(subjectId, curriculumKey);
        return cached.isNotEmpty ? cached : null;
      },
    );
  }

  @override
  Future<Result<List<MasteryTool>>> getMasteryTools(String subjectId) async {
    try {
      final tools = await _dataSource.getMasteryTools(subjectId);
      return Success(tools);
    } catch (e, stackTrace) {
      AppLogger.error(
        'getMasteryTools failed',
        tag: AppLogTags.chaptersRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(
        CacheFailure(
          message: 'Failed to load mastery tools',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void>> toggleChapterBookmark(
    Chapter chapter,
    String subjectName, {
    required String subjectId,
    required String curriculumKey,
  }) async {
    try {
      await _dataSource.toggleChapterBookmark(
        chapter,
        subjectName,
        subjectId,
        curriculumKey,
      );
      return const Success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'toggleChapterBookmark failed',
        tag: AppLogTags.chaptersRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(
        CacheFailure(
          message: 'Failed to bookmark chapter',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<bool>> isChapterBookmarked(
    String chapterId, {
    required String subjectId,
    required String curriculumKey,
  }) async {
    try {
      final isSaved = await _dataSource.isChapterBookmarked(
        chapterId,
        subjectId,
        curriculumKey,
      );
      return Success(isSaved);
    } catch (e, stackTrace) {
      AppLogger.error(
        'isChapterBookmarked failed',
        tag: AppLogTags.chaptersRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(
        CacheFailure(
          message: 'Failed to load chapter bookmark status',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
