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
    SavedQuery query = const SavedQuery(),
  }) {
    return safeOperation(
      tag: AppLogTags.savedRepo,
      operation: 'getBookmarks(curriculumKeys=$curriculumKey)',
      execute: () async {
        final result = await _dataSource.getBookmarks(
          curriculumKey: curriculumKey,
          query: query,
        );
        await _cache.cacheBookmarks(result);
        return result;
      },
      fallback: () async {
        final cached = await _cache.getBookmarks();
        final filtered = _applyQuery(
          cached.where((b) => b.curriculumKey == curriculumKey).toList(),
          query: query,
          titleOf: (item) => item.title,
          subjectOf: (item) => item.subject,
          contentOf: (item) => item.formula,
          savedAtOf: (item) => item.savedAt,
        );
        return filtered.isNotEmpty ? filtered : null;
      },
    );
  }

  @override
  Future<Result<List<BookmarkedChapter>>> getSavedChapters({
    required String curriculumKey,
    SavedQuery query = const SavedQuery(),
  }) {
    return safeOperation(
      tag: AppLogTags.savedRepo,
      operation: 'getSavedChapters(curriculumKey=$curriculumKey)',
      execute: () async {
        final result = await _dataSource.getSavedChapters(
          curriculumKey: curriculumKey,
          query: query,
        );
        await _cache.cacheSavedChapters(result);
        return result;
      },
      fallback: () async {
        final cached = await _cache.getSavedChapters();
        final filtered = _applyQuery(
          cached.where((c) => c.curriculumKey == curriculumKey).toList(),
          query: query,
          titleOf: (item) => item.chapterName,
          subjectOf: (item) => item.subjectName,
          contentOf: (item) => item.chapterSubtitle,
          savedAtOf: (item) => item.savedAt,
        );
        return filtered.isNotEmpty ? filtered : null;
      },
    );
  }

  @override
  Future<Result<List<SavedNote>>> getSavedNotes({
    required String curriculumKey,
    SavedQuery query = const SavedQuery(),
  }) {
    return safeOperation(
      tag: AppLogTags.savedRepo,
      operation: 'getSavedNotes(curriculumKey=$curriculumKey)',
      execute: () async {
        final result = await _dataSource.getSavedNotes(
          curriculumKey: curriculumKey,
          query: query,
        );
        await _cache.cacheSavedNotes(result);
        return result;
      },
      fallback: () async {
        final cached = await _cache.getSavedNotes();
        final filtered = _applyQuery(
          cached.where((note) => note.curriculumKey == curriculumKey).toList(),
          query: query,
          titleOf: (item) => item.title,
          subjectOf: (item) => item.subject,
          contentOf: (item) => item.content,
          savedAtOf: (item) => item.savedAt,
        );
        return filtered.isNotEmpty ? filtered : null;
      },
    );
  }

  List<T> _applyQuery<T>(
    List<T> items, {
    required SavedQuery query,
    required String Function(T item) titleOf,
    required String Function(T item) subjectOf,
    required String Function(T item) contentOf,
    required DateTime Function(T item) savedAtOf,
  }) {
    final search = query.searchQuery.trim().toLowerCase();
    final filtered = search.isEmpty
        ? items
        : items.where((item) {
            return titleOf(item).toLowerCase().contains(search) ||
                subjectOf(item).toLowerCase().contains(search) ||
                contentOf(item).toLowerCase().contains(search);
          }).toList();

    // Apply offline fallback sorting (mirrors server-side Firestore sorting).
    // Server is authoritative; this is for cache-only scenarios.
    final sorted = List<T>.from(filtered);
    sorted.sort((left, right) {
      int comparison;

      // Sort by the requested field.
      switch (query.sortByField) {
        case 'title':
          comparison = titleOf(
            left,
          ).toLowerCase().compareTo(titleOf(right).toLowerCase());
          break;
        case 'subject':
          comparison = subjectOf(
            left,
          ).toLowerCase().compareTo(subjectOf(right).toLowerCase());
          break;
        case 'content':
          comparison = contentOf(
            left,
          ).toLowerCase().compareTo(contentOf(right).toLowerCase());
          break;
        case 'savedAt':
        default:
          comparison = savedAtOf(left).compareTo(savedAtOf(right));
      }

      // Reverse if descending order.
      return query.isDescending ? -comparison : comparison;
    });

    return sorted;
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
