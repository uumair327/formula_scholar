import 'dart:async';
import 'dart:math';

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
  SavedCubit({
    required GetBookmarksUseCase getBookmarks,
    required GetSavedChaptersUseCase getSavedChapters,
    required GetSavedNotesUseCase getSavedNotes,
    required RemoveBookmarkUseCase removeBookmark,
    required RemoveSavedChapterUseCase removeSavedChapter,
    required AddNoteUseCase addNote,
    required UpdateNoteUseCase updateNote,
    required DeleteNoteUseCase deleteNote,
  }) : _getBookmarks = getBookmarks,
       _getSavedChapters = getSavedChapters,
       _getSavedNotes = getSavedNotes,
       _removeBookmark = removeBookmark,
       _removeSavedChapter = removeSavedChapter,
       _addNote = addNote,
       _updateNote = updateNote,
       _deleteNote = deleteNote,
       super(const SavedState());
  final GetBookmarksUseCase _getBookmarks;
  final GetSavedChaptersUseCase _getSavedChapters;
  final GetSavedNotesUseCase _getSavedNotes;
  final RemoveBookmarkUseCase _removeBookmark;
  final RemoveSavedChapterUseCase _removeSavedChapter;
  final AddNoteUseCase _addNote;
  final UpdateNoteUseCase _updateNote;
  final DeleteNoteUseCase _deleteNote;

  String? _activeCurriculumKey;

  @override
  String get logTag => AppLogTags.savedCubit;

  /// Loads saved bookmarks.
  Future<void> loadBookmarks({required String curriculumKey}) async {
    _activeCurriculumKey = curriculumKey;
    AppLogger.info('Loading bookmarks', tag: AppLogTags.savedCubit);
    emit(state.copyWith(status: SavedStatus.loading));

    // Build query with server-side sort authority (golden rule).
    final query = SavedQuery(
      searchQuery: state.searchQuery,
      sortByField: state.sortByField,
      sortDirection: state.sortDirection,
    );

    final formulasResult = await _getBookmarks(
      curriculumKey: curriculumKey,
      query: query,
    );
    final chaptersResult = await _getSavedChapters(
      curriculumKey: curriculumKey,
      query: query,
    );
    final notesResult = await _getSavedNotes(
      curriculumKey: curriculumKey,
      query: query,
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

    if (notesResult is Error<List<SavedNote>>) {
      logFailure('saved notes', notesResult.failure);
      emit(
        state.copyWith(
          status: SavedStatus.error,
          errorMessage: notesResult.failure.message,
        ),
      );
      return;
    }

    final formulas = (formulasResult as Success<List<BookmarkedFormula>>).data;
    final chapters = (chaptersResult as Success<List<BookmarkedChapter>>).data;
    final notes = (notesResult as Success<List<SavedNote>>).data;

    AppLogger.info(
      'Loaded ${formulas.length} bookmarks, ${chapters.length} saved chapters and ${notes.length} saved notes',
      tag: AppLogTags.savedCubit,
    );
    emit(
      state.copyWith(
        status: SavedStatus.loaded,
        bookmarks: formulas,
        chapters: chapters,
        notes: notes,
        searchQuery: state.searchQuery,
      ),
    );
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
    final curriculumKey = _activeCurriculumKey;
    if (curriculumKey != null) {
      unawaited(loadBookmarks(curriculumKey: curriculumKey));
    }
  }

  /// Updates the sort-by-field and reloads bookmarks.
  ///
  /// Example: updateSort('title') sorts by title in current direction,
  /// updateSort('title', SortDirection.asc) sorts by title ascending.
  void updateSort({required String sortByField, SortDirection? sortDirection}) {
    final direction = sortDirection ?? state.sortDirection;
    emit(state.copyWith(sortByField: sortByField, sortDirection: direction));
    final curriculumKey = _activeCurriculumKey;
    if (curriculumKey != null) {
      unawaited(loadBookmarks(curriculumKey: curriculumKey));
    }
  }

  /// Toggles sort direction (asc <-> desc) for current field.
  void toggleSortDirection() {
    final newDirection = state.sortDirection == SortDirection.asc
        ? SortDirection.desc
        : SortDirection.asc;
    emit(state.copyWith(sortDirection: newDirection));
    final curriculumKey = _activeCurriculumKey;
    if (curriculumKey != null) {
      unawaited(loadBookmarks(curriculumKey: curriculumKey));
    }
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
    if (isClosed) return;
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

  /// Adds a new note and reloads.
  Future<void> addNote({
    required String title,
    required String content,
    required String subject,
    required String curriculumKey,
    String? subjectId,
    String? chapterId,
    String? formulaId,
    String? formulaTitle,
    String? formulaLatex,
  }) async {
    emit(state.copyWith(isSavingNote: true, errorMessage: null));
    final note = SavedNote(
      id: 'note_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}',
      title: title,
      subject: subject,
      content: content,
      curriculumKey: curriculumKey,
      savedAt: DateTime.now(),
      subjectId: subjectId,
      chapterId: chapterId,
      formulaId: formulaId,
      formulaTitle: formulaTitle,
      formulaLatex: formulaLatex,
    );

    final result = await _addNote(note);
    if (isClosed) return;
    if (result is Error<void>) {
      logFailure('add note', result.failure);
      emit(
        state.copyWith(errorMessage: 'Failed to add note', isSavingNote: false),
      );
      return;
    }

    final updatedNotes = List<SavedNote>.from(state.notes)..add(note);
    emit(state.copyWith(notes: updatedNotes, isSavingNote: false));
  }

  /// Updates an existing note.
  Future<void> editNote(SavedNote note) async {
    emit(state.copyWith(isSavingNote: true, errorMessage: null));
    final result = await _updateNote(note);
    if (isClosed) return;
    if (result is Error<void>) {
      logFailure('update note', result.failure);
      emit(
        state.copyWith(
          errorMessage: 'Failed to update note',
          isSavingNote: false,
        ),
      );
      return;
    }

    final updatedNotes = state.notes
        .map((n) => n.id == note.id ? note : n)
        .toList();
    emit(state.copyWith(notes: updatedNotes, isSavingNote: false));
  }

  /// Deletes a note.
  Future<void> removeNote(String noteId) async {
    final initialNotes = List<SavedNote>.from(state.notes);
    final updatedList = initialNotes.where((n) => n.id != noteId).toList();
    emit(state.copyWith(notes: updatedList));

    final result = await _deleteNote(noteId);
    if (isClosed) return;
    if (result is Error<void>) {
      logFailure('delete note', result.failure);
      emit(
        state.copyWith(
          notes: initialNotes,
          errorMessage: 'Failed to delete note',
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

    if (isClosed) return;
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
