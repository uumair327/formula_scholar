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
  final GetSavedChaptersUseCase _getSavedChapters;
  final RemoveBookmarkUseCase _removeBookmark;
  final RemoveSavedChapterUseCase _removeSavedChapter;

  String? _activeCurriculumKey;

  @override
  String get logTag => AppLogTags.savedCubit;

  SavedCubit({
    required GetBookmarksUseCase getBookmarks,
    required GetSavedChaptersUseCase getSavedChapters,
    required RemoveBookmarkUseCase removeBookmark,
    required RemoveSavedChapterUseCase removeSavedChapter,
  }) : _getBookmarks = getBookmarks,
       _getSavedChapters = getSavedChapters,
       _removeBookmark = removeBookmark,
       _removeSavedChapter = removeSavedChapter,
       super(const SavedState());

  /// Loads saved bookmarks.
  Future<void> loadBookmarks({required String curriculumKey}) async {
    _activeCurriculumKey = curriculumKey;
    AppLogger.info('Loading bookmarks', tag: AppLogTags.savedCubit);
    emit(state.copyWith(status: SavedStatus.loading));

    final formulasResult = await _getBookmarks(curriculumKey: curriculumKey);
    final chaptersResult = await _getSavedChapters(
      curriculumKey: curriculumKey,
    );

    if (formulasResult is Error<List<BookmarkedFormula>>) {
      logFailure('bookmarks', formulasResult.failure);
      emit(
        state.copyWith(
          status: SavedStatus.error,
          errorMessage: formulasResult.failure.message,
        ),
      );
      return;
    }

    if (chaptersResult is Error<List<BookmarkedChapter>>) {
      logFailure('saved chapters', chaptersResult.failure);
      emit(
        state.copyWith(
          status: SavedStatus.error,
          errorMessage: chaptersResult.failure.message,
        ),
      );
      return;
    }

    final formulas = (formulasResult as Success<List<BookmarkedFormula>>).data;
    final chapters = (chaptersResult as Success<List<BookmarkedChapter>>).data;

    AppLogger.info(
      'Loaded ${formulas.length} bookmarks and ${chapters.length} saved chapters',
      tag: AppLogTags.savedCubit,
    );
    emit(
      state.copyWith(
        status: SavedStatus.loaded,
        bookmarks: formulas,
        chapters: chapters,
      ),
    );
  }

  /// Removes a bookmark and reloads.
  Future<void> removeBookmark(String formulaId) async {
    // Optimistic update
    final initialBookmarks = List<BookmarkedFormula>.from(state.bookmarks);
    final updatedList = initialBookmarks
        .where((element) => element.id != formulaId)
        .toList();
    emit(state.copyWith(bookmarks: updatedList));

    final result = await _removeBookmark(formulaId);
    if (result is Error<void>) {
      logFailure('remove bookmark', result.failure);
      emit(
        state.copyWith(
          bookmarks: initialBookmarks,
          errorMessage: 'Failed to remove bookmark',
        ),
      );
    }
  }

  /// Removes a saved chapter and updates state optimistically.
  Future<void> removeSavedChapter({
    required String subjectId,
    required String chapterId,
  }) async {
    final curriculumKey = _activeCurriculumKey;
    if (curriculumKey == null) {
      emit(state.copyWith(errorMessage: 'No active curriculum selected'));
      return;
    }

    final initialChapters = List<BookmarkedChapter>.from(state.chapters);
    final updatedList = initialChapters
        .where((c) => !(c.subjectId == subjectId && c.chapterId == chapterId))
        .toList();
    emit(state.copyWith(chapters: updatedList));

    final result = await _removeSavedChapter(
      curriculumKey: curriculumKey,
      subjectId: subjectId,
      chapterId: chapterId,
    );

    if (result is Error<void>) {
      logFailure('remove saved chapter', result.failure);
      emit(
        state.copyWith(
          chapters: initialChapters,
          errorMessage: 'Failed to remove saved chapter',
        ),
      );
    }
  }
}
