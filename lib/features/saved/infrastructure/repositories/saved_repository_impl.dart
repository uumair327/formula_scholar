import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Concrete implementation of [SavedRepositoryPort].
///
/// Uses [safeOperation] for DRY error handling and [SavedCachePort]
/// for offline-first bookmark access.
@LazySingleton(as: SavedRepositoryPort)
class SavedRepositoryImpl implements SavedRepositoryPort {

  const SavedRepositoryImpl({
    required SavedDataSourcePort dataSource,
    required SavedCachePort cache,
  }) : _dataSource = dataSource,
       _cache = cache;
  final SavedDataSourcePort _dataSource;
  final SavedCachePort _cache;

  @override
  Future<Result<List<BookmarkedFormula>>> getBookmarks({
    required String curriculumKey,
  }) {
    return safeOperation(
      tag: AppLogTags.savedRepo,
      operation: 'getBookmarks(curriculumKeys=$curriculumKey)',
      execute: () async {
        final result = await _dataSource.getBookmarks(
          curriculumKey: curriculumKey,
        );
        await _cache.cacheBookmarks(result);
        return result;
      },
      fallback: () async {
        final cached = await _cache.getBookmarks();
        final filtered = cached
            .where((b) => b.curriculumKey == curriculumKey)
            .toList();
        return filtered.isNotEmpty ? filtered : null;
      },
    );
  }

  @override
  Future<Result<List<BookmarkedChapter>>> getSavedChapters({
    required String curriculumKey,
  }) {
    return safeOperation(
      tag: AppLogTags.savedRepo,
      operation: 'getSavedChapters(curriculumKey=$curriculumKey)',
      execute: () async {
        final result = await _dataSource.getSavedChapters(
          curriculumKey: curriculumKey,
        );
        await _cache.cacheSavedChapters(result);
        return result;
      },
      fallback: () async {
        final cached = await _cache.getSavedChapters();
        final filtered = cached
            .where((c) => c.curriculumKey == curriculumKey)
            .toList();
        return filtered.isNotEmpty ? filtered : null;
      },
    );
  }

  @override
  Future<Result<List<SavedNote>>> getSavedNotes({
    required String curriculumKey,
  }) {
    return safeOperation(
      tag: AppLogTags.savedRepo,
      operation: 'getSavedNotes(curriculumKey=$curriculumKey)',
      execute: () async {
        final result = await _dataSource.getSavedNotes(
          curriculumKey: curriculumKey,
        );
        await _cache.cacheSavedNotes(result);
        return result;
      },
      fallback: () async {
        final cached = await _cache.getSavedNotes();
        final filtered = cached
            .where((note) => note.curriculumKey == curriculumKey)
            .toList();
        return filtered.isNotEmpty ? filtered : null;
      },
    );
  }

  @override
  Future<Result<void>> removeBookmark(String formulaId) {
    return safeOperation(
      tag: AppLogTags.savedRepo,
      operation: 'removeBookmark($formulaId)',
      execute: () => _dataSource.removeBookmark(formulaId),
      onError: (e, stackTrace) {
        if (e is CacheException) {
          return CacheFailure(
            message: e.message,
            originalError: e,
            stackTrace: stackTrace,
          );
        }
        return ServerFailure(
          message: 'Failed to remove bookmark',
          originalError: e,
          stackTrace: stackTrace,
        );
      },
    );
  }

  @override
  Future<Result<void>> removeSavedChapter({
    required String curriculumKey,
    required String subjectId,
    required String chapterId,
  }) {
    return safeOperation(
      tag: AppLogTags.savedRepo,
      operation:
          'removeSavedChapter(curriculumKey=$curriculumKey, subjectId=$subjectId, chapterId=$chapterId)',
      execute: () => _dataSource.removeSavedChapter(
        curriculumKey: curriculumKey,
        subjectId: subjectId,
        chapterId: chapterId,
      ),
      onError: (e, stackTrace) {
        if (e is CacheException) {
          return CacheFailure(
            message: e.message,
            originalError: e,
            stackTrace: stackTrace,
          );
        }
        return ServerFailure(
          message: 'Failed to remove saved chapter',
          originalError: e,
          stackTrace: stackTrace,
        );
      },
    );
  }
}
