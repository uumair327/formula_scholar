import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/dashboard/dashboard.dart';
import '../../../features/chapters/chapters.dart';
import '../../../features/onboarding/onboarding.dart';
import '../../../features/practice/practice.dart';
import '../../../features/saved/saved.dart';
import '../../../features/profile/profile.dart';
import '../../../shared/shared.dart';
import '../../constants/constants.dart';
import '../../di/injection.dart';
import '../app_page_transitions.dart';

StatefulShellRoute mainShellRoute() {
  return StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return MainShellPage(navigationShell: navigationShell);
    },
    branches: [
      _dashboardBranch(),
      _chaptersBranch(),
      _practiceBranch(),
      _savedBranch(),
      _profileBranch(),
    ],
  );
}

StatefulShellBranch _dashboardBranch() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.dashboardPath,
        name: AppRoutes.dashboardName,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: HeroControllerScope(
              controller: HeroController(),
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (providerContext) {
                      final cubit = getIt<DashboardCubit>();
                      cubit.setContentLocaleCode(
                        providerContext
                            .read<LocalizationCubit>()
                            .state
                            .effectiveContentLocaleCode,
                      );
                      return cubit;
                    },
                  ),
                  BlocProvider(
                    create: (_) => CurriculumOptionsCubit(
                      getCountries: getIt<GetCountriesUseCase>(),
                      getStates: getIt<GetStatesUseCase>(),
                      getBoards: getIt<GetBoardsUseCase>(),
                      getGrades: getIt<GetGradesUseCase>(),
                      curriculumCubit: getIt<CurriculumCubit>(),
                    ),
                  ),
                ],
                child: const DashboardPage(),
              ),
            ),
          );
        },
      ),
    ],
  );
}

StatefulShellBranch _chaptersBranch() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.chaptersPath,
        name: AppRoutes.chaptersName,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: BlocProvider(
              create: (_) => getIt<SubjectsCubit>(),
              child: const SubjectsPage(),
            ),
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.subjectChaptersPath,
            name: AppRoutes.subjectChaptersName,
            pageBuilder: (context, state) {
              return AppPageTransitions.fadeTransition(
                state: state,
                child: BlocProvider(
                  create: (providerContext) {
                    final cubit = getIt<ChaptersCubit>();
                    final subjectState = providerContext
                        .read<SubjectSelectionCubit>()
                        .state;
                    final curriculumKey = providerContext
                        .read<CurriculumCubit>()
                        .state
                        .curriculum
                        ?.curriculumKey;
                    if (subjectState.hasSelection &&
                        curriculumKey != null &&
                        curriculumKey.isNotEmpty) {
                      cubit.loadChapters(
                        subjectState.subject!.id,
                        curriculumKey: curriculumKey,
                      );
                    }
                    return cubit;
                  },
                  child: const SubjectChaptersPage(),
                ),
              );
            },
            routes: [
              GoRoute(
                path: AppRoutes.formulaDetailPath,
                name: AppRoutes.formulaDetailName,
                pageBuilder: (context, state) {
                  final subjectId = state.pathParameters['subjectId'] ?? '';
                  final chapterId = state.pathParameters['chapterId'] ?? '';
                  final chapterName =
                      state.uri.queryParameters['name'] ?? 'Formulas';
                  final curriculumKey = context
                      .read<CurriculumCubit>()
                      .state
                      .curriculum
                      ?.curriculumKey;
                  final formulasCubit = getIt<FormulasCubit>();
                  if (subjectId.isNotEmpty && chapterId.isNotEmpty) {
                    formulasCubit.loadFormulas(
                      subjectId: subjectId,
                      chapterId: chapterId,
                      chapterName: chapterName,
                      curriculumKey: curriculumKey,
                    );
                  }
                  return AppPageTransitions.fadeTransition(
                    state: state,
                    child: BlocProvider(
                      create: (_) => formulasCubit,
                      child: const FormulasPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

StatefulShellBranch _practiceBranch() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.practicePath,
        name: AppRoutes.practiceName,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: BlocProvider(
              create: (_) => getIt<PracticeCubit>(),
              child: const PracticePage(),
            ),
          );
        },
      ),
    ],
  );
}

StatefulShellBranch _savedBranch() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.savedPath,
        name: AppRoutes.savedName,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: BlocProvider(
              create: (_) => getIt<SavedCubit>(),
              child: const SavedPage(),
            ),
          );
        },
      ),
    ],
  );
}

StatefulShellBranch _profileBranch() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.profilePath,
        name: AppRoutes.profileName,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: BlocProvider(
              create: (_) => getIt<ProfileCubit>(),
              child: const ProfilePage(),
            ),
          );
        },
      ),
    ],
  );
}
