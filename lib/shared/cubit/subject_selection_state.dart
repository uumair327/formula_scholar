import 'package:equatable/equatable.dart';

/// Minimal subject representation shared across features.
///
/// Decoupled from [Subject] in the dashboard domain to avoid
/// cross-feature dependency (Dependency Inversion Principle).
class SelectedSubject extends Equatable {
  final String id;
  final String name;
  final String category;
  final String description;
  final String subtitle;

  const SelectedSubject({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    this.subtitle = '',
  });

  @override
  List<Object?> get props => [id, name, category, subtitle];
}

/// State for subject selection, consumed by Chapters, Saved, Practice.
class SubjectSelectionState extends Equatable {
  final SelectedSubject? subject;
  final List<SelectedSubject> availableSubjects;

  const SubjectSelectionState({
    this.subject,
    this.availableSubjects = const [],
  });

  bool get hasSelection => subject != null;

  SubjectSelectionState copyWith({
    SelectedSubject? subject,
    List<SelectedSubject>? availableSubjects,
  }) {
    return SubjectSelectionState(
      subject: subject ?? this.subject,
      availableSubjects: availableSubjects ?? this.availableSubjects,
    );
  }

  @override
  List<Object?> get props => [subject, availableSubjects];
}
