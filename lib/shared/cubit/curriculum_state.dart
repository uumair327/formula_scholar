import 'package:equatable/equatable.dart';

import '../domain/domain.dart';

const Object _unset = Object();

/// State for the global curriculum selection.
class CurriculumState extends Equatable {
  const CurriculumState({
    this.curriculum,
    this.isLoading = true,
    this.isInitialized = false,
  });
  final SelectedCurriculum? curriculum;
  final bool isLoading;
  final bool isInitialized;

  bool get hasSelection => curriculum != null;

  String? get boardId => curriculum?.boardId;
  String? get boardName => curriculum?.boardName;
  String? get gradeId => curriculum?.gradeId;
  String? get gradeLabel => curriculum?.gradeLabel;
  int? get gradeNumber => curriculum?.gradeNumber;

  CurriculumState copyWith({
    Object? curriculum = _unset,
    bool? isLoading,
    bool? isInitialized,
  }) {
    return CurriculumState(
      curriculum: identical(curriculum, _unset)
          ? this.curriculum
          : curriculum as SelectedCurriculum?,
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  @override
  List<Object?> get props => [curriculum, isLoading, isInitialized];
}
