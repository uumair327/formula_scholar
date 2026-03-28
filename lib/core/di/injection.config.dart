// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/algebra/domain/domain.dart' as _i229;
import '../../features/algebra/domain/ports/algebra_repository_port.dart'
    as _i69;
import '../../features/algebra/domain/usecases/get_formula_sections_use_case.dart'
    as _i469;
import '../../features/algebra/infrastructure/adapters/algebra_local_adapter.dart'
    as _i46;
import '../../features/algebra/infrastructure/repositories/algebra_repository_impl.dart'
    as _i1038;
import '../../features/algebra/presentation/cubit/algebra_cubit.dart' as _i431;
import '../../features/dashboard/domain/domain.dart' as _i95;
import '../../features/dashboard/domain/ports/dashboard_repository_port.dart'
    as _i190;
import '../../features/dashboard/domain/usecases/get_recent_studies_use_case.dart'
    as _i834;
import '../../features/dashboard/domain/usecases/get_study_progress_use_case.dart'
    as _i1065;
import '../../features/dashboard/domain/usecases/get_subjects_use_case.dart'
    as _i603;
import '../../features/dashboard/infrastructure/adapters/dashboard_local_adapter.dart'
    as _i429;
import '../../features/dashboard/infrastructure/repositories/dashboard_repository_impl.dart'
    as _i367;
import '../../features/dashboard/presentation/cubit/dashboard_cubit.dart'
    as _i24;
import '../../features/geometry/domain/domain.dart' as _i922;
import '../../features/geometry/domain/ports/geometry_repository_port.dart'
    as _i356;
import '../../features/geometry/domain/usecases/get_geometry_topics_use_case.dart'
    as _i616;
import '../../features/geometry/infrastructure/adapters/geometry_local_adapter.dart'
    as _i826;
import '../../features/geometry/infrastructure/repositories/geometry_repository_impl.dart'
    as _i248;
import '../../features/geometry/presentation/cubit/geometry_cubit.dart'
    as _i719;
import '../../features/profile/domain/domain.dart' as _i193;
import '../../features/profile/domain/ports/profile_repository_port.dart'
    as _i50;
import '../../features/profile/domain/usecases/get_profile_stats_use_case.dart'
    as _i539;
import '../../features/profile/domain/usecases/get_settings_items_use_case.dart'
    as _i657;
import '../../features/profile/domain/usecases/get_user_profile_use_case.dart'
    as _i105;
import '../../features/profile/infrastructure/adapters/profile_local_adapter.dart'
    as _i959;
import '../../features/profile/infrastructure/repositories/profile_repository_impl.dart'
    as _i244;
import '../../features/profile/presentation/cubit/profile_cubit.dart' as _i36;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i193.ProfileDataSourcePort>(
      () => _i959.ProfileLocalAdapter(),
    );
    gh.lazySingleton<_i922.GeometryDataSourcePort>(
      () => _i826.GeometryLocalAdapter(),
    );
    gh.lazySingleton<_i95.DashboardDataSourcePort>(
      () => _i429.DashboardLocalAdapter(),
    );
    gh.lazySingleton<_i229.AlgebraDataSourcePort>(
      () => _i46.AlgebraLocalAdapter(),
    );
    gh.lazySingleton<_i922.GeometryRepositoryPort>(
      () => _i248.GeometryRepositoryImpl(
        dataSource: gh<_i922.GeometryDataSourcePort>(),
      ),
    );
    gh.lazySingleton<_i229.AlgebraRepositoryPort>(
      () => _i1038.AlgebraRepositoryImpl(
        dataSource: gh<_i229.AlgebraDataSourcePort>(),
      ),
    );
    gh.lazySingleton<_i95.DashboardRepositoryPort>(
      () => _i367.DashboardRepositoryImpl(
        dataSource: gh<_i95.DashboardDataSourcePort>(),
      ),
    );
    gh.lazySingleton<_i193.ProfileRepositoryPort>(
      () => _i244.ProfileRepositoryImpl(
        dataSource: gh<_i193.ProfileDataSourcePort>(),
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
    gh.factory<_i469.GetFormulaSectionsUseCase>(
      () => _i469.GetFormulaSectionsUseCase(
        repository: gh<_i69.AlgebraRepositoryPort>(),
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
    gh.factory<_i36.ProfileCubit>(
      () => _i36.ProfileCubit(
        getUserProfile: gh<_i193.GetUserProfileUseCase>(),
        getProfileStats: gh<_i193.GetProfileStatsUseCase>(),
        getSettingsItems: gh<_i193.GetSettingsItemsUseCase>(),
      ),
    );
    gh.factory<_i616.GetGeometryTopicsUseCase>(
      () => _i616.GetGeometryTopicsUseCase(
        repository: gh<_i356.GeometryRepositoryPort>(),
      ),
    );
    gh.factory<_i24.DashboardCubit>(
      () => _i24.DashboardCubit(
        getStudyProgress: gh<_i95.GetStudyProgressUseCase>(),
        getSubjects: gh<_i95.GetSubjectsUseCase>(),
        getRecentStudies: gh<_i95.GetRecentStudiesUseCase>(),
      ),
    );
    gh.factory<_i431.AlgebraCubit>(
      () => _i431.AlgebraCubit(
        getFormulaSections: gh<_i229.GetFormulaSectionsUseCase>(),
      ),
    );
    gh.factory<_i719.GeometryCubit>(
      () =>
          _i719.GeometryCubit(getTopics: gh<_i922.GetGeometryTopicsUseCase>()),
    );
    return this;
  }
}
