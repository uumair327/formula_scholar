import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formula_scholar/core/error/failures.dart';
import 'package:formula_scholar/core/error/result.dart';
import 'package:formula_scholar/features/auth/auth.dart';
import 'package:formula_scholar/features/study_planner/domain/domain.dart';
import 'package:formula_scholar/features/study_planner/presentation/cubit/study_planner_cubit.dart';
import 'package:formula_scholar/features/study_planner/presentation/cubit/study_planner_state.dart';

void main() {
  group('StudyPlannerCubit', () {
    late MockGetPlansUseCase getPlans;
    late MockCreatePlanUseCase createPlan;
    late MockUpdatePlanUseCase updatePlan;
    late MockDeletePlanUseCase deletePlan;
    late MockUpdateSessionUseCase updateSession;
    late _FakeAuthRepository authRepository;
    late AuthCubit authCubit;
    late StudyPlannerCubit cubit;

    setUp(() {
      getPlans = MockGetPlansUseCase();
      createPlan = MockCreatePlanUseCase();
      updatePlan = MockUpdatePlanUseCase();
      deletePlan = MockDeletePlanUseCase();
      updateSession = MockUpdateSessionUseCase();
      authRepository = _FakeAuthRepository();
      authCubit = AuthCubit(
        signIn: SignInUseCase(authRepository),
        signUp: SignUpUseCase(authRepository),
        signOut: SignOutUseCase(authRepository),
        googleSignIn: GoogleSignInUseCase(authRepository),
        watchAuthState: WatchAuthStateUseCase(authRepository),
        deleteAccount: DeleteAccountUseCase(authRepository),
        forgotPassword: ForgotPasswordUseCase(authRepository),
      );
      cubit = StudyPlannerCubit(
        getPlans: getPlans,
        createPlan: createPlan,
        updatePlan: updatePlan,
        deletePlan: deletePlan,
        updateSession: updateSession,
        authCubit: authCubit,
      );
    });

    tearDown(() async {
      await cubit.close();
      await authCubit.close();
      await authRepository.dispose();
      getPlans.dispose();
    });

    test('initial state is StudyPlannerStatus.initial', () {
      expect(cubit.state.status, StudyPlannerStatus.initial);
      expect(cubit.state.plans, isEmpty);
    });

    test('loadPlans emits loading then loaded with plans', () async {
      final plan = _testPlan();

      final future = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<StudyPlannerState>(
            (s) => s.status == StudyPlannerStatus.loading,
          ),
          predicate<StudyPlannerState>(
            (s) =>
                s.status == StudyPlannerStatus.loaded &&
                s.plans.length == 1 &&
                s.plans.first == plan,
          ),
        ]),
      );

      cubit.loadPlans('u1');
      getPlans.controller.add([plan]);

      await future;
    });

    test('loadPlans emits error when stream fails', () async {
      final future = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<StudyPlannerState>(
            (s) => s.status == StudyPlannerStatus.loading,
          ),
          predicate<StudyPlannerState>(
            (s) =>
                s.status == StudyPlannerStatus.error &&
                s.errorMessage == 'stream error',
          ),
        ]),
      );

      cubit.loadPlans('u1');
      getPlans.controller.addError('stream error');

      await future;
    });

    test(
      'auth state change triggers loadPlans for authenticated user',
      () async {
        final plan = _testPlan();

        final future = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<StudyPlannerState>(
              (s) => s.status == StudyPlannerStatus.loading,
            ),
            predicate<StudyPlannerState>(
              (s) =>
                  s.status == StudyPlannerStatus.loaded &&
                  s.plans.length == 1 &&
                  s.plans.first == plan,
            ),
          ]),
        );

        authRepository.emitUser(const AuthUser(uid: 'u1'));
        await Future<void>.delayed(Duration.zero);
        getPlans.controller.add([plan]);

        await future;
      },
    );

    test('createPlan does not emit error on success', () async {
      createPlan.result = const Success<void>(null);
      final plan = _testPlan();

      await cubit.createPlan(userId: 'u1', plan: plan);

      expect(createPlan.callCount, 1);
    });

    test('createPlan emits error on failure', () async {
      createPlan.result = const Error<void>(
        ServerFailure(message: 'create failed'),
      );

      await cubit.createPlan(userId: 'u1', plan: _testPlan());

      expect(cubit.state.status, StudyPlannerStatus.error);
      expect(cubit.state.errorMessage, 'create failed');
    });

    test('updatePlan does not emit error on success', () async {
      updatePlan.result = const Success<void>(null);
      final plan = _testPlan();

      await cubit.updatePlan(userId: 'u1', plan: plan);

      expect(updatePlan.callCount, 1);
    });

    test('updatePlan emits error on failure', () async {
      updatePlan.result = const Error<void>(
        ServerFailure(message: 'update failed'),
      );

      await cubit.updatePlan(userId: 'u1', plan: _testPlan());

      expect(cubit.state.status, StudyPlannerStatus.error);
      expect(cubit.state.errorMessage, 'update failed');
    });

    test('deletePlan does not emit error on success', () async {
      deletePlan.result = const Success<void>(null);

      await cubit.deletePlan(userId: 'u1', planId: 'p1');

      expect(deletePlan.callCount, 1);
    });

    test('deletePlan emits error on failure', () async {
      deletePlan.result = const Error<void>(
        ServerFailure(message: 'delete failed'),
      );

      await cubit.deletePlan(userId: 'u1', planId: 'p1');

      expect(cubit.state.status, StudyPlannerStatus.error);
      expect(cubit.state.errorMessage, 'delete failed');
    });

    test('markSessionComplete does not emit error on success', () async {
      updateSession.result = const Success<void>(null);

      await cubit.markSessionComplete(
        userId: 'u1',
        planId: 'p1',
        sessionId: 's1',
      );

      expect(updateSession.callCount, 1);
    });

    test('markSessionComplete emits error on failure', () async {
      updateSession.result = const Error<void>(
        ServerFailure(message: 'session failed'),
      );

      await cubit.markSessionComplete(
        userId: 'u1',
        planId: 'p1',
        sessionId: 's1',
      );

      expect(cubit.state.status, StudyPlannerStatus.error);
      expect(cubit.state.errorMessage, 'session failed');
    });

    test('selectPlan sets selectedPlan', () {
      final plan = _testPlan();
      cubit.selectPlan(plan);

      expect(cubit.state.selectedPlan, plan);
    });
  });
}

