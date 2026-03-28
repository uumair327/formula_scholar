import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Local adapter: returns hardcoded data for development/offline use.
///
/// This is a **driven adapter** in hexagonal terminology — it implements
/// the [DashboardDataSourcePort] defined in the domain layer.
///
/// To swap to Firebase/Supabase, create a new adapter implementing
/// [DashboardDataSourcePort] and update the DI registration.
@LazySingleton(as: DashboardDataSourcePort)
class DashboardLocalAdapter implements DashboardDataSourcePort {
  @override
  Future<StudyProgress> getStudyProgress() async {
    AppLogger.trace(
      'getStudyProgress() fetching local data',
      tag: AppLogTags.dashboardDataSource,
    );
    return const StudyProgress(
      masteryPercentage: 65,
      completedChapters: 14,
      totalChapters: 22,
    );
  }

  @override
  Future<List<Subject>> getSubjects() async {
    AppLogger.trace(
      'getSubjects() fetching local data',
      tag: AppLogTags.dashboardDataSource,
    );
    return const [
      Subject(
        id: 'math',
        name: AppStrings.numberSystemsGeometry,
        description: AppStrings.mathCardDescription,
        category: AppStrings.mathematics,
        imageUrl: AppAssets.mathSubjectImageUrl,
        unitCount: 8,
        formulaCount: 124,
      ),
      Subject(
        id: 'physics',
        name: AppStrings.physics,
        description: AppStrings.physicsDesc,
        category: AppStrings.science,
        imageUrl: '',
        unitCount: 6,
        formulaCount: 89,
      ),
      Subject(
        id: 'chemistry',
        name: AppStrings.chemistry,
        description: AppStrings.chemistryDesc,
        category: AppStrings.science,
        imageUrl: '',
        unitCount: 5,
        formulaCount: 67,
      ),
    ];
  }

  @override
  Future<List<RecentStudy>> getRecentStudies() async {
    AppLogger.trace(
      'getRecentStudies() fetching local data',
      tag: AppLogTags.dashboardDataSource,
    );
    return const [
      RecentStudy(
        id: '1',
        title: AppStrings.pythagoreanTheorem,
        subject: AppStrings.geometry,
        lastViewed: AppStrings.twoHoursAgo,
      ),
      RecentStudy(
        id: '2',
        title: AppStrings.newtonsThirdLaw,
        subject: AppStrings.physics,
        lastViewed: AppStrings.yesterday,
      ),
    ];
  }
}
