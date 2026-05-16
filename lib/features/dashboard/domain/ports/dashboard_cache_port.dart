import '../entities/recent_study.dart';
import '../entities/study_progress.dart';
import '../entities/subject.dart';
import '../entities/weak_area.dart';
import '../models/announcement.dart';
import '../models/carousel_item.dart';

abstract interface class DashboardCachePort {
  Future<void> cacheStudyProgress(StudyProgress progress);

  Future<void> cacheSubjects(
    String boardId,
    String gradeId,
    List<Subject> subjects,
  );

  Future<void> cacheRecentStudies(List<RecentStudy> studies);

  Future<void> cacheBanners(List<CarouselItem> banners);

  Future<void> cacheAnnouncements(List<AppAnnouncement> announcements);

  Future<void> cacheWeakAreas(List<WeakArea> areas);

  Future<StudyProgress?> getStudyProgress();

  Future<List<Subject>> getSubjects(String boardId, String gradeId);

  Future<List<RecentStudy>> getRecentStudies();

  Future<List<CarouselItem>> getBanners();

  Future<List<AppAnnouncement>> getAnnouncements();

  Future<List<WeakArea>> getWeakAreas();
}
