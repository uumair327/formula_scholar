import '../entities/recent_study.dart';
import '../entities/study_progress.dart';
import '../entities/subject.dart';

abstract interface class DashboardCachePort {
  Future<void> cacheStudyProgress(StudyProgress progress);

  Future<void> cacheSubjects(
    String boardId,
    String gradeId,
    List<Subject> subjects,
  );

  Future<void> cacheRecentStudies(List<RecentStudy> studies);

  Future<StudyProgress?> getStudyProgress();

  Future<List<Subject>> getSubjects(String boardId, String gradeId);

  Future<List<RecentStudy>> getRecentStudies();
}
