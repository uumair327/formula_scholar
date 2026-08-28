import '../../../../core/error/result.dart';
import '../entities/study_progress.dart';
import '../entities/subject.dart';
import '../entities/recent_study.dart';
import '../entities/weak_area.dart';
import '../entities/announcement.dart';
import '../entities/carousel_item.dart';

abstract interface class DashboardRepositoryPort {
  Future<Result<StudyProgress>> getStudyProgress();

  Future<Result<List<Subject>>> getSubjects(String boardId, String gradeId);

  Future<Result<List<RecentStudy>>> getRecentStudies();

  Future<Result<List<CarouselItem>>> getBanners();

  Future<Result<List<AppAnnouncement>>> getActiveAnnouncements();

  /// Aggregates quiz answer records into weakness scores per category.
  Future<Result<List<WeakArea>>> getWeakAreas();
}
