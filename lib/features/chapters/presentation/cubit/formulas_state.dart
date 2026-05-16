import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

const Object _unset = Object();

enum FormulasStatus { initial, loading, loaded, error }

/// State for the Formulas detail screen.
class FormulasState extends Equatable {
  const FormulasState({
    this.status = FormulasStatus.initial,
    this.subjectId,
    this.chapterId,
    this.chapterName,
    this.formulas = const [],
    this.isChapterSaved = false,
    this.errorMessage,
    this.formulaNotes = const {},
  });
  final FormulasStatus status;
  final String? subjectId;
  final String? chapterId;
  final String? chapterName;
  final List<Formula> formulas;
  final bool isChapterSaved;
  final String? errorMessage;
  final Map<String, FormulaNote?> formulaNotes;

  int get masteredCount => formulas.where((f) => f.isMastered).toList().length;
  int get totalCount => formulas.length;
  double get progressPercent =>
      totalCount > 0 ? (masteredCount / totalCount) * 100 : 0;

  /// Returns the note for a given formula id, or null if none exists.
  FormulaNote? noteFor(String formulaId) => formulaNotes[formulaId];

  FormulasState copyWith({
    FormulasStatus? status,
    String? subjectId,
    String? chapterId,
    String? chapterName,
    List<Formula>? formulas,
    bool? isChapterSaved,
    Object? errorMessage = _unset,
    Map<String, FormulaNote?>? formulaNotes,
  }) {
    return FormulasState(
      status: status ?? this.status,
      subjectId: subjectId ?? this.subjectId,
      chapterId: chapterId ?? this.chapterId,
      chapterName: chapterName ?? this.chapterName,
      formulas: formulas ?? this.formulas,
      isChapterSaved: isChapterSaved ?? this.isChapterSaved,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      formulaNotes: formulaNotes ?? this.formulaNotes,
    );
  }

  @override
  List<Object?> get props => [
    status,
    subjectId,
    chapterId,
    chapterName,
    formulas,
    isChapterSaved,
    errorMessage,
    formulaNotes,
  ];
}
