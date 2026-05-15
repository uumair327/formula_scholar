// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/domain/domain.dart' as _i140;
import '../../features/auth/domain/ports/auth_repository_port.dart' as _i320;
import '../../features/auth/domain/usecases/delete_account_use_case.dart'
    as _i519;
import '../../features/auth/domain/usecases/forgot_password_use_case.dart'
    as _i18;
import '../../features/auth/domain/usecases/get_current_auth_user_use_case.dart'
    as _i155;
import '../../features/auth/domain/usecases/google_sign_in_use_case.dart'
    as _i946;
import '../../features/auth/domain/usecases/sign_in_use_case.dart' as _i362;
import '../../features/auth/domain/usecases/sign_out_use_case.dart' as _i580;
import '../../features/auth/domain/usecases/sign_up_use_case.dart' as _i1037;
import '../../features/auth/domain/usecases/watch_auth_state_use_case.dart'
    as _i873;
import '../../features/auth/infrastructure/adapters/auth_firebase_adapter.dart'
    as _i117;
import '../../features/auth/infrastructure/repositories/auth_repository_impl.dart'
    as _i748;
import '../../features/auth/presentation/cubit/auth_cubit.dart' as _i117;
import '../../features/chapters/domain/domain.dart' as _i750;
import '../../features/chapters/domain/ports/chapters_repository_port.dart'
    as _i49;
import '../../features/chapters/domain/ports/formulas_repository_port.dart'
    as _i193;
import '../../features/chapters/domain/usecases/get_chapters_use_case.dart'
    as _i826;
import '../../features/chapters/domain/usecases/get_formulas_use_case.dart'
    as _i384;
import '../../features/chapters/domain/usecases/get_mastery_tools_use_case.dart'
    as _i953;
import '../../features/chapters/domain/usecases/toggle_bookmark_use_case.dart'
    as _i614;
import '../../features/chapters/infrastructure/adapters/chapters_firebase_adapter.dart'
    as _i560;
import '../../features/chapters/infrastructure/adapters/formulas_firebase_adapter.dart'
    as _i822;
import '../../features/chapters/infrastructure/repositories/chapters_hive_cache.dart'
    as _i927;
import '../../features/chapters/infrastructure/repositories/chapters_repository_impl.dart'
    as _i198;
import '../../features/chapters/infrastructure/repositories/formulas_hive_cache.dart'
    as _i682;
import '../../features/chapters/infrastructure/repositories/formulas_repository_impl.dart'
    as _i164;
import '../../features/chapters/presentation/cubit/chapters_cubit.dart'
    as _i919;
import '../../features/chapters/presentation/cubit/formulas_cubit.dart'
    as _i883;
import '../../features/dashboard/domain/domain.dart' as _i95;
import '../../features/dashboard/domain/ports/dashboard_repository_port.dart'
    as _i190;
import '../../features/dashboard/domain/usecases/get_announcements_use_case.dart'
    as _i996;
import '../../features/dashboard/domain/usecases/get_banners_use_case.dart'
    as _i273;
import '../../features/dashboard/domain/usecases/get_recent_studies_use_case.dart'
    as _i834;
import '../../features/dashboard/domain/usecases/get_study_progress_use_case.dart'
    as _i1065;
import '../../features/dashboard/domain/usecases/get_subjects_use_case.dart'
    as _i603;
import '../../features/dashboard/infrastructure/adapters/dashboard_firebase_adapter.dart'
    as _i72;
import '../../features/dashboard/infrastructure/repositories/dashboard_hive_cache.dart'
    as _i990;
import '../../features/dashboard/infrastructure/repositories/dashboard_repository_impl.dart'
    as _i367;
import '../../features/dashboard/presentation/cubit/dashboard_cubit.dart'
    as _i24;
import '../../features/onboarding/domain/domain.dart' as _i634;
import '../../features/onboarding/domain/usecases/get_boards_use_case.dart'
    as _i543;
import '../../features/onboarding/domain/usecases/get_countries_use_case.dart'
    as _i733;
