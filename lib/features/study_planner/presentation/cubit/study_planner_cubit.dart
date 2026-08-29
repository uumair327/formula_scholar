import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../../auth/auth.dart';
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
    required AuthCubit authCubit,
  }) : _getPlans = getPlans,
       _createPlan = createPlan,
       _updatePlan = updatePlan,
       _deletePlan = deletePlan,
       _updateSession = updateSession,
       _authCubit = authCubit,
       super(const StudyPlannerState()) {
    _authSubscription = _authCubit.stream.listen(_handleAuthState);
    _handleAuthState(_authCubit.state);
  }

  @override
  String get logTag => AppLogTags.studyPlannerCubit;

  final GetPlansUseCase _getPlans;
  final CreatePlanUseCase _createPlan;
  final UpdatePlanUseCase _updatePlan;
  final DeletePlanUseCase _deletePlan;
  final UpdateSessionUseCase _updateSession;
  final AuthCubit _authCubit;
  StreamSubscription<AuthState>? _authSubscription;
  StreamSubscription<List<StudyPlan>>? _plansSub;
  String? _activeUserId;

  void _handleAuthState(AuthState state) {
    final userId = state.user?.uid;
    if (userId == null) {
      _activeUserId = null;
      _plansSub?.cancel();
      _plansSub = null;
      emit(const StudyPlannerState());
      return;
    }

    if (_activeUserId == userId && state.status != AuthStatus.unauthenticated) {
      return;
    }

    _activeUserId = userId;
    loadPlans(userId);
  }

  void loadPlans(String userId) {
    _activeUserId = userId;
    emit(state.copyWith(status: StudyPlannerStatus.loading));
    _plansSub?.cancel();
    _plansSub = _getPlans(userId).listen(
      (plans) =>
          emit(state.copyWith(status: StudyPlannerStatus.loaded, plans: plans)),
      onError: (e) => emit(
        state.copyWith(
          status: StudyPlannerStatus.error,
          errorMessage: e.toString(),
        ),
      ),
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
      emit(
        state.copyWith(
          status: StudyPlannerStatus.error,
          errorMessage: result.failure.message,
        ),
      );
    }
  }

  Future<void> updatePlan({
    required String userId,
    required StudyPlan plan,
  }) async {
    final result = await _updatePlan(userId: userId, plan: plan);
    if (isClosed) return;
    if (result is Error) {
      emit(
        state.copyWith(
          status: StudyPlannerStatus.error,
          errorMessage: result.failure.message,
        ),
      );
    }
  }

  Future<void> deletePlan({
    required String userId,
    required String planId,
  }) async {
    final result = await _deletePlan(userId: userId, planId: planId);
    if (isClosed) return;
    if (result is Error) {
      emit(
        state.copyWith(
          status: StudyPlannerStatus.error,
          errorMessage: result.failure.message,
        ),
      );
    }
  }

  Future<void> updateSessionStatus({
    required String userId,
    required String planId,
    required String sessionId,
    SessionStatus? status,
  }) async {
    final result = await _updateSession(
      userId: userId,
      planId: planId,
      sessionId: sessionId,
      status: status,
    );
    if (isClosed) return;
    if (result is Error) {
      emit(
        state.copyWith(
          status: StudyPlannerStatus.error,
          errorMessage: result.failure.message,
        ),
      );
    }
  }

  Future<void> markSessionComplete({
    required String userId,
    required String planId,
    required String sessionId,
  }) => updateSessionStatus(
    userId: userId,
    planId: planId,
    sessionId: sessionId,
    status: SessionStatus.completed,
  );

  void selectPlan(StudyPlan? plan) {
    emit(state.copyWith(selectedPlan: plan));
  }

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    await _plansSub?.cancel();
    return super.close();
  }
}
