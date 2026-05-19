import '../entities/study_plan.dart';

abstract interface class StudyPlannerCachePort {
  Future<void> cachePlans(String userId, List<StudyPlan> plans);
  Future<List<StudyPlan>> getPlans(String userId);
}