import '../../features/onboarding/domain/usecases/get_grades_use_case.dart'
    as _i1005;
import '../../features/onboarding/domain/usecases/get_states_use_case.dart'
    as _i509;
import '../../features/onboarding/infrastructure/adapters/onboarding_firebase_adapter.dart'
    as _i985;
import '../../features/onboarding/infrastructure/repositories/onboarding_repository_impl.dart'
    as _i224;
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart'
    as _i807;
import '../../features/practice/domain/domain.dart' as _i899;
import '../../features/practice/domain/ports/practice_repository_port.dart'
    as _i1061;
import '../../features/practice/domain/usecases/get_questions_use_case.dart'
    as _i525;
import '../../features/practice/domain/usecases/record_quiz_completion_use_case.dart'
    as _i813;
import '../../features/practice/infrastructure/adapters/practice_firebase_adapter.dart'
    as _i660;
import '../../features/practice/infrastructure/repositories/practice_hive_cache.dart'
    as _i149;
import '../../features/practice/infrastructure/repositories/practice_repository_impl.dart'
    as _i426;
import '../../features/practice/presentation/cubit/practice_cubit.dart'
    as _i411;
import '../../features/profile/domain/domain.dart' as _i193;
import '../../features/profile/domain/ports/profile_repository_port.dart'
    as _i50;
import '../../features/profile/domain/usecases/get_notification_preferences_use_case.dart'
    as _i627;
import '../../features/profile/domain/usecases/get_profile_stats_use_case.dart'
    as _i539;
import '../../features/profile/domain/usecases/get_settings_items_use_case.dart'
    as _i657;
import '../../features/profile/domain/usecases/get_user_profile_use_case.dart'
    as _i105;
import '../../features/profile/domain/usecases/update_notification_preferences_use_case.dart'
    as _i1012;
import '../../features/profile/domain/usecases/update_profile_use_case.dart'
    as _i540;
import '../../features/profile/domain/usecases/update_study_goal_use_case.dart'
    as _i401;
import '../../features/profile/infrastructure/adapters/profile_firebase_adapter.dart'
    as _i943;
import '../../features/profile/infrastructure/repositories/profile_hive_cache.dart'
    as _i700;
import '../../features/profile/infrastructure/repositories/profile_repository_impl.dart'
    as _i244;
import '../../features/profile/presentation/cubit/notifications_cubit.dart'
    as _i153;
import '../../features/profile/presentation/cubit/profile_cubit.dart' as _i36;
import '../../features/saved/domain/domain.dart' as _i385;
import '../../features/saved/domain/ports/saved_repository_port.dart' as _i793;
import '../../features/saved/domain/usecases/get_bookmarks_use_case.dart'
    as _i527;
import '../../features/saved/domain/usecases/get_saved_chapters_use_case.dart'
    as _i87;
import '../../features/saved/domain/usecases/get_saved_notes_use_case.dart'
    as _i873;
import '../../features/saved/domain/usecases/remove_bookmark_use_case.dart'
    as _i221;
import '../../features/saved/domain/usecases/remove_saved_chapter_use_case.dart'
    as _i174;
import '../../features/saved/infrastructure/adapters/saved_firebase_adapter.dart'
    as _i1050;
import '../../features/saved/infrastructure/repositories/saved_hive_cache.dart'
    as _i827;
import '../../features/saved/infrastructure/repositories/saved_repository_impl.dart'
    as _i79;
import '../../features/saved/presentation/cubit/saved_cubit.dart' as _i712;
import '../../shared/cubit/activity_refresh_cubit.dart' as _i64;
import '../../shared/cubit/curriculum_cubit.dart' as _i427;
import '../../shared/cubit/subject_selection_cubit.dart' as _i414;
import '../../shared/cubit/theme_cubit.dart' as _i947;
import '../../shared/domain/domain.dart' as _i525;
import '../../shared/domain/ports/curriculum_repository_port.dart' as _i1064;
import '../../shared/domain/ports/theme_preference_repository_port.dart'
    as _i327;
