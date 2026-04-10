import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../core/core.dart';
import 'curriculum_state.dart';

/// Global cubit holding the user's selected curriculum (board + grade).
///
/// Provided at the app root so all tabs (Dashboard, Chapters, Profile)
/// can read the active curriculum and react to changes.
///
/// Persists to Firestore `users/{uid}` document so the selection
/// survives app restarts.
///
/// Registered as [LazySingleton] because a single selection must
/// be shared across the entire widget tree.
@lazySingleton
class CurriculumCubit extends Cubit<CurriculumState> {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  CurriculumCubit(this._firestore, this._firebaseAuth)
      : super(const CurriculumState());

  /// Loads the curriculum from Firestore user document.
  ///
  /// Called on app start (after auth) to restore the user's selection.
  Future<void> loadFromFirestore() async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) return;

    AppLogger.info(
      'Loading curriculum from Firestore for uid=$uid',
      tag: AppLogTags.curriculumCubit,
    );
    emit(state.copyWith(isLoading: true));

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      final data = doc.data()!;
      final boardId = data['boardId'] as String?;
      final boardName = data['boardName'] as String?;
      final gradeId = data['gradeId'] as String?;
      final gradeLabel = data['gradeLabel'] as String?;
      final gradeNumber = data['gradeNumber'] as int?;

      if (boardId != null && gradeId != null) {
        AppLogger.info(
          'Curriculum loaded: board=$boardName, grade=$gradeLabel',
          tag: AppLogTags.curriculumCubit,
        );
        emit(
          state.copyWith(
            curriculum: SelectedCurriculum(
              boardId: boardId,
              boardName: boardName ?? boardId.toUpperCase(),
              gradeId: gradeId,
              gradeLabel: gradeLabel ?? 'Class $gradeNumber',
              gradeNumber: gradeNumber ?? 9,
            ),
            isLoading: false,
          ),
        );
      } else {
        AppLogger.info(
          'No curriculum found in Firestore — user needs onboarding',
          tag: AppLogTags.curriculumCubit,
        );
        emit(state.copyWith(isLoading: false));
      }
    } catch (e, st) {
      AppLogger.error(
        'Failed to load curriculum from Firestore',
        tag: AppLogTags.curriculumCubit,
        error: e,
        stackTrace: st,
      );
      emit(state.copyWith(isLoading: false));
    }
  }

  /// Sets the curriculum after onboarding completion.
  ///
  /// Persists to Firestore and emits instantly for the UI.
  Future<void> setCurriculum({
    required String boardId,
    required String boardName,
    required String gradeId,
    required String gradeLabel,
    required int gradeNumber,
  }) async {
    AppLogger.info(
      'Setting curriculum: board=$boardName ($boardId), grade=$gradeLabel ($gradeId)',
      tag: AppLogTags.curriculumCubit,
    );

    final curriculum = SelectedCurriculum(
      boardId: boardId,
      boardName: boardName,
      gradeId: gradeId,
      gradeLabel: gradeLabel,
      gradeNumber: gradeNumber,
    );

    // Emit immediately for instant UI update.
    emit(state.copyWith(curriculum: curriculum));

    // Persist to Firestore.
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid != null) {
      try {
        await _firestore.collection('users').doc(uid).set(
          {
            'boardId': boardId,
            'boardName': boardName,
            'gradeId': gradeId,
            'gradeLabel': gradeLabel,
            'gradeNumber': gradeNumber,
          },
          SetOptions(merge: true),
        );
        AppLogger.info(
          'Curriculum persisted to Firestore',
          tag: AppLogTags.curriculumCubit,
        );
      } catch (e, st) {
        AppLogger.error(
          'Failed to persist curriculum to Firestore',
          tag: AppLogTags.curriculumCubit,
          error: e,
          stackTrace: st,
        );
      }
    }
  }

  /// Clears the curriculum (e.g. on logout).
  void clear() {
    AppLogger.debug(
      'Curriculum cleared',
      tag: AppLogTags.curriculumCubit,
    );
    emit(const CurriculumState());
  }
}
