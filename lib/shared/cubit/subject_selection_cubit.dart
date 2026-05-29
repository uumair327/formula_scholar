import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../core/core.dart';
import '../../features/dashboard/domain/domain.dart';

/// Global cubit holding the currently selected subject.
///
/// The selected subject is scoped to the active curriculum so persisted
/// state cannot leak across board/grade changes or user sessions.
@lazySingleton
class SubjectSelectionCubit extends HydratedCubit<SubjectSelectionState> {
  SubjectSelectionCubit({
    required WatchCurriculumUseCase watchCurriculum,
    required GetSubjectsUseCase getSubjects,
  }) : _watchCurriculum = watchCurriculum,
       _getSubjects = getSubjects,
       super(const SubjectSelectionState()) {
    _curriculumSubscription = _watchCurriculum().listen(_handleCurriculumSync);
  }
  final WatchCurriculumUseCase _watchCurriculum;
  final GetSubjectsUseCase _getSubjects;
  late final StreamSubscription<SelectedCurriculum?> _curriculumSubscription;
  String? _activeCurriculumKey;

  void selectSubject({
    required String id,
    required String name,
    required String category,
    required String description,
    required String iconName,
    String subtitle = '',
    int? colorValue,
  }) {
    AppLogger.info(
      'Subject selected: $name (id=$id)',
      tag: AppLogTags.subjectSelection,
    );
    final nextState = state.copyWith(
      subject: SelectedSubject(
        id: id,
        name: name,
        category: category,
        description: description,
        iconName: iconName,
        subtitle: subtitle,
        colorValue: colorValue,
      ),
      curriculumKey: _activeCurriculumKey,
    );

    if (nextState != state) {
      emit(nextState);
    }
  }

  void updateAvailableSubjects(List<SelectedSubject> subjects) {
    AppLogger.info(
      'Available subjects updated: ${subjects.length}',
      tag: AppLogTags.subjectSelection,
    );

    final selectedSubject = state.subject;
    final hasSelectedSubject = selectedSubject != null;
    final selectedStillExists =
        !hasSelectedSubject ||
        subjects.any((subject) => subject.id == selectedSubject.id);
    final nextSubject = !hasSelectedSubject && subjects.isNotEmpty
        ? subjects.first
        : selectedStillExists
        ? selectedSubject
        : null;

    final nextState = state.copyWith(
      availableSubjects: subjects,
      subject: nextSubject,
      curriculumKey: _activeCurriculumKey,
      isLoadingAvailableSubjects: false,
    );

    if (nextState != state) {
      emit(nextState);
    }
  }

  void clearSelection() {
    AppLogger.debug(
      'Subject selection cleared',
      tag: AppLogTags.subjectSelection,
    );
    final nextState = state.copyWith(subject: null);
    if (nextState != state) {
      emit(nextState);
    }
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
      final nextState = state.copyWith(curriculumKey: nextCurriculumKey);
      if (nextState != state) {
        emit(nextState);
      }
      return;
    }

    AppLogger.info(
      'Curriculum changed; clearing stale subject selection',
      tag: AppLogTags.subjectSelection,
    );
    final nextState = state.copyWith(
      subject: null,
      availableSubjects: const [],
      curriculumKey: nextCurriculumKey,
      isLoadingAvailableSubjects: false,
    );
    if (nextState != state) {
      emit(nextState);
    }

    if (curriculum != null) {
      unawaited(_loadAvailableSubjects(curriculum));
    }
  }

  Future<void> _loadAvailableSubjects(SelectedCurriculum curriculum) async {
    final curriculumKey = _buildCurriculumKey(curriculum);
    if (curriculumKey == null) {
      return;
    }

    final loadingState = state.copyWith(isLoadingAvailableSubjects: true);
    if (loadingState != state) {
      emit(loadingState);
    }

    final result = await _getSubjects(curriculum.boardId, curriculum.gradeId);
    if (_activeCurriculumKey != curriculumKey) {
      return;
    }

    switch (result) {
      case Success<List<Subject>>(:final data):
        updateAvailableSubjects(
          data
              .map(
                (subject) => SelectedSubject(
                  id: subject.id,
                  name: subject.name,
                  category: subject.category,
                  description: subject.description,
                  iconName: subject.iconName,
                  subtitle: subject.subtitle ?? '',
                  colorValue: subject.colorValue,
                ),
              )
              .toList(),
        );
      case Error<List<Subject>>(:final failure):
        AppLogger.error(
          'Failed to load available subjects',
          tag: AppLogTags.subjectSelection,
          error: failure.originalError,
          stackTrace: failure.stackTrace,
        );
        emit(state.copyWith(isLoadingAvailableSubjects: false));
    }
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
              iconName: subjectMap['iconName'] as String? ?? 'book',
              subtitle: subjectMap['subtitle'] as String? ?? '',
              colorValue: subjectMap['colorValue'] as int?,
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
              'iconName': subject.iconName,
              'subtitle': subject.subtitle,
              'colorValue': subject.colorValue,
            },
    };
  }

  @override
  Future<void> close() async {
    await _curriculumSubscription.cancel();
    return super.close();
  }
}