StudyPlan _testPlan() => StudyPlan(
  id: 'p1',
  title: 'Test Plan',
  createdAt: DateTime(2024, 1, 1),
  updatedAt: DateTime(2024, 1, 1),
);

class _FakeRepository implements StudyPlannerRepositoryPort {
  @override
  Stream<List<StudyPlan>> watchPlans(String userId) => const Stream.empty();

  @override
  Future<void> createPlan({
    required String userId,
    required StudyPlan plan,
  }) async {}

  @override
  Future<void> updatePlan({
    required String userId,
    required StudyPlan plan,
  }) async {}

  @override
  Future<void> deletePlan({
    required String userId,
    required String planId,
  }) async {}

  @override
  Future<void> updateSessionStatus({
    required String userId,
    required String planId,
    required String sessionId,
    SessionStatus? status,
    DocumentReference? transactionRef,
  }) async {}
}

class _FakeAuthRepository implements AuthRepositoryPort {
  final StreamController<AuthUser?> _controller =
      StreamController<AuthUser?>.broadcast();

  void emitUser(AuthUser? user) => _controller.add(user);

  Future<void> dispose() async {
    await _controller.close();
  }

  @override
  AuthUser? get currentUser => null;

  @override
  Stream<AuthUser?> authStateChanges() => _controller.stream;

  @override
  Future<Result<void>> deleteAccount() async => const Success<void>(null);

  @override
  Future<Result<void>> sendPasswordResetEmail({required String email}) async =>
      const Success<void>(null);

  @override
  Future<Result<AuthUser>> signInWithGoogle() async =>
      const Error<AuthUser>(ServerFailure(message: 'not used in test'));

  @override
  Future<Result<AuthUser>> signIn({
    required String email,
    required String password,
  }) async => const Error<AuthUser>(ServerFailure(message: 'not used in test'));

  @override
  Future<Result<AuthUser>> signUp({
    required String name,
    required String email,
    required String password,
  }) async => const Error<AuthUser>(ServerFailure(message: 'not used in test'));

  @override
  Future<Result<void>> signOut() async => const Success<void>(null);
}

class MockGetPlansUseCase extends GetPlansUseCase {
  MockGetPlansUseCase() : super(repository: _FakeRepository());

  final controller = StreamController<List<StudyPlan>>.broadcast();

  @override
  Stream<List<StudyPlan>> call(String userId) => controller.stream;

  void dispose() => controller.close();
}

class MockCreatePlanUseCase extends CreatePlanUseCase {
  MockCreatePlanUseCase() : super(repository: _FakeRepository());

  int callCount = 0;
  Result<void> result = const Success<void>(null);

  @override
  Future<Result<void>> call({
    required String userId,
    required StudyPlan plan,
  }) async {
    callCount++;
    return result;
  }
}

class MockUpdatePlanUseCase extends UpdatePlanUseCase {
  MockUpdatePlanUseCase() : super(repository: _FakeRepository());

  int callCount = 0;
  Result<void> result = const Success<void>(null);

  @override
  Future<Result<void>> call({
    required String userId,
    required StudyPlan plan,
  }) async {
    callCount++;
    return result;
  }
}

class MockDeletePlanUseCase extends DeletePlanUseCase {
  MockDeletePlanUseCase() : super(repository: _FakeRepository());

  int callCount = 0;
  Result<void> result = const Success<void>(null);

  @override
  Future<Result<void>> call({
    required String userId,
    required String planId,
  }) async {
    callCount++;
    return result;
  }
}

class MockUpdateSessionUseCase extends UpdateSessionUseCase {
  MockUpdateSessionUseCase() : super(repository: _FakeRepository());

  int callCount = 0;
  Result<void> result = const Success<void>(null);

  @override
  Future<Result<void>> call({
    required String userId,
    required String planId,
    required String sessionId,
    SessionStatus? status,
    DocumentReference? transactionRef,
  }) async {
    callCount++;
    return result;
  }
}
