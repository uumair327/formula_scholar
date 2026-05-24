import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import 'study_planner_state.dart';

@lazySingleton
class StudyPlannerCubit extends Cubit<StudyPlannerState>
    with CubitFailureLogger<StudyPlannerState> {
  StudyPlannerCubit({
    required GetPlansUseCase getPlans,
    required CreatePlanUseCase createPlan,
    required UpdatePlanUseCase updatePlan,
    required DeletePlanUseCase deletePlan,
    required UpdateSessionUseCase updateSession,
  }) : _getPlans = getPlans,
       _createPlan = createPlan,
       _updatePlan = updatePlan,
       _deletePlan = deletePlan,
       _updateSession = updateSession,
       super(const StudyPlannerState());

  @override
  String get logTag => AppLogTags.studyPlannerCubit;

  final GetPlansUseCase _getPlans;
  final CreatePlanUseCase _createPlan;
  final UpdatePlanUseCase _updatePlan;
  final DeletePlanUseCase _deletePlan;
  final UpdateSessionUseCase _updateSession;
  StreamSubscription<List<StudyPlan>>? _plansSub;

  void loadPlans(String userId) {
    emit(state.copyWith(status: StudyPlannerStatus.loading));
    _plansSub?.cancel();
    _plansSub = _getPlans(userId).listen(
      (plans) => emit(state.copyWith(
        status: StudyPlannerStatus.loaded,
        plans: plans,
      )),
      onError: (e) => emit(state.copyWith(
        status: StudyPlannerStatus.error,
        errorMessage: e.toString(),
      )),
    );
  }

  Future<void> createPlan({
    required String userId,
    required StudyPlan plan,
  }) async {
    emit(state.copyWith(status: StudyPlannerStatus.creating));
    final result = await _createPlan(userId: userId, plan: plan);
    if (isClosed) return;
    if (result is Error) {
      emit(state.copyWith(
        status: StudyPlannerStatus.error,
        errorMessage: result.failure.message,
      ));
    }
  }

  Future<void> updatePlan({
    required String userId,
    required StudyPlan plan,
  }) async {
    final result = await _updatePlan(userId: userId, plan: plan);
    if (isClosed) return;
    if (result is Error) {
      emit(state.copyWith(
        status: StudyPlannerStatus.error,
        errorMessage: result.failure.message,
      ));
    }
  }

  Future<void> deletePlan({
    required String userId,
    required String planId,
  }) async {
    final result = await _deletePlan(userId: userId, planId: planId);
    if (isClosed) return;
    if (result is Error) {
      emit(state.copyWith(
        status: StudyPlannerStatus.error,
        errorMessage: result.failure.message,
      ));
    }
  }

  Future<void> markSessionComplete({
    required String userId,
    required String planId,
    required String sessionId,
  }) async {
    final result = await _updateSession(
      userId: userId,
      planId: planId,
      sessionId: sessionId,
    );
    if (isClosed) return;
    if (result is Error) {
      emit(state.copyWith(
        status: StudyPlannerStatus.error,
        errorMessage: result.failure.message,
      ));
    }
  }

  void selectPlan(StudyPlan? plan) {
    emit(state.copyWith(selectedPlan: plan));
  }

  @override
  Future<void> close() {
    _plansSub?.cancel();
    return super.close();
  }
}
