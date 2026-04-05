import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../core/core.dart';
import 'subject_selection_state.dart';

/// Global cubit holding the currently selected subject.
///
/// Provided at the app root so all tabs (Chapters, Saved, Practice)
/// can read the active subject and react to changes.
///
/// Registered as [LazySingleton] because a single selection must
/// be shared across the entire widget tree.
@lazySingleton
class SubjectSelectionCubit extends Cubit<SubjectSelectionState> {
  SubjectSelectionCubit() : super(const SubjectSelectionState());

  /// Selects a subject — triggers Chapters/Saved/Practice to reload.
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
      ),
    );
  }

  /// Updates the list of available subjects for the current curriculum.
  void updateAvailableSubjects(List<SelectedSubject> subjects) {
    AppLogger.info(
      'Available subjects updated: ${subjects.length}',
      tag: AppLogTags.subjectSelection,
    );
    emit(state.copyWith(availableSubjects: subjects));
  }

  /// Clears the current selection.
  void clearSelection() {
    AppLogger.debug(
      'Subject selection cleared',
      tag: AppLogTags.subjectSelection,
    );
    emit(state.copyWith(subject: null));
  }
}
