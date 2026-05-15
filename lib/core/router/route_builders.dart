import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../constants/constants.dart';
import '../di/injection.dart';

import '../../features/auth/auth.dart';
import '../../features/chapters/chapters.dart';
import '../../features/dashboard/dashboard.dart';
import '../../features/onboarding/onboarding.dart';
import '../../features/practice/practice.dart';
import '../../features/profile/profile.dart';
import '../../features/saved/saved.dart';
import '../../features/search/search.dart';
import '../../features/flashcards/flashcards.dart';
import '../../features/comparison/comparison.dart';
import '../../features/achievements/achievements.dart';
import '../../features/analytics/analytics.dart';
import '../../features/study_planner/study_planner.dart';
import '../../features/chapters/presentation/pages/cheat_sheet_page.dart';
import '../../shared/shared.dart';
import 'app_page_transitions.dart';

/// Factory functions that build route subtrees for each feature.
///
/// Extracted from [AppRouter] to satisfy Golden Rule 14 (files < 200 lines).
/// Each method returns a [List<RouteBase>] for its feature domain.
abstract final class RouteBuilders {
  // ─── Authentication Routes ──────────────────────────────────────
  static List<GoRoute> authRoutes() {
    return [
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.loginName,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: const LoginPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.signupPath,
        name: AppRoutes.signupName,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: const SignupPage(),
          );
        },
      ),
    ];
  }

  // ─── Profile Sub-Routes (Full-screen overlays) ──────────────────
  static List<GoRoute> profileSubRoutes() {
    return [
      GoRoute(
        path: AppRoutes.accountInfoPath,
        name: AppRoutes.accountInfoName,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: BlocProvider(
              create: (_) {
                final cubit = getIt<ProfileCubit>();
                Future.microtask(cubit.loadProfile);
                return cubit;
              },
              child: const AccountInformationPage(),
            ),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.notificationsPath,
        name: AppRoutes.notificationsName,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: BlocProvider(
              create: (_) {
                final cubit = getIt<NotificationsCubit>();
                Future.microtask(cubit.loadPreferences);
                return cubit;
              },
              child: const NotificationsPage(),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.helpSupportPath,
        name: AppRoutes.helpSupportName,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: const HelpSupportPage(),
          );
        },
      ),
    ];
  }

  // ─── Analytics Route ────────────────────────────────────────
  static List<GoRoute> analyticsRoutes() {
    return [
      GoRoute(
        path: AppRoutes.analyticsPath,
        name: AppRoutes.analyticsName,
        pageBuilder: (context, state) {
          final stats = state.extra as List<ProfileStat>? ?? const [];
          return AppPageTransitions.fadeTransition(
            state: state,
            child: AnalyticsPage(stats: stats),
          );
        },
      ),
    ];
  }

  // ─── Achievements Route ─────────────────────────────────────
  static List<GoRoute> achievementsRoutes() {
    return [
      GoRoute(
        path: AppRoutes.achievementsPath,
        name: AppRoutes.achievementsName,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: BlocProvider(
              create: (_) => getIt<AchievementsCubit>(),
              child: const AchievementsPage(),
            ),
          );
        },
      ),
    ];
  }

  // ─── Cheat Sheet Route ──────────────────────────────────────
  static List<GoRoute> cheatSheetRoutes() {
    return [
      GoRoute(
        path: AppRoutes.cheatSheetPath,
        name: AppRoutes.cheatSheetName,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: const CheatSheetPage(),
          );
        },
      ),
    ];
  }

  // ─── Comparison Route ────────────────────────────────────────
  static List<GoRoute> comparisonRoutes() {
    return [
      GoRoute(
        path: AppRoutes.comparisonPath,
        name: AppRoutes.comparisonName,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: BlocProvider(
              create: (_) => getIt<ComparisonCubit>(),
              child: const ComparisonPage(),
            ),
          );
        },
      ),
    ];
  }

  // ─── Flashcards Route ────────────────────────────────────────
  static List<GoRoute> flashcardRoutes() {
    return [
      GoRoute(
        path: AppRoutes.flashcardsPath,
        name: AppRoutes.flashcardsName,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: BlocProvider(
              create: (_) {
                final cubit = getIt<FlashcardsCubit>();
                return cubit;
              },
              child: const FlashcardsPage(),
            ),
          );
        },
      ),
    ];
  }

  // ─── Study Planner Routes ─────────────────────────────────────
  static List<GoRoute> studyPlannerRoutes() {
    return [
      GoRoute(
        path: AppRoutes.studyPlannerPath,
        name: AppRoutes.studyPlannerName,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: BlocProvider(
              create: (_) => getIt<StudyPlannerCubit>(),
              child: const StudyPlannerPage(),
            ),
          );
        },
        routes: [
          GoRoute(
            path: 'create',
            name: AppRoutes.createPlanName,
            pageBuilder: (context, state) {
              return AppPageTransitions.fadeTransition(
                state: state,
                child: const CreatePlanPage(),
              );
            },
          ),
        ],
      ),
    ];
  }

  // ─── Search Route ─────────────────────────────────────────────
  static List<GoRoute> searchRoutes() {
    return [
      GoRoute(
        path: AppRoutes.searchPath,
        name: AppRoutes.searchName,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: BlocProvider(
              create: (_) => getIt<SearchCubit>(),
              child: const SearchPage(),
            ),
          );
        },
      ),
    ];
  }

  // ─── Legal / Compliance Pages ───────────────────────────────────
  static List<GoRoute> legalRoutes() {
    return [
      GoRoute(
        path: AppRoutes.privacyPolicyPath,
        name: AppRoutes.privacyPolicyName,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: LegalPage.privacyPolicy(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.termsOfServicePath,
        name: AppRoutes.termsOfServiceName,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: LegalPage.termsOfService(),
          );
        },
      ),
    ];
  }

  // ─── Onboarding Routes ─────────────────────────────────────────
  static ShellRoute onboardingRoutes() {
    return ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(
          create: (_) {
            final cubit = getIt<OnboardingCubit>();
            Future.microtask(cubit.loadCountries);
            return cubit;
          },
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: AppRoutes.onboardingPath,
          name: AppRoutes.onboardingName,
          pageBuilder: (context, state) {
            return AppPageTransitions.fadeTransition(
              state: state,
              child: const OnboardingStep1Page(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.onboardingStep2Path,
          name: AppRoutes.onboardingStep2Name,
          pageBuilder: (context, state) {
            return AppPageTransitions.fadeTransition(
              state: state,
              child: const OnboardingStep2Page(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.onboardingStep3Path,
          name: AppRoutes.onboardingStep3Name,
          pageBuilder: (context, state) {
            return AppPageTransitions.fadeTransition(
              state: state,
              child: const OnboardingStep3Page(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.onboardingStep4Path,
          name: AppRoutes.onboardingStep4Name,
          pageBuilder: (context, state) {
            return AppPageTransitions.fadeTransition(
              state: state,
              child: const OnboardingStep4Page(),
            );
          },
        ),
      ],
    );
  }

  // ─── Main Shell (tab-based navigation) ─────────────────────────
  static StatefulShellRoute mainShellRoute() {
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

  static StatefulShellBranch _dashboardBranch() {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutes.dashboardPath,
          name: AppRoutes.dashboardName,
          pageBuilder: (context, state) {
            return AppPageTransitions.fadeTransition(
              state: state,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) {
                      final cubit = getIt<DashboardCubit>();
                      Future.microtask(cubit.loadDashboard);
                      return cubit;
                    },
                  ),
                  BlocProvider(
                    create: (_) => CurriculumOptionsCubit(
                      getBoards: getIt<GetBoardsUseCase>(),
                      getGrades: getIt<GetGradesUseCase>(),
                      curriculumCubit: getIt<CurriculumCubit>(),
                    ),
                  ),
                ],
                child: const DashboardPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  static StatefulShellBranch _chaptersBranch() {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutes.chaptersPath,
          name: AppRoutes.chaptersName,
          pageBuilder: (context, state) {
            return AppPageTransitions.fadeTransition(
              state: state,
              child: BlocProvider(
                create: (_) => getIt<ChaptersCubit>(),
                child: const ChaptersPage(),
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
                final curriculumKey =
                    getIt<CurriculumCubit>().state.curriculum?.curriculumKey;
                return AppPageTransitions.fadeTransition(
                  state: state,
                  child: BlocProvider(
                    create: (_) => getIt<FormulasCubit>()
                      ..loadFormulas(
                        subjectId: subjectId,
                        chapterId: chapterId,
                        chapterName: chapterName,
                        curriculumKey: curriculumKey,
                      ),
                    child: const FormulasPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  static StatefulShellBranch _practiceBranch() {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutes.practicePath,
          name: AppRoutes.practiceName,
          pageBuilder: (context, state) {
            return AppPageTransitions.fadeTransition(
              state: state,
              child: BlocProvider(
                create: (_) {
                  final cubit = getIt<PracticeCubit>();
                  // We do not load questions automatically anymore.
                  // The user must select a subject filter first.
                  return cubit;
                },
                child: const PracticePage(),
              ),
            );
          },
        ),
      ],
    );
  }

  static StatefulShellBranch _savedBranch() {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutes.savedPath,
          name: AppRoutes.savedName,
          pageBuilder: (context, state) {
            return AppPageTransitions.fadeTransition(
              state: state,
              child: BlocProvider(
                create: (_) {
                  final cubit = getIt<SavedCubit>();
                  final curriculum = getIt<CurriculumCubit>().state.curriculum;
                  if (curriculum != null) {
                    Future.microtask(
                      () => cubit.loadBookmarks(
                        curriculumKey: curriculum.curriculumKey,
                      ),
                    );
                  }
                  return cubit;
                },
                child: const SavedPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  static StatefulShellBranch _profileBranch() {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutes.profilePath,
          name: AppRoutes.profileName,
          pageBuilder: (context, state) {
            return AppPageTransitions.fadeTransition(
              state: state,
              child: BlocProvider(
                create: (_) {
                  final cubit = getIt<ProfileCubit>();
                  Future.microtask(cubit.loadProfile);
                  return cubit;
                },
                child: const ProfilePage(),
              ),
            );
          },
        ),
      ],
    );
  }
}
