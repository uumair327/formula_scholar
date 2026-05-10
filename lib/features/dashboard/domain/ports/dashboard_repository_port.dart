import '../../../../core/error/result.dart';
import '../entities/study_progress.dart';
import '../entities/subject.dart';
import '../entities/recent_study.dart';
import '../models/announcement.dart';
import '../models/carousel_item.dart';

abstract interface class DashboardRepositoryPort {
  Future<Result<StudyProgress>> getStudyProgress();

  Future<Result<List<Subject>>> getSubjects(String boardId, String gradeId);

  Future<Result<List<RecentStudy>>> getRecentStudies();

  Future<Result<List<CarouselItem>>> getBanners();

  Future<Result<List<AppAnnouncement>>> getActiveAnnouncements();
}
