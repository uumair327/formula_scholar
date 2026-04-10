import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../constants/constants.dart';
import '../di/injection.dart';
import '../utils/utils.dart';
import '../../features/auth/auth.dart';
import '../../features/chapters/chapters.dart';
import '../../features/dashboard/dashboard.dart';
import '../../features/onboarding/onboarding.dart';
import '../../features/practice/practice.dart';
import '../../features/profile/profile.dart';
import '../../features/saved/saved.dart';
import '../../shared/shared.dart';
import 'app_page_transitions.dart';
import 'app_router_observer.dart';

class _AuthRouterNotifier extends ChangeNotifier {
  final WatchAuthStateUseCase _watchAuthState;
  late final StreamSubscription<AuthUser?> _subscription;
  AuthUser? _currentUser;

  _AuthRouterNotifier(this._watchAuthState) {
    _currentUser = getIt<AuthRepositoryPort>().currentUser;
    _subscription = _watchAuthState().listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  bool get isLoggedIn => _currentUser != null;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Application router configuration using [GoRouter].
///
/// Responsibilities:
/// - Defines the complete route tree (shell + branches + sub-routes).
/// - Provides [CustomTransitionPage] for polished transitions.
/// - Registers [AppRouterObserver] for navigation logging.
/// - Supplies an [errorBuilder] for 404 / not-found scenarios.
/// - Guards debug diagnostics behind [kDebugMode].
/// - Redirects unauthenticated users to login.
///
/// **Dependency Injection:** Cubits are resolved from [getIt] (via
/// `injectable`) instead of being manually constructed. This decouples
/// the router from concrete DataSource/Repository implementations
/// and follows the Dependency Inversion Principle.
abstract final class AppRouter {
  /// Root navigator key shared with [GoRouter] and [StatefulShellRoute].
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  /// Auth pages that unauthenticated users are allowed to access.
  static const _authPaths = {AppRoutes.loginPath, AppRoutes.signupPath};

  static final _authNotifier = _AuthRouterNotifier(
    getIt<WatchAuthStateUseCase>(),
  );

  /// The singleton [GoRouter] instance consumed by [MaterialApp.router].
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.loginPath,
    debugLogDiagnostics: kDebugMode,
    observers: [AppRouterObserver()],
    refreshListenable: _authNotifier,

    // ───────────── Error / Not-Found ─────────────
    errorBuilder: (context, state) {
      AppLogger.warning('Unknown route: ${state.uri}', tag: AppLogTags.router);
      return NotFoundPage(state: state);
    },

    // ───────────── Redirect Guard ────────────────
    redirect: (BuildContext context, GoRouterState state) {
      AppLogger.trace('Redirect check: ${state.uri}', tag: AppLogTags.router);

      final isLoggedIn = _authNotifier.isLoggedIn;
      final isAuthPage = _authPaths.contains(state.matchedLocation);

      // If not logged in and NOT on auth page → redirect to login.
      if (!isLoggedIn && !isAuthPage) {
        AppLogger.info(
          'Unauthenticated user redirected to login from ${state.uri}',
          tag: AppLogTags.router,
        );
        return AppRoutes.loginPath;
      }

      // If logged in and on auth page → redirect to dashboard.
      if (isLoggedIn && isAuthPage) {
        AppLogger.info(
          'Authenticated user redirected to dashboard from ${state.uri}',
          tag: AppLogTags.router,
        );
        return AppRoutes.dashboardPath;
      }

      return null;
    },

    // ───────────── Route Tree ────────────────────
    routes: [
      // ─── Authentication ───
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

      // ─── Profile Sub-Routes (Full-screen overlays) ───
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
        path: AppRoutes.bookmarksPath,
        name: AppRoutes.bookmarksName,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: const BookmarksPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.notificationsPath,
        name: AppRoutes.notificationsName,
        pageBuilder: (context, state) {
          return AppPageTransitions.fadeTransition(
            state: state,
            child: const NotificationsPage(),
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

      // ─── Legal / Compliance Pages ─────────────────────────
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

      // ─── Onboarding (ShellRoute shares OnboardingCubit) ───
      ShellRoute(
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
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellPage(navigationShell: navigationShell);
        },
        branches: [
          // ─── Home Tab (Dashboard) ───
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboardPath,
                name: AppRoutes.dashboardName,
                pageBuilder: (context, state) {
                  return AppPageTransitions.fadeTransition(
                    state: state,
                    child: BlocProvider(
                      create: (_) {
                        final cubit = getIt<DashboardCubit>();
                        Future.microtask(cubit.loadDashboard);
                        return cubit;
                      },
                      child: const DashboardPage(),
                    ),
                  );
                },
              ),
            ],
          ),

          // ─── Chapters Tab (generic — any subject) ───
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.chaptersPath,
                name: AppRoutes.chaptersName,
                pageBuilder: (context, state) {
                  return AppPageTransitions.fadeTransition(
                    state: state,
                    child: BlocProvider(
                      create: (_) {
                        final cubit = getIt<ChaptersCubit>();
                        // Auto-load if subject is already selected.
                        final selection = getIt<SubjectSelectionCubit>().state;
                        if (selection.hasSelection) {
                          Future.microtask(
                            () => cubit.loadChapters(selection.subject!.id),
                          );
                        }
                        return cubit;
                      },
                      child: const ChaptersPage(),
                    ),
                  );
                },
                routes: [
                  // ─── Formula Detail (sub-route of Chapters) ───
                  GoRoute(
                    path: AppRoutes.formulaDetailPath,
                    name: AppRoutes.formulaDetailName,
                    pageBuilder: (context, state) {
                      final subjectId = state.pathParameters['subjectId'] ?? '';
                      final chapterId = state.pathParameters['chapterId'] ?? '';
                      final chapterName =
                          state.uri.queryParameters['name'] ?? 'Formulas';
                      return AppPageTransitions.fadeTransition(
                        state: state,
                        child: BlocProvider(
                          create: (_) => getIt<FormulasCubit>()
                            ..loadFormulas(
                              subjectId: subjectId,
                              chapterId: chapterId,
                              chapterName: chapterName,
                            ),
                          child: const FormulasPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // ─── Practice Tab ───
          StatefulShellBranch(
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
                        Future.microtask(cubit.loadQuestions);
                        return cubit;
                      },
                      child: const PracticePage(),
                    ),
                  );
                },
              ),
            ],
          ),

          // ─── Saved Tab ───
          StatefulShellBranch(
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
                        Future.microtask(cubit.loadBookmarks);
                        return cubit;
                      },
                      child: const SavedPage(),
                    ),
                  );
                },
              ),
            ],
          ),

          // ─── Profile Tab ───
          StatefulShellBranch(
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
          ),
        ],
      ),
    ],
  );
}
