import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import 'formulas_state.dart';

/// Cubit managing the formula detail screen's state.
@injectable
class FormulasCubit extends Cubit<FormulasState>
    with CubitFailureLogger<FormulasState> {
  FormulasCubit({
    required GetFormulasUseCase getFormulas,
    required ToggleBookmarkUseCase toggleBookmark,
    required FormulasRepositoryPort formulasRepository,
    required ChaptersRepositoryPort chaptersRepository,
    required GetFormulaNoteUseCase getFormulaNote,
    required SaveFormulaNoteUseCase saveFormulaNote,
    required DeleteFormulaNoteUseCase deleteFormulaNote,
  }) : _getFormulas = getFormulas,
       _toggleBookmark = toggleBookmark,
       _formulasRepository = formulasRepository,
       _chaptersRepository = chaptersRepository,
       _getFormulaNote = getFormulaNote,
       _saveFormulaNote = saveFormulaNote,
       _deleteFormulaNote = deleteFormulaNote,
       super(const FormulasState());

  final GetFormulasUseCase _getFormulas;
  final ToggleBookmarkUseCase _toggleBookmark;
  final FormulasRepositoryPort _formulasRepository;
  final ChaptersRepositoryPort _chaptersRepository;
  final GetFormulaNoteUseCase _getFormulaNote;
  final SaveFormulaNoteUseCase _saveFormulaNote;
  final DeleteFormulaNoteUseCase _deleteFormulaNote;
  Timer? _noteDebounce;

  @override
  String get logTag => AppLogTags.formulasCubit;

  @override
  Future<void> close() {
    _noteDebounce?.cancel();
    return super.close();
  }

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

  Future<void> loadFormulaNote(String formulaId) async {
    final result = await _getFormulaNote(formulaId);
    switch (result) {
      case Success(:final data):
        emit(state.copyWith(formulaNotes: {formulaId: data}));
      case Error():
        AppLogger.debug(
          'Failed to load note for formula $formulaId',
          tag: AppLogTags.formulasCubit,
        );
    }
  }

  void saveFormulaNote(FormulaNote note) {
    _noteDebounce?.cancel();
    _noteDebounce = Timer(const Duration(milliseconds: 500), () async {
      emit(state.copyWith(formulaNotes: {note.formulaId: note}));
      final result = await _saveFormulaNote(note);
      if (result is Error<void>) {
        logFailure('saveFormulaNote', result.failure);
      }
    });
  }

  Future<void> deleteFormulaNote(String formulaId) async {
    emit(state.copyWith(formulaNotes: {formulaId: null}));
    final result = await _deleteFormulaNote(formulaId);
    if (result is Error<void>) {
      logFailure('deleteFormulaNote', result.failure);
    }
  }

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

    final newSavedState = !state.isChapterSaved;
    emit(state.copyWith(isChapterSaved: newSavedState));

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
