import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../dashboard/domain/domain.dart';
import 'subjects_state.dart';

/// Cubit responsible for loading the list of available subjects
/// for the currently active curriculum (board + grade).
///
/// Listens to curriculum changes and re-fetches subjects automatically
/// when the user switches board or grade on the Dashboard.
@injectable
class SubjectsCubit extends Cubit<SubjectsState> {
  SubjectsCubit(
    this._getSubjectsUseCase,
    this._watchCurriculumUseCase,
  ) : super(const SubjectsState()) {
    _curriculumSubscription =
        _watchCurriculumUseCase().listen(_onCurriculumChanged);
  }

  final GetSubjectsUseCase _getSubjectsUseCase;
  final WatchCurriculumUseCase _watchCurriculumUseCase;
  late final StreamSubscription<SelectedCurriculum?> _curriculumSubscription;

  Future<void> _onCurriculumChanged(SelectedCurriculum? curriculum) async {
    if (curriculum == null) {
      emit(const SubjectsState());
      return;
    }
    await loadSubjects(curriculum.boardId, curriculum.gradeId);
  }

  /// Fetches subjects for the given [boardId] and [gradeId].
  Future<void> loadSubjects(String boardId, String gradeId) async {
    emit(state.copyWith(status: SubjectsStatus.loading, errorMessage: ''));

    final result = await _getSubjectsUseCase.call(boardId, gradeId);

    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        emit(state.copyWith(
          status: SubjectsStatus.loaded,
          subjects: data,
        ));
      case Error(:final failure):
        emit(state.copyWith(
          status: SubjectsStatus.error,
          errorMessage: failure.message,
        ));
    }
  }

  @override
  Future<void> close() {
    _curriculumSubscription.cancel();
    return super.close();
  }
}
