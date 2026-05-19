import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../features/analytics/analytics.dart';
import '../../features/achievements/domain/domain.dart';
import '../../features/flashcards/flashcards.dart';
import '../../features/study_planner/study_planner.dart';
import 'injection.config.dart';

/// Global [GetIt] service locator instance.
///
/// Access registered dependencies anywhere in the app:
/// ```dart
/// final repo = getIt<DashboardRepositoryPort>();
/// ```
final GetIt getIt = GetIt.instance;

/// Configures all injectable dependencies.
///
/// Must be called once in `main()` before `runApp()`.
/// The generated `injection.config.dart` file contains
/// all registrations discovered by `injectable_generator`.
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() {
  getIt.init();

  // ─── Manual registrations for new features ──────────────────────
  // TODO: Remove after running build_runner

  // Analytics
  getIt.registerLazySingleton<AnalyticsDataSourcePort>(
    () => AnalyticsFirebaseAdapter(getIt<FirebaseFirestore>(), getIt<FirebaseAuth>()),
  );
  getIt.registerLazySingleton<AnalyticsCachePort>(
    () => AnalyticsHiveCache(),
  );
  getIt.registerLazySingleton<AnalyticsRepositoryPort>(
    () => AnalyticsRepositoryImpl(
      dataSource: getIt<AnalyticsDataSourcePort>(),
      cache: getIt<AnalyticsCachePort>(),
    ),
  );
  getIt.registerFactory<GetAnalyticsDataUseCase>(
    () => GetAnalyticsDataUseCase(repository: getIt<AnalyticsRepositoryPort>()),
  );
  getIt.registerFactory<AnalyticsCubit>(
    () => AnalyticsCubit(getAnalytics: getIt<GetAnalyticsDataUseCase>()),
  );

  // Flashcards
  getIt.registerFactory<LoadReviewsUseCase>(
    () => LoadReviewsUseCase(repository: getIt<FlashcardRepositoryPort>()),
  );
  getIt.registerFactory<SaveReviewUseCase>(
    () => SaveReviewUseCase(repository: getIt<FlashcardRepositoryPort>()),
  );
  getIt.registerFactory<FlashcardsCubit>(
    () => FlashcardsCubit(
      loadReviews: getIt<LoadReviewsUseCase>(),
      saveReview: getIt<SaveReviewUseCase>(),
      reportAchievement: getIt<ReportAchievementProgressUseCase>(),
    ),
  );

  // Study Planner
  getIt.registerLazySingleton<StudyPlannerCachePort>(
    () => StudyPlannerHiveCache(),
  );
  getIt.registerLazySingleton<StudyPlannerRepositoryPort>(
    () => StudyPlannerRepositoryImpl(
      dataSource: getIt<StudyPlannerPort>(),
      cache: getIt<StudyPlannerCachePort>(),
    ),
  );
  final repo = getIt<StudyPlannerRepositoryPort>();
  getIt.registerFactory<CreatePlanUseCase>(
    () => CreatePlanUseCase(repository: repo),
  );
  getIt.registerFactory<GetPlansUseCase>(
    () => GetPlansUseCase(repository: repo),
  );
  getIt.registerFactory<UpdatePlanUseCase>(
    () => UpdatePlanUseCase(repository: repo),
  );
  getIt.registerFactory<DeletePlanUseCase>(
    () => DeletePlanUseCase(repository: repo),
  );
  getIt.registerFactory<UpdateSessionUseCase>(
    () => UpdateSessionUseCase(repository: repo),
  );
  getIt.registerFactory<StudyPlannerCubit>(
    () => StudyPlannerCubit(
      getPlans: getIt<GetPlansUseCase>(),
      createPlan: getIt<CreatePlanUseCase>(),
      updatePlan: getIt<UpdatePlanUseCase>(),
      deletePlan: getIt<DeletePlanUseCase>(),
      updateSession: getIt<UpdateSessionUseCase>(),
    ),
  );
}
