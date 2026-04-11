import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Concrete implementation of [SavedRepositoryPort].
@LazySingleton(as: SavedRepositoryPort)
class SavedRepositoryImpl implements SavedRepositoryPort {
  final SavedDataSourcePort _dataSource;

  const SavedRepositoryImpl({required SavedDataSourcePort dataSource})
    : _dataSource = dataSource;

  @override
  Future<Result<List<BookmarkedFormula>>> getBookmarks() async {
    AppLogger.trace('getBookmarks() called', tag: AppLogTags.savedRepo);
    try {
      final result = await _dataSource.getBookmarks();
      AppLogger.info(
        'getBookmarks() succeeded: ${result.length} items',
        tag: AppLogTags.savedRepo,
      );
      return Success(result);
    } catch (e, stackTrace) {
      AppLogger.error(
        'getBookmarks() failed',
        tag: AppLogTags.savedRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(
        ServerFailure(
          message: 'Failed to load bookmarks',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<void>> removeBookmark(String formulaId) async {
    try {
      await _dataSource.removeBookmark(formulaId);
      return const Success(null);
    } on CacheException catch (e, stackTrace) {
      return Error(
        CacheFailure(
          message: e.message,
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    } catch (e, stackTrace) {
      return Error(
        CacheFailure(
          message: 'Failed to remove bookmark',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
