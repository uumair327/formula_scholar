import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

@LazySingleton(as: StudyPlannerRepositoryPort)
class StudyPlannerRepositoryImpl implements StudyPlannerRepositoryPort {
  const StudyPlannerRepositoryImpl({
    required StudyPlannerPort dataSource,
    required StudyPlannerCachePort cache,
  }) : _dataSource = dataSource,
       _cache = cache;

  final StudyPlannerPort _dataSource;
  final StudyPlannerCachePort _cache;

  @override
  Stream<List<StudyPlan>> watchPlans(String userId) {
    AppLogger.trace('watchPlans($userId) subscribing to stream',
        tag: AppLogTags.studyPlannerRepo);
    return _dataSource.watchPlans(userId).transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          _cache.cachePlans(userId, data);
          sink.add(data);
        },
        handleError: (error, stackTrace, sink) async {
          AppLogger.error(
            'watchPlans($userId) stream error',
            tag: AppLogTags.studyPlannerRepo,
            error: error,
            stackTrace: stackTrace,
          );
          final cached = await _cache.getPlans(userId);
          if (cached.isNotEmpty) {
            AppLogger.warning(
              'watchPlans($userId) using cached fallback',
              tag: AppLogTags.studyPlannerRepo,
            );
            sink.add(cached);
          } else {
            sink.addError(error, stackTrace);
          }
        },
      ),
    );
  }

  @override
  Future<void> createPlan({required String userId, required StudyPlan plan}) async {
    final result = await safeOperation(
      tag: AppLogTags.studyPlannerRepo,
      operation: 'createPlan($userId, ${plan.id})',
      execute: () => _dataSource.createPlan(userId: userId, plan: plan),
    );
    if (result is Error) throw result.failure;
  }

  @override
  Future<void> updatePlan({required String userId, required StudyPlan plan}) async {
    final result = await safeOperation(
      tag: AppLogTags.studyPlannerRepo,
      operation: 'updatePlan($userId, ${plan.id})',
      execute: () => _dataSource.updatePlan(userId: userId, plan: plan),
    );
    if (result is Error) throw result.failure;
  }

  @override
  Future<void> deletePlan({required String userId, required String planId}) async {
    final result = await safeOperation(
      tag: AppLogTags.studyPlannerRepo,
      operation: 'deletePlan($userId, $planId)',
      execute: () => _dataSource.deletePlan(userId: userId, planId: planId),
    );
    if (result is Error) throw result.failure;
  }

  @override
  Future<void> updateSessionStatus({
    required String userId,
    required String planId,
    required String sessionId,
    DocumentReference? transactionRef,
  }) async {
    final result = await safeOperation(
      tag: AppLogTags.studyPlannerRepo,
      operation: 'updateSessionStatus($userId, $planId, $sessionId)',
      execute: () => _dataSource.updateSessionStatus(
        userId: userId,
        planId: planId,
        sessionId: sessionId,
        transactionRef: transactionRef,
      ),
    );
    if (result is Error) throw result.failure;
  }
}
