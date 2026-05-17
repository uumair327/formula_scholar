import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../dashboard/domain/entities/subject.dart';

enum SubjectsStatus { initial, loading, loaded, error }

/// State for the Subjects feature.
class SubjectsState extends Equatable {
  const SubjectsState({
    this.status = SubjectsStatus.initial,
    this.subjects = const [],
    this.errorMessage = '',
  });

  final SubjectsStatus status;
  final List<Subject> subjects;
  final String? errorMessage;

  SubjectsState copyWith({
    SubjectsStatus? status,
    List<Subject>? subjects,
    Object? errorMessage = unset,
  }) {
    return SubjectsState(
      status: status ?? this.status,
      subjects: subjects ?? this.subjects,
      errorMessage: identical(errorMessage, unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    subjects,
    errorMessage,
  ];
}
