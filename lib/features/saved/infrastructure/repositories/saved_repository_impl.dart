import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Concrete implementation of [SavedRepositoryPort].
///
/// Uses [safeOperation] for DRY error handling and [SavedCachePort]
/// for offline-first bookmark access.
@LazySingleton(as: SavedRepositoryPort)
class SavedRepositoryImpl implements SavedRepositoryPort {
  final SavedDataSourcePort _dataSource;
  final SavedCachePort _cache;

  const SavedRepositoryImpl({
    required SavedDataSourcePort dataSource,
    required SavedCachePort cache,
  }) : _dataSource = dataSource,
       _cache = cache;

  @override
  Future<Result<List<BookmarkedFormula>>> getBookmarks() {
    return safeOperation(
      tag: AppLogTags.savedRepo,
      operation: 'getBookmarks',
      execute: () async {
        final result = await _dataSource.getBookmarks();
        await _cache.cacheBookmarks(result);
        return result;
      },
      fallback: () async {
        final cached = await _cache.getBookmarks();
        return cached.isNotEmpty ? cached : null;
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
}
