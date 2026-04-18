import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../core/core.dart';
import '../domain/domain.dart';
import 'subject_selection_state.dart';

/// Global cubit holding the currently selected subject.
///
/// The selected subject is scoped to the active curriculum so persisted
/// state cannot leak across board/grade changes or user sessions.
@lazySingleton
class SubjectSelectionCubit extends HydratedCubit<SubjectSelectionState> {

  SubjectSelectionCubit({required WatchCurriculumUseCase watchCurriculum})
    : _watchCurriculum = watchCurriculum,
      super(const SubjectSelectionState()) {
    _curriculumSubscription = _watchCurriculum().listen(_handleCurriculumSync);
  }
  final WatchCurriculumUseCase _watchCurriculum;
  late final StreamSubscription<SelectedCurriculum?> _curriculumSubscription;
  String? _activeCurriculumKey;

  void selectSubject({
    required String id,
    required String name,
    required String category,
    required String description,
    String subtitle = '',
  }) {
    AppLogger.info(
      'Subject selected: $name (id=$id)',
      tag: AppLogTags.subjectSelection,
    );
    emit(
      state.copyWith(
        subject: SelectedSubject(
          id: id,
          name: name,
          category: category,
          description: description,
          subtitle: subtitle,
        ),
        curriculumKey: _activeCurriculumKey,
      ),
    );
  }

  void updateAvailableSubjects(List<SelectedSubject> subjects) {
    AppLogger.info(
      'Available subjects updated: ${subjects.length}',
      tag: AppLogTags.subjectSelection,
    );

    final nextState = state.copyWith(
      availableSubjects: subjects,
      curriculumKey: _activeCurriculumKey,
    );
    final selectedSubject = state.subject;
    final selectedStillExists =
        selectedSubject == null ||
        subjects.any((subject) => subject.id == selectedSubject.id);

    emit(selectedStillExists ? nextState : nextState.copyWith(subject: null));
  }

  void clearSelection() {
    AppLogger.debug(
      'Subject selection cleared',
      tag: AppLogTags.subjectSelection,
    );
    emit(state.copyWith(subject: null));
  }

  void _handleCurriculumSync(SelectedCurriculum? curriculum) {
    final nextCurriculumKey = _buildCurriculumKey(curriculum);
    final previousCurriculumKey = _activeCurriculumKey;
    _activeCurriculumKey = nextCurriculumKey;

    if (previousCurriculumKey == nextCurriculumKey) {
      return;
    }

    final selectionMatchesCurriculum = state.curriculumKey == nextCurriculumKey;
    if (selectionMatchesCurriculum) {
      emit(state.copyWith(curriculumKey: nextCurriculumKey));
      return;
    }

    AppLogger.info(
      'Curriculum changed; clearing stale subject selection',
      tag: AppLogTags.subjectSelection,
    );
    emit(
      state.copyWith(
        subject: null,
        availableSubjects: const [],
        curriculumKey: nextCurriculumKey,
      ),
    );
  }

  String? _buildCurriculumKey(SelectedCurriculum? curriculum) {
    if (curriculum == null) {
      return null;
    }

    return '${curriculum.boardId}::${curriculum.gradeId}';
  }

  @override
  SubjectSelectionState? fromJson(Map<String, dynamic> json) {
    final subjectMap = json['subject'] as Map<String, dynamic>?;
    return SubjectSelectionState(
      subject: subjectMap == null
          ? null
          : SelectedSubject(
              id: subjectMap['id'] as String,
              name: subjectMap['name'] as String,
              category: subjectMap['category'] as String,
              description: subjectMap['description'] as String,
              subtitle: subjectMap['subtitle'] as String? ?? '',
            ),
      curriculumKey: json['curriculumKey'] as String?,
    );
  }

  @override
  Map<String, dynamic>? toJson(SubjectSelectionState state) {
    final subject = state.subject;
    return {
      'curriculumKey': state.curriculumKey,
      'subject': subject == null
          ? null
          : {
              'id': subject.id,
              'name': subject.name,
              'category': subject.category,
              'description': subject.description,
              'subtitle': subject.subtitle,
            },
    };
  }

  @override
  Future<void> close() async {
    await _curriculumSubscription.cancel();
    return super.close();
  }
}
