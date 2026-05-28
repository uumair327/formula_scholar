import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

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
    String searchQuery = '',
    String sortBy = 'name',
    bool sortDesc = false,
  }) async {
    AppLogger.trace(
      'getChapters($subjectId, curriculum=$curriculumKey, sortBy=$sortBy, sortDesc=$sortDesc) called',
      tag: AppLogTags.chaptersRepo,
    );

    return safeOperation(
      tag: AppLogTags.chaptersRepo,
      operation:
          'getChapters($subjectId, curriculum=$curriculumKey, search=$searchQuery, sortBy=$sortBy)',
      execute: () async {
        // Pass sort parameters to data source (server-side authority).
        final result = await _dataSource.getChapters(
          subjectId,
          curriculumKey,
          sortBy: sortBy,
          sortDesc: sortDesc,
        );
        final filtered = _applySearchQuery(result, searchQuery);
        await _cache.cacheChapters(subjectId, curriculumKey, result);
        return filtered;
      },
      fallback: () async {
        final cached = await _cache.getChapters(subjectId, curriculumKey);
        if (cached.isEmpty) {
          return null;
        }
        final filtered = _applySearchQuery(cached, searchQuery);
        return filtered.isNotEmpty ? filtered : cached;
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

  List<Chapter> _applySearchQuery(List<Chapter> chapters, String searchQuery) {
    final search = searchQuery.trim().toLowerCase();
    if (search.isEmpty) {
      return chapters;
    }

    return chapters
        .where((chapter) => chapter.name.toLowerCase().contains(search))
        .toList();
  }
}
