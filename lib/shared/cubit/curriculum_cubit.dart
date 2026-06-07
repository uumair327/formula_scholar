import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../core/core.dart';

/// Global cubit holding the user's selected curriculum (board + grade).
///
/// The cubit keeps presentation state in sync with the persisted source of
/// truth and never falls back to fake board/grade defaults.
@lazySingleton
class CurriculumCubit extends Cubit<CurriculumState> {
  CurriculumCubit({
    required LoadCurriculumUseCase loadCurriculum,
    required SaveCurriculumUseCase saveCurriculum,
    required WatchCurriculumUseCase watchCurriculum,
  }) : _loadCurriculum = loadCurriculum,
       _saveCurriculum = saveCurriculum,
       _watchCurriculum = watchCurriculum,
       super(const CurriculumState()) {
    _curriculumSubscription = _watchCurriculum().listen(
      _syncCurriculumFromStream,
      onError: (Object error, StackTrace stackTrace) {
        AppLogger.error(
          'Curriculum stream failed',
          tag: AppLogTags.curriculumCubit,
          error: error,
          stackTrace: stackTrace,
        );
        emit(state.copyWith(isLoading: false, isInitialized: true));
      },
    );

    Future.microtask(refresh);
  }
  final LoadCurriculumUseCase _loadCurriculum;
  final SaveCurriculumUseCase _saveCurriculum;
  final WatchCurriculumUseCase _watchCurriculum;
  late final StreamSubscription<SelectedCurriculum?> _curriculumSubscription;

  Future<void> refresh() async {
    AppLogger.info(
      'Refreshing curriculum from repository',
      tag: AppLogTags.curriculumCubit,
    );
    final loadingState = state.copyWith(isLoading: true);
    if (loadingState != state) {
      emit(loadingState);
    }

    try {
      final curriculum = await _loadCurriculum();
      _syncCurriculumFromStream(curriculum);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to load curriculum from repository',
        tag: AppLogTags.curriculumCubit,
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(isLoading: false, isInitialized: true));
    }
  }

  Future<void> setCurriculum({
    required String boardId,
    required String boardName,
    required String gradeId,
    required String gradeLabel,
    required int gradeNumber,
    String? countryId,
    String? stateId,
    String? countryName,
    String? stateName,
  }) async {
    AppLogger.info(
      'Setting curriculum: board=$boardName ($boardId), grade=$gradeLabel ($gradeId)',
      tag: AppLogTags.curriculumCubit,
    );

    final previousCurriculum = state.curriculum;
    final curriculum = SelectedCurriculum(
      boardId: boardId,
      boardName: boardName,
      gradeId: gradeId,
      gradeLabel: gradeLabel,
      gradeNumber: gradeNumber,
      countryId: countryId,
      stateId: stateId,
      countryName: countryName,
      stateName: stateName,
    );

    emit(
      state.copyWith(
        curriculum: curriculum,
        isLoading: true,
        isInitialized: true,
      ),
    );

    try {
      await _saveCurriculum(curriculum);
      emit(
        state.copyWith(
          curriculum: curriculum,
          isLoading: false,
          isInitialized: true,
        ),
      );
    } catch (error, stackTrace) {
      AppLogger.error(
        'Failed to persist curriculum via repository',
        tag: AppLogTags.curriculumCubit,
        error: error,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          curriculum: previousCurriculum,
          isLoading: false,
          isInitialized: true,
        ),
      );
    }
  }

  void applyCurriculum(SelectedCurriculum curriculum) {
    AppLogger.debug(
      'Applying curriculum locally: ${curriculum.boardId}/${curriculum.gradeId}',
      tag: AppLogTags.curriculumCubit,
    );
    final nextState = state.copyWith(
      curriculum: curriculum,
      isLoading: false,
      isInitialized: true,
    );
    if (nextState != state) {
      emit(nextState);
    }
  }

  void clear() {
    AppLogger.debug('Curriculum cleared (reset to uninitialized)', tag: AppLogTags.curriculumCubit);
    const clearedState = CurriculumState(isLoading: false, isInitialized: false);
    if (state != clearedState) {
      emit(clearedState);
    }
  }

  void _syncCurriculumFromStream(SelectedCurriculum? curriculum) {
    AppLogger.info(
      'Curriculum sync event: ${curriculum?.boardName ?? 'none'}',
      tag: AppLogTags.curriculumCubit,
    );
    final nextState = state.copyWith(
      curriculum: curriculum,
      isLoading: false,
      isInitialized: true,
    );

    if (nextState == state) {
      AppLogger.debug(
        'Curriculum sync received duplicate state; skipping emit',
        tag: AppLogTags.curriculumCubit,
      );
      return;
    }

    emit(nextState);
  }

  @override
  Future<void> close() async {
    await _curriculumSubscription.cancel();
    return super.close();
  }
}
