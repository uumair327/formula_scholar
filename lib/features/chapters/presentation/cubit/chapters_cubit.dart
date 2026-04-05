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
  final GetChaptersUseCase _getChapters;

  @override
  String get logTag => AppLogTags.chaptersCubit;

  ChaptersCubit({required GetChaptersUseCase getChapters})
    : _getChapters = getChapters,
      super(const ChaptersState());

  /// Loads chapters for the given [subjectId].
  ///
  /// Skips reload if already loaded for the same subject.
  Future<void> loadChapters(
    String subjectId, {
    bool forceReload = false,
  }) async {
    if (!forceReload &&
        state.subjectId == subjectId &&
        state.status == ChaptersStatus.loaded) {
      AppLogger.debug(
        'Chapters already loaded for $subjectId — skipping',
        tag: AppLogTags.chaptersCubit,
      );
      return;
    }

    AppLogger.info(
      'Loading chapters for subject=$subjectId',
      tag: AppLogTags.chaptersCubit,
    );
    emit(state.copyWith(status: ChaptersStatus.loading, subjectId: subjectId));

    final result = await _getChapters(subjectId);

    switch (result) {
      case Success(:final data):
        AppLogger.info(
          'Loaded ${data.length} chapters for $subjectId',
          tag: AppLogTags.chaptersCubit,
        );
        emit(state.copyWith(status: ChaptersStatus.loaded, chapters: data));
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
