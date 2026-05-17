import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

import '../../features/flashcards/flashcards.dart';
import '../../features/achievements/achievements.dart';


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

  // ─── Manual registrations ───────────────────────────────────
  // Only register types that are NOT discovered by injectable_generator.
  // Types with @injectable / @lazySingleton annotations are auto-registered
  // by getIt.init() above via injection.config.dart.

  // Flashcards (no @injectable annotations yet)
  getIt.registerLazySingleton<FlashcardReviewPort>(
    () => FirestoreFlashcardReviewAdapter(getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<FlashcardCachePort>(
    () => FlashcardHiveCache(),
  );
  getIt.registerLazySingleton<FlashcardRepositoryPort>(
    () => FlashcardRepositoryImpl(
      dataSource: getIt<FlashcardReviewPort>(),
      cache: getIt<FlashcardCachePort>(),
    ),
  );
  getIt.registerFactory<FlashcardsCubit>(
    () => FlashcardsCubit(repository: getIt<FlashcardRepositoryPort>()),
  );

  // Achievements (no @injectable annotations yet)
  getIt.registerLazySingleton<AchievementDataSourcePort>(
    () => AchievementLocalDataSource(),
  );
  getIt.registerLazySingleton<AchievementCachePort>(
    () => AchievementHiveCache(),
  );
  getIt.registerLazySingleton<AchievementRepositoryPort>(
    () => AchievementRepositoryImpl(
      dataSource: getIt<AchievementDataSourcePort>(),
      cache: getIt<AchievementCachePort>(),
    ),
  );
  getIt.registerFactory<GetAchievementsUseCase>(
    () => GetAchievementsUseCase(repository: getIt<AchievementRepositoryPort>()),
  );
  getIt.registerFactory<ReportAchievementProgressUseCase>(
    () => ReportAchievementProgressUseCase(
      repository: getIt<AchievementRepositoryPort>(),
    ),
  );
  getIt.registerFactory<AchievementsCubit>(
    () => AchievementsCubit(
      getAchievements: getIt<GetAchievementsUseCase>(),
    ),
  );
}
