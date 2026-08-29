import 'package:injectable/injectable.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

// @LazySingleton(as: DashboardDataSourcePort)
class DashboardApiAdapter implements DashboardDataSourcePort {
  final ApiClient _apiClient;

  DashboardApiAdapter(this._apiClient);

  @override
  Future<StudyProgress> getStudyProgress() async {
    // API endpoint doesn't exist yet for user progress.
    return const StudyProgress(
      masteryPercentage: 0,
      completedChapters: 0,
      totalChapters: 0,
    );
  }

  @override
  Future<List<Subject>> getSubjects(String boardId, String gradeId) async {
    // Scaffold API integration (if subjects ever move to REST). 
    // Currently, subjects aren't in formula_factory_openapi.yaml.
    AppLogger.warning('getSubjects via REST not fully supported', tag: AppLogTags.dashboardDataSource);
    return [];
  }

  @override
  Future<List<RecentStudy>> getRecentStudies() async {
    return [];
  }

  @override
  Future<List<CarouselItem>> getBanners() async {
    return [];
  }

  @override
  Future<List<AppAnnouncement>> getActiveAnnouncements() async {
    return [];
  }

  @override
  Future<List<WeakArea>> getWeakAreas() async {
    return [];
  }
}
