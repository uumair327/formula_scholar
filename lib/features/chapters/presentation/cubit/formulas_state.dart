import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

const Object _unset = Object();

enum FormulasStatus { initial, loading, loaded, error }

/// State for the Formulas detail screen.
class FormulasState extends Equatable {
  final FormulasStatus status;
  final String? subjectId;
  final String? chapterId;
  final String? chapterName;
  final List<Formula> formulas;
  final String? errorMessage;

  const FormulasState({
    this.status = FormulasStatus.initial,
    this.subjectId,
    this.chapterId,
    this.chapterName,
    this.formulas = const [],
    this.errorMessage,
  });

  int get masteredCount => formulas.where((f) => f.isMastered).toList().length;
  int get totalCount => formulas.length;
  double get progressPercent =>
      totalCount > 0 ? (masteredCount / totalCount) * 100 : 0;

  FormulasState copyWith({
    FormulasStatus? status,
    String? subjectId,
    String? chapterId,
    String? chapterName,
    List<Formula>? formulas,
    Object? errorMessage = _unset,
  }) {
    return FormulasState(
      status: status ?? this.status,
      subjectId: subjectId ?? this.subjectId,
      chapterId: chapterId ?? this.chapterId,
      chapterName: chapterName ?? this.chapterName,
      formulas: formulas ?? this.formulas,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    subjectId,
    chapterId,
    chapterName,
    formulas,
    errorMessage,
  ];
}
