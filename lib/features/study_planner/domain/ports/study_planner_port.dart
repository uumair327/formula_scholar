import '../entities/study_plan.dart';

abstract class StudyPlannerPort {
  Stream<List<StudyPlan>> watchPlans(String userId);
  Future<void> createPlan({required String userId, required StudyPlan plan});
  Future<void> updatePlan({required String userId, required StudyPlan plan});
  Future<void> deletePlan({required String userId, required String planId});
  Future<void> updateSessionStatus({
    required String userId,
    required String planId,
    required String sessionId,
  });
}
