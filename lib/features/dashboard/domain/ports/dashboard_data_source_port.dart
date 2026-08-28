import '../entities/study_progress.dart';
import '../entities/subject.dart';
import '../entities/recent_study.dart';
import '../entities/weak_area.dart';
import '../entities/announcement.dart';
import '../entities/carousel_item.dart';

/// Port: Defines the contract that any backend adapter must implement.
abstract interface class DashboardDataSourcePort {
  Future<StudyProgress> getStudyProgress();

  Future<List<Subject>> getSubjects(String boardId, String gradeId);

  Future<List<RecentStudy>> getRecentStudies();

  Future<List<CarouselItem>> getBanners();

  Future<List<AppAnnouncement>> getActiveAnnouncements();

  /// Aggregates quiz answer records into weakness scores per category.
  Future<List<WeakArea>> getWeakAreas();
}
