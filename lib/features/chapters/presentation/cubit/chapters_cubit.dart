import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import 'chapters_state.dart';

/// Cubit managing the generic Chapters screen's state.
///
/// Loads chapters for **any** subject via [subjectId].
/// The same cubit serves Geometry, Algebra, Physics, etc.
/// Uses [CubitFailureLogger] mixin to eliminate error logging boilerplate.
@injectable
class ChaptersCubit extends Cubit<ChaptersState>
    with CubitFailureLogger<ChaptersState> {
  ChaptersCubit({
    required GetChaptersUseCase getChapters,
    required GetMasteryToolsUseCase getMasteryTools,
    required ToggleChapterBookmarkUseCase toggleChapterBookmark,
  }) : _getChapters = getChapters,
       _getMasteryTools = getMasteryTools,
       _toggleChapterBookmark = toggleChapterBookmark,
       super(const ChaptersState());

  final GetChaptersUseCase _getChapters;
  final GetMasteryToolsUseCase _getMasteryTools;
  final ToggleChapterBookmarkUseCase _toggleChapterBookmark;

  @override
  String get logTag => AppLogTags.chaptersCubit;

  /// Loads chapters for the given [subjectId].
  ///
  /// Skips reload if already loaded for the same subject.
  /// [sortBy] specifies Firestore field to sort by (default: 'name').
  /// [sortDesc] specifies sort direction (default: false = ascending).
  Future<void> loadChapters(
    String subjectId, {
    required String curriculumKey,
    String searchQuery = '',
    String sortBy = 'name',
    bool sortDesc = false,
    bool forceReload = false,
  }) async {
    final sameRequest =
        state.subjectId == subjectId &&
        state.curriculumKey == curriculumKey &&
        state.searchQuery == searchQuery &&
        state.sortBy == sortBy &&
        state.sortDesc == sortDesc;
    final alreadyInFlightOrReady =
        state.status == ChaptersStatus.loading ||
        state.status == ChaptersStatus.loaded;

    if (!forceReload && sameRequest && alreadyInFlightOrReady) {
      AppLogger.debug(
        'Chapters request already in progress/loaded for $subjectId, curriculum=$curriculumKey — skipping',
        tag: AppLogTags.chaptersCubit,
      );
      return;
    }

    AppLogger.info(
      'Loading chapters for subject=$subjectId, curriculum=$curriculumKey, sortBy=$sortBy, sortDesc=$sortDesc',
      tag: AppLogTags.chaptersCubit,
    );
    emit(
      state.copyWith(
        status: ChaptersStatus.loading,
        subjectId: subjectId,
        curriculumKey: curriculumKey,
        searchQuery: searchQuery,
        sortBy: sortBy,
        sortDesc: sortDesc,
      ),
    );

    // Pass sort parameters to use case (server-side authority).
    final result = await _getChapters(
      subjectId,
      curriculumKey: curriculumKey,
      searchQuery: searchQuery,
      sortBy: sortBy,
      sortDesc: sortDesc,
    );

    switch (result) {
      case Success(:final data):
        List<MasteryTool> tools = const [];
        final toolsResult = await _getMasteryTools(subjectId);
        switch (toolsResult) {
          case Success(:final data):
            tools = data;
          case Error(:final failure):
            logFailure('mastery tools for $subjectId', failure);
        }

        AppLogger.info(
          'Loaded ${data.length} chapters for $subjectId',
          tag: AppLogTags.chaptersCubit,
        );
        emit(
          state.copyWith(
            status: ChaptersStatus.loaded,
            chapters: data,
            masteryTools: tools,
          ),
        );
      case Error(:final failure):
        logFailure('chapters for $subjectId', failure);
        emit(
          state.copyWith(
            status: ChaptersStatus.error,
            errorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> toggleChapterBookmark(
    Chapter chapter,
    String subjectName, {
    required String curriculumKey,
  }) async {
    final subjectId = state.subjectId;
    if (subjectId == null) return;

    final newBookmarkState = !chapter.isSaved;

    // Optimistic update
    final updatedList = state.chapters.map((c) {
      if (c.id == chapter.id) {
        return Chapter(
          id: c.id,
          name: c.name,
          subtitle: c.subtitle,
          completedFormulas: c.completedFormulas,
          totalFormulas: c.totalFormulas,
          progressPercent: c.progressPercent,
          status: c.status,
          isSaved: newBookmarkState,
          isGeneralContent: c.isGeneralContent,
          audiences: c.audiences,
        );
      }
      return c;
    }).toList();

    emit(state.copyWith(chapters: updatedList));

    final result = await _toggleChapterBookmark(
      chapter: chapter,
      subjectName: subjectName,
      subjectId: subjectId,
      curriculumKey: curriculumKey,
    );

    if (isClosed) return;
    if (result is Error<void>) {
      logFailure('toggleChapterBookmark', result.failure);
      // Revert on failure
      final revertedList = state.chapters.map((c) {
        if (c.id == chapter.id) {
          return Chapter(
            id: c.id,
            name: c.name,
            subtitle: c.subtitle,
            completedFormulas: c.completedFormulas,
            totalFormulas: c.totalFormulas,
            progressPercent: c.progressPercent,
            status: c.status,
            isSaved: !newBookmarkState,
            isGeneralContent: c.isGeneralContent,
            audiences: c.audiences,
          );
        }
        return c;
      }).toList();
      emit(
        state.copyWith(
          chapters: revertedList,
          errorMessage: 'Failed to bookmark chapter',
        ),
      );
    }
  }
}
