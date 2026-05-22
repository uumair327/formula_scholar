import 'package:equatable/equatable.dart';

const Object _unset = Object();

/// Minimal subject representation shared across features.
///
/// Decoupled from feature-specific subject entities to avoid direct
/// cross-feature dependencies in shared state.
class SelectedSubject extends Equatable {
  const SelectedSubject({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.iconName,
    this.subtitle = '',
  });
  final String id;
  final String name;
  final String category;
  final String description;
  final String subtitle;
  final String iconName;

  @override
  List<Object?> get props => [id, name, category, description, subtitle, iconName];
}

/// State for subject selection, consumed by Chapters, Saved, Practice.
class SubjectSelectionState extends Equatable {
  const SubjectSelectionState({
    this.subject,
    this.availableSubjects = const [],
    this.curriculumKey,
  });
  final SelectedSubject? subject;
  final List<SelectedSubject> availableSubjects;
  final String? curriculumKey;

  bool get hasSelection => subject != null;

  SubjectSelectionState copyWith({
    Object? subject = _unset,
    List<SelectedSubject>? availableSubjects,
    Object? curriculumKey = _unset,
  }) {
    return SubjectSelectionState(
      subject: identical(subject, _unset)
          ? this.subject
          : subject as SelectedSubject?,
      availableSubjects: availableSubjects ?? this.availableSubjects,
      curriculumKey: identical(curriculumKey, _unset)
          ? this.curriculumKey
          : curriculumKey as String?,
    );
  }

  @override
  List<Object?> get props => [subject, availableSubjects, curriculumKey];
}
