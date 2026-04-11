import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import 'formulas_state.dart';

/// Cubit managing the formula detail screen's state.
///
/// Loads formulas for a specific chapter within a subject.
@injectable
class FormulasCubit extends Cubit<FormulasState>
    with CubitFailureLogger<FormulasState> {
  final GetFormulasUseCase _getFormulas;
  final ToggleBookmarkUseCase _toggleBookmark;

  @override
  String get logTag => AppLogTags.formulasCubit;

  FormulasCubit({
    required GetFormulasUseCase getFormulas,
    required ToggleBookmarkUseCase toggleBookmark,
  }) : _getFormulas = getFormulas,
       _toggleBookmark = toggleBookmark,
       super(const FormulasState());

  /// Loads formulas for the given [subjectId] and [chapterId].
  Future<void> loadFormulas({
    required String subjectId,
    required String chapterId,
    String? chapterName,
  }) async {
    AppLogger.info(
      'Loading formulas for subject=$subjectId, chapter=$chapterId',
      tag: AppLogTags.formulasCubit,
    );
    emit(
      state.copyWith(
        status: FormulasStatus.loading,
        subjectId: subjectId,
        chapterId: chapterId,
        chapterName: chapterName,
      ),
    );

    final result = await _getFormulas(subjectId, chapterId);

    switch (result) {
      case Success(:final data):
        AppLogger.info(
          'Loaded ${data.length} formulas for $chapterId',
          tag: AppLogTags.formulasCubit,
        );
        emit(state.copyWith(status: FormulasStatus.loaded, formulas: data));
      case Error(:final failure):
        logFailure('formulas for $chapterId', failure);
        emit(
          state.copyWith(
            status: FormulasStatus.error,
            errorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> toggleBookmark(Formula formula, String subjectName) async {
    // Optimistic UI update
    final newBookmarkState = !formula.isBookmarked;
    final updatedList = state.formulas.map((f) {
      if (f.id == formula.id) {
        return Formula(
          id: f.id,
          title: f.title,
          latex: f.latex,
          description: f.description,
          isMastered: f.isMastered,
          isBookmarked: newBookmarkState,
        );
      }
      return f;
    }).toList();

    emit(state.copyWith(formulas: updatedList));

    final result = await _toggleBookmark(formula, subjectName);
    if (result is Error<void>) {
      logFailure('toggleBookmark', result.failure);
      // Revert on failure
      final revertedList = state.formulas.map((f) {
        if (f.id == formula.id) {
          return Formula(
            id: f.id,
            title: f.title,
            latex: f.latex,
            description: f.description,
            isMastered: f.isMastered,
            isBookmarked: !newBookmarkState,
          );
        }
        return f;
      }).toList();
      emit(
        state.copyWith(
          formulas: revertedList,
          errorMessage: 'Failed to bookmark formula',
        ),
      );
    }
  }
}
