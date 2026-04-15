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
  }) : _getChapters = getChapters,
       _getMasteryTools = getMasteryTools,
       super(const ChaptersState());

  final GetChaptersUseCase _getChapters;
  final GetMasteryToolsUseCase _getMasteryTools;

  @override
  String get logTag => AppLogTags.chaptersCubit;

  /// Loads chapters for the given [subjectId].
  ///
  /// Skips reload if already loaded for the same subject.
  Future<void> loadChapters(
    String subjectId, {
    required String curriculumKey,
    bool forceReload = false,
  }) async {
    if (!forceReload &&
        state.subjectId == subjectId &&
        state.curriculumKey == curriculumKey &&
        state.status == ChaptersStatus.loaded) {
      AppLogger.debug(
        'Chapters already loaded for $subjectId, curriculum=$curriculumKey — skipping',
        tag: AppLogTags.chaptersCubit,
      );
      return;
    }

    AppLogger.info(
      'Loading chapters for subject=$subjectId, curriculum=$curriculumKey',
      tag: AppLogTags.chaptersCubit,
    );
    emit(
      state.copyWith(
        status: ChaptersStatus.loading,
        subjectId: subjectId,
        curriculumKey: curriculumKey,
      ),
    );

    final result = await _getChapters(subjectId, curriculumKey: curriculumKey);

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
}
