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
  FormulasCubit({
    required GetFormulasUseCase getFormulas,
    required ToggleBookmarkUseCase toggleBookmark,
    required FormulasRepositoryPort formulasRepository,
    required ChaptersRepositoryPort chaptersRepository,
  }) : _getFormulas = getFormulas,
       _toggleBookmark = toggleBookmark,
       _formulasRepository = formulasRepository,
       _chaptersRepository = chaptersRepository,
       super(const FormulasState());

  final GetFormulasUseCase _getFormulas;
  final ToggleBookmarkUseCase _toggleBookmark;
  final FormulasRepositoryPort _formulasRepository;
  final ChaptersRepositoryPort _chaptersRepository;

  @override
  String get logTag => AppLogTags.formulasCubit;

  /// Loads formulas for the given [subjectId] and [chapterId].
  Future<void> loadFormulas({
    required String subjectId,
    required String chapterId,
    String? chapterName,
    String? curriculumKey,
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

    final result = await _getFormulas(
      subjectId,
      chapterId,
      curriculumKey: curriculumKey,
    );

    switch (result) {
      case Success(:final data):
        AppLogger.info(
          'Loaded ${data.length} formulas for $chapterId',
          tag: AppLogTags.formulasCubit,
        );
        emit(state.copyWith(status: FormulasStatus.loaded, formulas: data));

        final safeChapterName = chapterName ?? AppStrings.chapterLabel;
        await _formulasRepository.markChapterStarted(
          subjectId,
          chapterId,
          chapterName: safeChapterName,
          totalFormulas: data.length,
        );

        if (curriculumKey != null && curriculumKey.isNotEmpty) {
          final bookmarkResult = await _chaptersRepository.isChapterBookmarked(
            chapterId,
            subjectId: subjectId,
            curriculumKey: curriculumKey,
          );
          switch (bookmarkResult) {
            case Success(:final data):
              emit(state.copyWith(isChapterSaved: data));
            case Error():
              // Keep the default false state if lookup fails.
              AppLogger.debug(
                'Failed to read chapter bookmark state, using default false',
                tag: AppLogTags.formulasCubit,
              );
          }
        }
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

  /// Toggles mastery status for a formula and syncs aggregate chapter progress.
  Future<void> toggleMastery(Formula formula) async {
    final subjectId = state.subjectId;
    final chapterId = state.chapterId;
    final chapterName = state.chapterName;
    if (subjectId == null || chapterId == null || chapterName == null) {
      AppLogger.warning(
        'toggleMastery called without subject/chapter context',
        tag: AppLogTags.formulasCubit,
      );
      return;
    }

    final newMasteredState = !formula.isMastered;

    final updatedList = state.formulas.map((f) {
      if (f.id == formula.id) {
        return Formula(
          id: f.id,
          title: f.title,
          latex: f.latex,
          description: f.description,
          isMastered: newMasteredState,
          isBookmarked: f.isBookmarked,
          audiences: f.audiences,
          isGeneralContent: f.isGeneralContent,
        );
      }
      return f;
    }).toList();
    emit(state.copyWith(formulas: updatedList));

    final result = await _formulasRepository.toggleFormulaMastery(
      subjectId,
      chapterId,
      formula.id,
      isMastered: newMasteredState,
      totalFormulas: state.formulas.length,
      chapterName: chapterName,
    );

    if (result is Error<void>) {
      logFailure('toggleMastery', result.failure);
      final revertedList = state.formulas.map((f) {
        if (f.id == formula.id) {
          return Formula(
            id: f.id,
            title: f.title,
            latex: f.latex,
            description: f.description,
            isMastered: !newMasteredState,
            isBookmarked: f.isBookmarked,
            audiences: f.audiences,
            isGeneralContent: f.isGeneralContent,
          );
        }
        return f;
      }).toList();
      emit(
        state.copyWith(
          formulas: revertedList,
          errorMessage: 'Failed to update mastery progress',
        ),
      );
    }
  }

  Future<void> toggleBookmark(
    Formula formula,
    String subjectName, {
    required String curriculumKey,
  }) async {
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
          audiences: f.audiences,
          isGeneralContent: f.isGeneralContent,
        );
      }
      return f;
    }).toList();

    emit(state.copyWith(formulas: updatedList));

    final result = await _toggleBookmark(
      formula,
      subjectName,
      curriculumKey: curriculumKey,
    );
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
            audiences: f.audiences,
            isGeneralContent: f.isGeneralContent,
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

  /// Toggles the saved/bookmarked status of the current chapter.
  ///
  /// Uses optimistic UI update for responsive feedback.
  Future<void> toggleChapterBookmark(
    String chapterName,
    String subjectName, {
    required String curriculumKey,
  }) async {
    if (state.chapterId == null || state.subjectId == null) {
      AppLogger.warning(
        'toggleChapterBookmark called without chapterId/subjectId',
        tag: AppLogTags.formulasCubit,
      );
      return;
    }

    // Optimistic UI update
    final newSavedState = !state.isChapterSaved;
    emit(state.copyWith(isChapterSaved: newSavedState));

    // Create a temporary Chapter object for the repository call
    final chapter = Chapter(
      id: state.chapterId!,
      name: chapterName,
      subtitle: '',
      completedFormulas: 0,
      totalFormulas: 0,
      progressPercent: 0,
      isSaved: state.isChapterSaved,
    );

    final result = await _chaptersRepository.toggleChapterBookmark(
      chapter,
      subjectName,
      subjectId: state.subjectId!,
      curriculumKey: curriculumKey,
    );

    if (result is Error<void>) {
      logFailure('toggleChapterBookmark', result.failure);
      // Revert on failure
      emit(state.copyWith(isChapterSaved: !newSavedState));
      emit(state.copyWith(errorMessage: 'Failed to bookmark chapter'));
    } else {
      AppLogger.info(
        'Chapter ${state.chapterId} bookmark toggled to $newSavedState',
        tag: AppLogTags.formulasCubit,
      );
    }
  }
}
