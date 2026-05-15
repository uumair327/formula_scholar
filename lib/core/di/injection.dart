import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

import '../../features/flashcards/presentation/cubit/flashcards_cubit.dart';
import '../../features/search/domain/ports/search_data_source_port.dart';
import '../../features/search/domain/ports/search_repository_port.dart';
import '../../features/search/domain/usecases/search_formulas_use_case.dart';
import '../../features/search/infrastructure/adapters/search_firebase_adapter.dart';
import '../../features/search/infrastructure/repositories/search_repository_impl.dart';
import '../../features/search/presentation/cubit/search_cubit.dart';
import '../../features/comparison/presentation/cubit/comparison_cubit.dart';
import '../../features/achievements/presentation/cubit/achievements_cubit.dart';
import '../../features/study_planner/domain/usecases/create_plan_usecase.dart';
import '../../features/study_planner/domain/usecases/get_plans_usecase.dart';
import '../../features/study_planner/domain/usecases/delete_plan_usecase.dart';
import '../../features/study_planner/domain/usecases/update_session_usecase.dart';
import '../../features/study_planner/domain/ports/study_planner_port.dart';
import '../../features/study_planner/infrastructure/adapters/firestore_study_planner_adapter.dart';
import '../../features/study_planner/presentation/cubit/study_planner_cubit.dart';
import '../../features/saved/domain/usecases/add_note_use_case.dart';
import '../../features/saved/domain/usecases/delete_note_use_case.dart';
import '../../features/saved/domain/usecases/update_note_use_case.dart';

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

  // ─── Manual registrations for new features ──────────────────
  // TODO: Remove after running build_runner

  // Search
  getIt.registerLazySingleton<SearchDataSourcePort>(
    () => SearchFirebaseAdapter(getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<SearchRepositoryPort>(
    () => SearchRepositoryImpl(dataSource: getIt<SearchDataSourcePort>()),
  );
  getIt.registerFactory<SearchFormulasUseCase>(
    () => SearchFormulasUseCase(repository: getIt<SearchRepositoryPort>()),
  );
  getIt.registerFactory<SearchCubit>(
    () => SearchCubit(searchFormulas: getIt<SearchFormulasUseCase>()),
  );

  // Notes
  getIt.registerFactory<AddNoteUseCase>(
    () => AddNoteUseCase(repository: getIt()),
  );
  getIt.registerFactory<UpdateNoteUseCase>(
    () => UpdateNoteUseCase(repository: getIt()),
  );
  getIt.registerFactory<DeleteNoteUseCase>(
    () => DeleteNoteUseCase(repository: getIt()),
  );

  // Flashcards
  getIt.registerFactory<FlashcardsCubit>(() => FlashcardsCubit());

  // Comparison
  getIt.registerFactory<ComparisonCubit>(() => ComparisonCubit());

  // Achievements
  getIt.registerFactory<AchievementsCubit>(() => AchievementsCubit());

  // Study Planner
  getIt.registerLazySingleton<StudyPlannerPort>(
    () => FirestoreStudyPlannerAdapter(getIt<FirebaseFirestore>()),
  );
  getIt.registerFactory<CreatePlanUseCase>(
    () => CreatePlanUseCase(port: getIt<StudyPlannerPort>()),
  );
  getIt.registerFactory<GetPlansUseCase>(
    () => GetPlansUseCase(port: getIt<StudyPlannerPort>()),
  );
  getIt.registerFactory<DeletePlanUseCase>(
    () => DeletePlanUseCase(port: getIt<StudyPlannerPort>()),
  );
  getIt.registerFactory<UpdateSessionUseCase>(
    () => UpdateSessionUseCase(port: getIt<StudyPlannerPort>()),
  );
  getIt.registerFactory<StudyPlannerCubit>(
    () => StudyPlannerCubit(
      getPlans: getIt<GetPlansUseCase>(),
      createPlan: getIt<CreatePlanUseCase>(),
      deletePlan: getIt<DeletePlanUseCase>(),
      updateSession: getIt<UpdateSessionUseCase>(),
    ),
  );
}
