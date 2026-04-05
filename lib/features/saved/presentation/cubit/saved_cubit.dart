import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import 'saved_state.dart';

/// Cubit managing the Saved/Bookmarks screen's state.
///
/// Uses [CubitFailureLogger] mixin to eliminate error logging boilerplate.
@injectable
class SavedCubit extends Cubit<SavedState> with CubitFailureLogger<SavedState> {
  final GetBookmarksUseCase _getBookmarks;
  final RemoveBookmarkUseCase _removeBookmark;

  @override
  String get logTag => AppLogTags.savedCubit;

  SavedCubit({
    required GetBookmarksUseCase getBookmarks,
    required RemoveBookmarkUseCase removeBookmark,
  })  : _getBookmarks = getBookmarks,
        _removeBookmark = removeBookmark,
        super(const SavedState());

  /// Loads saved bookmarks.
  Future<void> loadBookmarks() async {
    AppLogger.info('Loading bookmarks', tag: AppLogTags.savedCubit);
    emit(state.copyWith(status: SavedStatus.loading));

    final result = await _getBookmarks();

    switch (result) {
      case Success(:final data):
        AppLogger.info(
          'Loaded ${data.length} bookmarks',
          tag: AppLogTags.savedCubit,
        );
        emit(state.copyWith(status: SavedStatus.loaded, bookmarks: data));
      case Error(:final failure):
        logFailure('bookmarks', failure);
        emit(
          state.copyWith(
            status: SavedStatus.error,
            errorMessage: failure.message,
          ),
        );
    }
  }

  /// Removes a bookmark and reloads.
  Future<void> removeBookmark(String formulaId) async {
    // Optimistic update
    final initialBookmarks = List<BookmarkedFormula>.from(state.bookmarks);
    final updatedList = initialBookmarks.where((element) => element.id != formulaId).toList();
    emit(state.copyWith(bookmarks: updatedList));

    final result = await _removeBookmark(formulaId);
    if (result is Error<void>) {
       logFailure('remove bookmark', result.failure);
       emit(state.copyWith(bookmarks: initialBookmarks, errorMessage: 'Failed to remove bookmark'));
    }
  }
}
