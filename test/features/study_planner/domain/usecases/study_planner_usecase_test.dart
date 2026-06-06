import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formula_scholar/core/error/failures.dart';
import 'package:formula_scholar/core/error/result.dart';
import 'package:formula_scholar/features/study_planner/domain/domain.dart';

void main() {
  group('CreatePlanUseCase', () {
    test('returns Success when repository succeeds', () async {
      final repo = _FakeStudyPlannerRepository();
      final useCase = CreatePlanUseCase(repository: repo);

      final result = await useCase(userId: 'u1', plan: _testPlan());

      expect(result, isA<Success<void>>());
    });

    test('returns Error when repository fails', () async {
      final repo = _FakeStudyPlannerRepository()..throwOnCreate = true;
      final useCase = CreatePlanUseCase(repository: repo);

      final result = await useCase(userId: 'u1', plan: _testPlan());

      expect(result, isA<Error<void>>());
    });
  });

  group('GetPlansUseCase', () {
    test('returns stream from repository', () async {
      final repo = _FakeStudyPlannerRepository();
      addTearDown(() => repo.plansController.close());
      final useCase = GetPlansUseCase(repository: repo);
      final plan = _testPlan();

      final plans = useCase('u1').first;
      repo.plansController.add([plan]);
      final result = await plans;

      expect(result, [plan]);
    });
  });

  group('UpdatePlanUseCase', () {
    test('returns Success when repository succeeds', () async {
      final repo = _FakeStudyPlannerRepository();
      final useCase = UpdatePlanUseCase(repository: repo);

      final result = await useCase(userId: 'u1', plan: _testPlan());

      expect(result, isA<Success<void>>());
    });

    test('returns Error when repository fails', () async {
      final repo = _FakeStudyPlannerRepository()..throwOnUpdate = true;
      final useCase = UpdatePlanUseCase(repository: repo);

      final result = await useCase(userId: 'u1', plan: _testPlan());

      expect(result, isA<Error<void>>());
    });
  });

  group('DeletePlanUseCase', () {
    test('returns Success when repository succeeds', () async {
      final repo = _FakeStudyPlannerRepository();
      final useCase = DeletePlanUseCase(repository: repo);

      final result = await useCase(userId: 'u1', planId: 'p1');

      expect(result, isA<Success<void>>());
    });

    test('returns Error when repository fails', () async {
      final repo = _FakeStudyPlannerRepository()..throwOnDelete = true;
      final useCase = DeletePlanUseCase(repository: repo);

      final result = await useCase(userId: 'u1', planId: 'p1');

      expect(result, isA<Error<void>>());
    });
  });

  group('UpdateSessionUseCase', () {
    test('returns Success when repository succeeds', () async {
      final repo = _FakeStudyPlannerRepository();
      final useCase = UpdateSessionUseCase(repository: repo);

      final result = await useCase(userId: 'u1', planId: 'p1', sessionId: 's1');

      expect(result, isA<Success<void>>());
    });

    test('returns Error when repository fails', () async {
      final repo = _FakeStudyPlannerRepository()..throwOnUpdateSession = true;
      final useCase = UpdateSessionUseCase(repository: repo);

      final result = await useCase(userId: 'u1', planId: 'p1', sessionId: 's1');

      expect(result, isA<Error<void>>());
    });
  });
}

StudyPlan _testPlan() => StudyPlan(
  id: 'p1',
  title: 'Test Plan',
  createdAt: DateTime(2024, 1, 1),
  updatedAt: DateTime(2024, 1, 1),
);

class _FakeStudyPlannerRepository implements StudyPlannerRepositoryPort {
  bool throwOnCreate = false;
  bool throwOnUpdate = false;
  bool throwOnDelete = false;
  bool throwOnUpdateSession = false;

  // ignore: close_sinks
  final plansController = StreamController<List<StudyPlan>>.broadcast();

  @override
  Stream<List<StudyPlan>> watchPlans(String userId) => plansController.stream;

  @override
  Future<void> createPlan({
    required String userId,
    required StudyPlan plan,
  }) async {
    if (throwOnCreate) {
      throw const ServerFailure(message: 'create failed');
    }
  }

  @override
  Future<void> updatePlan({
    required String userId,
    required StudyPlan plan,
  }) async {
    if (throwOnUpdate) {
      throw const ServerFailure(message: 'update failed');
    }
  }

  @override
  Future<void> deletePlan({
    required String userId,
    required String planId,
  }) async {
    if (throwOnDelete) {
      throw const ServerFailure(message: 'delete failed');
    }
  }

  @override
  Future<void> updateSessionStatus({
    required String userId,
    required String planId,
    required String sessionId,
    DocumentReference? transactionRef,
  }) async {
    if (throwOnUpdateSession) {
      throw const ServerFailure(message: 'updateSession failed');
    }
  }
}