import '../../shared/domain/usecases/load_curriculum_use_case.dart' as _i1052;
import '../../shared/domain/usecases/load_theme_preference_use_case.dart'
    as _i847;
import '../../shared/domain/usecases/save_curriculum_use_case.dart' as _i1048;
import '../../shared/domain/usecases/save_theme_preference_use_case.dart'
    as _i317;
import '../../shared/domain/usecases/watch_curriculum_use_case.dart' as _i264;
import '../../shared/domain/usecases/watch_theme_preference_use_case.dart'
    as _i287;
import '../../shared/infrastructure/adapters/curriculum_firebase_adapter.dart'
    as _i303;
import '../../shared/infrastructure/adapters/theme_preference_firebase_adapter.dart'
    as _i230;
import '../../shared/infrastructure/repositories/curriculum_repository_impl.dart'
    as _i588;
import '../../shared/infrastructure/repositories/theme_preference_repository_impl.dart'
    as _i436;
import '../../shared/shared.dart' as _i914;
import '../network/api_client.dart' as _i557;
import '../network/api_interceptor.dart' as _i724;
import '../network/connectivity_network_info.dart' as _i105;
import '../network/network_info_port.dart' as _i159;
import '../network/retry_interceptor.dart' as _i10;
import 'firebase_module.dart' as _i616;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final firebaseModule = _$FirebaseModule();
    gh.factory<_i724.ApiInterceptor>(() => _i724.ApiInterceptor());
    gh.lazySingleton<_i59.FirebaseAuth>(() => firebaseModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => firebaseModule.firestore);
    gh.lazySingleton<_i116.GoogleSignIn>(() => firebaseModule.googleSignIn);
    gh.lazySingleton<_i895.Connectivity>(() => firebaseModule.connectivity);
    gh.lazySingleton<_i64.ActivityRefreshCubit>(
      () => _i64.ActivityRefreshCubit(),
    );
    gh.lazySingleton<_i899.PracticeCachePort>(() => _i149.PracticeHiveCache());
    gh.lazySingleton<_i750.ChaptersCachePort>(() => _i927.ChaptersHiveCache());
    gh.lazySingleton<_i385.SavedCachePort>(() => _i827.SavedHiveCache());
    gh.lazySingleton<_i95.DashboardCachePort>(() => _i990.DashboardHiveCache());
    gh.factory<_i10.RetryInterceptor>(
      () => _i10.RetryInterceptor(
        maxRetries: gh<int>(),
        baseDelay: gh<Duration>(),
      ),
    );
    gh.lazySingleton<_i750.FormulasCachePort>(() => _i682.FormulasHiveCache());
    gh.lazySingleton<_i193.ProfileCachePort>(() => _i700.ProfileHiveCache());
    gh.lazySingleton<_i557.ApiClient>(
      () => _i557.ApiClient(
        gh<_i724.ApiInterceptor>(),
        gh<_i10.RetryInterceptor>(),
      ),
    );
    gh.lazySingleton<_i750.ChaptersDataSourcePort>(
      () => _i560.ChaptersFirebaseAdapter(
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.lazySingleton<_i750.FormulasDataSourcePort>(
      () => _i822.FormulasFirebaseAdapter(
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.lazySingleton<_i385.SavedDataSourcePort>(
      () => _i1050.SavedFirebaseAdapter(
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.lazySingleton<_i750.ChaptersRepositoryPort>(
      () => _i198.ChaptersRepositoryImpl(
        dataSource: gh<_i750.ChaptersDataSourcePort>(),
        cache: gh<_i750.ChaptersCachePort>(),
      ),
    );
    gh.lazySingleton<_i525.ThemePreferenceDataSourcePort>(
      () => _i230.ThemePreferenceFirebaseAdapter(
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.lazySingleton<_i159.NetworkInfoPort>(
      () => _i105.ConnectivityNetworkInfo(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i193.ProfileDataSourcePort>(
      () => _i943.ProfileFirebaseAdapter(
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.lazySingleton<_i634.OnboardingDataSourcePort>(
      () => _i985.OnboardingFirebaseAdapter(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i525.ThemePreferenceRepositoryPort>(
      () => _i436.ThemePreferenceRepositoryImpl(
        gh<_i525.ThemePreferenceDataSourcePort>(),
      ),
    );
    gh.lazySingleton<_i95.DashboardDataSourcePort>(
      () => _i72.DashboardFirebaseAdapter(
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.lazySingleton<_i525.CurriculumDataSourcePort>(
      () => _i303.CurriculumFirebaseAdapter(
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.factory<_i826.GetChaptersUseCase>(
      () => _i826.GetChaptersUseCase(
        repository: gh<_i49.ChaptersRepositoryPort>(),
      ),
    );
    gh.lazySingleton<_i140.AuthDataSourcePort>(
      () => _i117.AuthFirebaseAdapter(
        gh<_i59.FirebaseAuth>(),
        gh<_i116.GoogleSignIn>(),
      ),
    );
    gh.lazySingleton<_i899.PracticeDataSourcePort>(
      () => _i660.PracticeFirebaseAdapter(
        gh<_i974.FirebaseFirestore>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.factory<_i953.GetMasteryToolsUseCase>(
      () => _i953.GetMasteryToolsUseCase(gh<_i49.ChaptersRepositoryPort>()),
    );
    gh.lazySingleton<_i140.AuthRepositoryPort>(
      () => _i748.AuthRepositoryImpl(gh<_i140.AuthDataSourcePort>()),
    );
    gh.lazySingleton<_i899.PracticeRepositoryPort>(
      () => _i426.PracticeRepositoryImpl(
        dataSource: gh<_i899.PracticeDataSourcePort>(),
        cache: gh<_i899.PracticeCachePort>(),
      ),
    );
    gh.factory<_i519.DeleteAccountUseCase>(
      () => _i519.DeleteAccountUseCase(gh<_i320.AuthRepositoryPort>()),
    );
    gh.factory<_i18.ForgotPasswordUseCase>(
      () => _i18.ForgotPasswordUseCase(gh<_i320.AuthRepositoryPort>()),
    );
    gh.factory<_i155.GetCurrentAuthUserUseCase>(
      () => _i155.GetCurrentAuthUserUseCase(gh<_i320.AuthRepositoryPort>()),
    );
    gh.factory<_i946.GoogleSignInUseCase>(
      () => _i946.GoogleSignInUseCase(gh<_i320.AuthRepositoryPort>()),
    );
    gh.factory<_i362.SignInUseCase>(
      () => _i362.SignInUseCase(gh<_i320.AuthRepositoryPort>()),
    );
    gh.factory<_i580.SignOutUseCase>(
      () => _i580.SignOutUseCase(gh<_i320.AuthRepositoryPort>()),
    );
    gh.factory<_i1037.SignUpUseCase>(
      () => _i1037.SignUpUseCase(gh<_i320.AuthRepositoryPort>()),
    );
    gh.factory<_i873.WatchAuthStateUseCase>(
      () => _i873.WatchAuthStateUseCase(gh<_i320.AuthRepositoryPort>()),
    );
    gh.factory<_i919.ChaptersCubit>(
      () => _i919.ChaptersCubit(
        getChapters: gh<_i750.GetChaptersUseCase>(),
        getMasteryTools: gh<_i750.GetMasteryToolsUseCase>(),
        chaptersRepository: gh<_i750.ChaptersRepositoryPort>(),
      ),
    );
    gh.lazySingleton<_i385.SavedRepositoryPort>(
      () => _i79.SavedRepositoryImpl(
        dataSource: gh<_i385.SavedDataSourcePort>(),
        cache: gh<_i385.SavedCachePort>(),
      ),
    );
    gh.lazySingleton<_i193.ProfileRepositoryPort>(
      () => _i244.ProfileRepositoryImpl(
        dataSource: gh<_i193.ProfileDataSourcePort>(),
        cache: gh<_i193.ProfileCachePort>(),
      ),
    );
    gh.lazySingleton<_i95.DashboardRepositoryPort>(
      () => _i367.DashboardRepositoryImpl(
        dataSource: gh<_i95.DashboardDataSourcePort>(),
        cache: gh<_i95.DashboardCachePort>(),
      ),
    );
    gh.factory<_i847.LoadThemePreferenceUseCase>(
      () => _i847.LoadThemePreferenceUseCase(
        gh<_i327.ThemePreferenceRepositoryPort>(),
      ),
    );
    gh.factory<_i317.SaveThemePreferenceUseCase>(
      () => _i317.SaveThemePreferenceUseCase(
        gh<_i327.ThemePreferenceRepositoryPort>(),
      ),
    );
    gh.factory<_i287.WatchThemePreferenceUseCase>(
      () => _i287.WatchThemePreferenceUseCase(
        gh<_i327.ThemePreferenceRepositoryPort>(),
      ),
    );
    gh.lazySingleton<_i750.FormulasRepositoryPort>(
      () => _i164.FormulasRepositoryImpl(
        dataSource: gh<_i750.FormulasDataSourcePort>(),
        cache: gh<_i750.FormulasCachePort>(),
      ),
    );
    gh.lazySingleton<_i525.CurriculumRepositoryPort>(
      () =>
          _i588.CurriculumRepositoryImpl(gh<_i525.CurriculumDataSourcePort>()),
    );
    gh.lazySingleton<_i634.OnboardingRepositoryPort>(
      () =>
          _i224.OnboardingRepositoryImpl(gh<_i634.OnboardingDataSourcePort>()),
    );
    gh.factory<_i117.AuthCubit>(
      () => _i117.AuthCubit(
        signIn: gh<_i140.SignInUseCase>(),
        signUp: gh<_i140.SignUpUseCase>(),
        signOut: gh<_i140.SignOutUseCase>(),
        googleSignIn: gh<_i140.GoogleSignInUseCase>(),
        watchAuthState: gh<_i140.WatchAuthStateUseCase>(),
        deleteAccount: gh<_i140.DeleteAccountUseCase>(),
        forgotPassword: gh<_i140.ForgotPasswordUseCase>(),
      ),
    );
    gh.lazySingleton<_i543.GetBoardsUseCase>(
      () => _i543.GetBoardsUseCase(gh<_i634.OnboardingRepositoryPort>()),
    );
    gh.lazySingleton<_i733.GetCountriesUseCase>(
      () => _i733.GetCountriesUseCase(gh<_i634.OnboardingRepositoryPort>()),
    );
    gh.lazySingleton<_i1005.GetGradesUseCase>(
      () => _i1005.GetGradesUseCase(gh<_i634.OnboardingRepositoryPort>()),
    );
    gh.lazySingleton<_i509.GetStatesUseCase>(
      () => _i509.GetStatesUseCase(gh<_i634.OnboardingRepositoryPort>()),
    );
    gh.factory<_i627.GetNotificationPreferencesUseCase>(
      () => _i627.GetNotificationPreferencesUseCase(
        repository: gh<_i50.ProfileRepositoryPort>(),
      ),
    );
    gh.factory<_i539.GetProfileStatsUseCase>(
      () => _i539.GetProfileStatsUseCase(
        repository: gh<_i50.ProfileRepositoryPort>(),
      ),
    );
    gh.factory<_i657.GetSettingsItemsUseCase>(
      () => _i657.GetSettingsItemsUseCase(
        repository: gh<_i50.ProfileRepositoryPort>(),
      ),
    );
    gh.factory<_i105.GetUserProfileUseCase>(
      () => _i105.GetUserProfileUseCase(
        repository: gh<_i50.ProfileRepositoryPort>(),
      ),
    );
    gh.factory<_i1012.UpdateNotificationPreferencesUseCase>(
      () => _i1012.UpdateNotificationPreferencesUseCase(
        repository: gh<_i50.ProfileRepositoryPort>(),
      ),
    );
    gh.factory<_i540.UpdateProfileUseCase>(
      () => _i540.UpdateProfileUseCase(
        repository: gh<_i50.ProfileRepositoryPort>(),
      ),
    );
    gh.factory<_i401.UpdateStudyGoalUseCase>(
      () => _i401.UpdateStudyGoalUseCase(
        repository: gh<_i50.ProfileRepositoryPort>(),
      ),
    );
    gh.lazySingleton<_i947.ThemeCubit>(
      () => _i947.ThemeCubit(
        loadThemePreference: gh<_i525.LoadThemePreferenceUseCase>(),
        saveThemePreference: gh<_i525.SaveThemePreferenceUseCase>(),
        watchThemePreference: gh<_i525.WatchThemePreferenceUseCase>(),
      ),
    );
    gh.factory<_i525.GetQuestionsUseCase>(
      () => _i525.GetQuestionsUseCase(
        repository: gh<_i1061.PracticeRepositoryPort>(),
      ),
    );
    gh.factory<_i813.RecordQuizCompletionUseCase>(
      () => _i813.RecordQuizCompletionUseCase(
        repository: gh<_i1061.PracticeRepositoryPort>(),
      ),
    );
    gh.factory<_i384.GetFormulasUseCase>(
      () => _i384.GetFormulasUseCase(
        repository: gh<_i193.FormulasRepositoryPort>(),
      ),
    );
    gh.factory<_i614.ToggleBookmarkUseCase>(
      () => _i614.ToggleBookmarkUseCase(
        repository: gh<_i193.FormulasRepositoryPort>(),
      ),
    );
    gh.factory<_i36.ProfileCubit>(
      () => _i36.ProfileCubit(
        getUserProfile: gh<_i193.GetUserProfileUseCase>(),
        getProfileStats: gh<_i193.GetProfileStatsUseCase>(),
        getSettingsItems: gh<_i193.GetSettingsItemsUseCase>(),
        updateProfile: gh<_i193.UpdateProfileUseCase>(),
        activityRefreshCubit: gh<_i914.ActivityRefreshCubit>(),
      ),
    );
    gh.factory<_i221.RemoveBookmarkUseCase>(
      () => _i221.RemoveBookmarkUseCase(gh<_i385.SavedRepositoryPort>()),
    );
    gh.factory<_i174.RemoveSavedChapterUseCase>(
      () => _i174.RemoveSavedChapterUseCase(gh<_i793.SavedRepositoryPort>()),
    );
    gh.factory<_i883.FormulasCubit>(
      () => _i883.FormulasCubit(
        getFormulas: gh<_i750.GetFormulasUseCase>(),
        toggleBookmark: gh<_i750.ToggleBookmarkUseCase>(),
        formulasRepository: gh<_i750.FormulasRepositoryPort>(),
        chaptersRepository: gh<_i750.ChaptersRepositoryPort>(),
      ),
    );
    gh.factory<_i1052.LoadCurriculumUseCase>(
      () => _i1052.LoadCurriculumUseCase(gh<_i1064.CurriculumRepositoryPort>()),
    );
    gh.factory<_i1048.SaveCurriculumUseCase>(
      () => _i1048.SaveCurriculumUseCase(gh<_i1064.CurriculumRepositoryPort>()),
    );
    gh.factory<_i264.WatchCurriculumUseCase>(
      () => _i264.WatchCurriculumUseCase(gh<_i1064.CurriculumRepositoryPort>()),
    );
    gh.factory<_i527.GetBookmarksUseCase>(
      () => _i527.GetBookmarksUseCase(
        repository: gh<_i793.SavedRepositoryPort>(),
      ),
    );
    gh.factory<_i87.GetSavedChaptersUseCase>(
      () => _i87.GetSavedChaptersUseCase(
        repository: gh<_i793.SavedRepositoryPort>(),
      ),
    );
    gh.factory<_i873.GetSavedNotesUseCase>(
      () => _i873.GetSavedNotesUseCase(
        repository: gh<_i793.SavedRepositoryPort>(),
      ),
    );
    gh.lazySingleton<_i427.CurriculumCubit>(
      () => _i427.CurriculumCubit(
        loadCurriculum: gh<_i525.LoadCurriculumUseCase>(),
        saveCurriculum: gh<_i525.SaveCurriculumUseCase>(),
        watchCurriculum: gh<_i525.WatchCurriculumUseCase>(),
      ),
    );
    gh.factory<_i996.GetAnnouncementsUseCase>(
      () => _i996.GetAnnouncementsUseCase(
        repository: gh<_i190.DashboardRepositoryPort>(),
      ),
    );
    gh.factory<_i273.GetBannersUseCase>(
      () => _i273.GetBannersUseCase(
        repository: gh<_i190.DashboardRepositoryPort>(),
      ),
    );
    gh.factory<_i834.GetRecentStudiesUseCase>(
      () => _i834.GetRecentStudiesUseCase(
        repository: gh<_i190.DashboardRepositoryPort>(),
      ),
    );
    gh.factory<_i1065.GetStudyProgressUseCase>(
      () => _i1065.GetStudyProgressUseCase(
        repository: gh<_i190.DashboardRepositoryPort>(),
      ),
    );
    gh.factory<_i603.GetSubjectsUseCase>(
      () => _i603.GetSubjectsUseCase(
        repository: gh<_i190.DashboardRepositoryPort>(),
      ),
    );
    gh.factory<_i411.PracticeCubit>(
      () => _i411.PracticeCubit(
        getQuestions: gh<_i899.GetQuestionsUseCase>(),
        recordQuizCompletion: gh<_i899.RecordQuizCompletionUseCase>(),
        activityRefreshCubit: gh<_i914.ActivityRefreshCubit>(),
      ),
    );
    gh.factory<_i153.NotificationsCubit>(
      () => _i153.NotificationsCubit(
        getNotificationPreferences:
            gh<_i193.GetNotificationPreferencesUseCase>(),
        updateNotificationPreferences:
            gh<_i193.UpdateNotificationPreferencesUseCase>(),
      ),
    );
    gh.factory<_i807.OnboardingCubit>(
      () => _i807.OnboardingCubit(
        getCountries: gh<_i634.GetCountriesUseCase>(),
        getStates: gh<_i634.GetStatesUseCase>(),
        getBoards: gh<_i634.GetBoardsUseCase>(),
        getGrades: gh<_i634.GetGradesUseCase>(),
        saveCurriculum: gh<_i525.SaveCurriculumUseCase>(),
        updateStudyGoal: gh<_i193.UpdateStudyGoalUseCase>(),
      ),
    );
    gh.factory<_i712.SavedCubit>(
      () => _i712.SavedCubit(
        getBookmarks: gh<_i385.GetBookmarksUseCase>(),
        getSavedChapters: gh<_i385.GetSavedChaptersUseCase>(),
        getSavedNotes: gh<_i385.GetSavedNotesUseCase>(),
        removeBookmark: gh<_i385.RemoveBookmarkUseCase>(),
        removeSavedChapter: gh<_i385.RemoveSavedChapterUseCase>(),
        addNote: gh<_i385.AddNoteUseCase>(),
        updateNote: gh<_i385.UpdateNoteUseCase>(),
        deleteNote: gh<_i385.DeleteNoteUseCase>(),
      ),
    );
    gh.lazySingleton<_i414.SubjectSelectionCubit>(
      () => _i414.SubjectSelectionCubit(
        watchCurriculum: gh<_i525.WatchCurriculumUseCase>(),
      ),
    );
    gh.factory<_i24.DashboardCubit>(
      () => _i24.DashboardCubit(
        getStudyProgress: gh<_i95.GetStudyProgressUseCase>(),
        getSubjects: gh<_i95.GetSubjectsUseCase>(),
        getRecentStudies: gh<_i95.GetRecentStudiesUseCase>(),
        getBanners: gh<_i95.GetBannersUseCase>(),
        getAnnouncements: gh<_i95.GetAnnouncementsUseCase>(),
        curriculumCubit: gh<_i914.CurriculumCubit>(),
        activityRefreshCubit: gh<_i914.ActivityRefreshCubit>(),
      ),
    );
    return this;
  }
}

class _$FirebaseModule extends _i616.FirebaseModule {}
