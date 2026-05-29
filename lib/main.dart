import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/core.dart';
import 'shared/shared.dart';
import 'features/auth/auth.dart';
import 'features/dashboard/dashboard.dart';
import 'features/profile/profile.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'core/analytics/analytics_service.dart';


const String _googleSignInServerClientId = String.fromEnvironment(
  'GOOGLE_SIGN_IN_SERVER_CLIENT_ID',
);

void main() {
  // Capture synchronous errors during widget binding.
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize Hive once for local data layer caches.
      await Hive.initFlutter();

      // Initialize HydratedBloc persistence storage.
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: kIsWeb
            ? HydratedStorageDirectory.web
            : HydratedStorageDirectory(
                (await getApplicationDocumentsDirectory()).path,
              ),
      );

      // Initialize Firebase before anything else.
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        AppLogger.info('Firebase initialized', tag: AppLogTags.main);
      } catch (e, st) {
        AppLogger.fatal(
          'Firebase initialization failed',
          tag: AppLogTags.main,
          error: e,
          stackTrace: st,
        );
        runApp(
          const _FirebaseInitError(
            message:
                'Failed to connect to backend. Please check your network and reload.',
          ),
        );
        return;
      }

      // Initialize Google Sign-In with the Web OAuth client ID (type 3).
      // Required by google_sign_in v7+ on Android to obtain ID tokens.
      if (!kIsWeb) {
        if (_googleSignInServerClientId.isNotEmpty) {
          await GoogleSignIn.instance.initialize(
            serverClientId: _googleSignInServerClientId,
          );
          AppLogger.info('GoogleSignIn initialized', tag: AppLogTags.main);
        } else {
          AppLogger.warning(
            'GoogleSignIn server client ID not provided; Google auth disabled',
            tag: AppLogTags.main,
          );
        }
      }

      // Initialize dependency injection (get_it + injectable).
      configureDependencies();
      registerRuntimeDependencies();
      AppLogger.info('DI configured', tag: AppLogTags.main);

      // Start listening for dashboard command synchronization events.
      try {
        getIt<DashboardCommandListener>().startListening();
      } catch (e, st) {
        AppLogger.error(
          'Failed to start dashboard command listener',
          tag: AppLogTags.main,
          error: e,
          stackTrace: st,
        );
      }

      // Register global BlocObserver for all Cubit/Bloc lifecycle logging.
      Bloc.observer = AppBlocObserver();


      AppLogger.info('App starting', tag: AppLogTags.main);
      AppLogger.info(
        'BlocObserver registered: AppBlocObserver',
        tag: AppLogTags.main,
      );

      // Catch Flutter framework errors (rendering, layout, etc.).
      FlutterError.onError = (FlutterErrorDetails details) {
        if (!kIsWeb) {
          getIt<AnalyticsService>().recordError(
            details.exception,
            details.stack,
            fatal: true,
            reason: 'Flutter framework error',
          );
        }
        AppLogger.error(
          'FlutterError: ${details.exceptionAsString()}',
          tag: AppLogTags.main,
          error: details.exception,
          stackTrace: details.stack,
        );
      };

      if (!kIsWeb) {
        // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
        PlatformDispatcher.instance.onError = (error, stack) {
          getIt<AnalyticsService>().recordError(
            error,
            stack,
            fatal: true,
            reason: 'Platform dispatcher error',
          );
          return true;
        };
      }

      runApp(const FormulaScholarApp());
      AppLogger.info('App started successfully', tag: AppLogTags.main);
    },
    // Catch asynchronous errors that escape the Flutter framework.
    (Object error, StackTrace stackTrace) {
      if (!kIsWeb) {
        getIt<AnalyticsService>().recordError(
          error,
          stackTrace,
          fatal: true,
          reason: 'Uncaught zone error',
        );
      }
      AppLogger.fatal(
        'Uncaught zone error',
        tag: AppLogTags.main,
        error: error,
        stackTrace: stackTrace,
      );
    },
  );
}

/// Root widget for Formula Scholar.
///
/// Provides [SubjectSelectionCubit] and [CurriculumCubit] above
/// the router so all tabs can read the selected subject and curriculum.
///
/// Also listens to app lifecycle events to refresh data when the
/// app returns from background (foreground resume).
class FormulaScholarApp extends StatefulWidget {
  const FormulaScholarApp({super.key});

  @override
  State<FormulaScholarApp> createState() => _FormulaScholarAppState();
}

class _FormulaScholarAppState extends State<FormulaScholarApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AppLogger.info(
        'App resumed from background - refreshing data',
        tag: AppLogTags.main,
      );
      // Refresh dashboard data
      try {
        final localizationCubit = context.read<LocalizationCubit>();
        final dashboardCubit = getIt<DashboardCubit>();
        dashboardCubit.setContentLocaleCode(
          localizationCubit.state.effectiveContentLocaleCode,
          contentLocalizationEnabled:
              localizationCubit.state.contentLocalizationEnabled,
        );
        dashboardCubit.loadDashboard();
      } catch (_) {}
      // Refresh profile data
      try {
        getIt<ProfileCubit>().loadProfile();
      } catch (_) {}
      // Note: SavedCubit.loadBookmarks() requires a curriculumKey parameter,
      // so it is refreshed from within the SavedPage when it becomes visible.
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthCubit>()),
        BlocProvider(create: (_) => getIt<SubjectSelectionCubit>()),
        BlocProvider(create: (_) => getIt<ThemeCubit>()),
        BlocProvider(create: (_) => getIt<CurriculumCubit>()),
        BlocProvider(create: (_) => LocalizationCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocalizationCubit, LocalizationState>(
            builder: (context, localizationState) {
              final deviceLocale = PlatformDispatcher.instance.locale;
              final appLocale = localizationState.effectiveAppLocale(
                deviceLocale,
              );

              return MaterialApp.router(
                title: 'Formula Scholar',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.isDarkMode
                    ? ThemeMode.dark
                    : ThemeMode.light,
                locale: appLocale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocales.supportedLocales,
                routerConfig: AppRouter.router,
              );
            },
          );
        },
      ),
    );
  }
}

class _FirebaseInitError extends StatelessWidget {
  const _FirebaseInitError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocales.supportedLocales,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(message, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
