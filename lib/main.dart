import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'core/core.dart';
import 'features/auth/auth.dart';
import 'firebase_options.dart';
import 'shared/shared.dart';

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
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      AppLogger.info('Firebase initialized', tag: AppLogTags.main);

      // Initialize Google Sign-In with the Web OAuth client ID (type 3).
      // Required by google_sign_in v7+ on Android to obtain ID tokens.
      if (!kIsWeb) {
        await GoogleSignIn.instance.initialize(
          serverClientId:
              '908985900149-7mfugc05cg73de4342l7koc2dommh694.apps.googleusercontent.com',
        );
        AppLogger.info('GoogleSignIn initialized', tag: AppLogTags.main);
      }

      // Initialize dependency injection (get_it + injectable).
      configureDependencies();
      AppLogger.info('DI configured', tag: AppLogTags.main);

      // Register global BlocObserver for all Cubit/Bloc lifecycle logging.
      Bloc.observer = AppBlocObserver();

      AppLogger.info('App starting', tag: AppLogTags.main);
      AppLogger.info(
        'BlocObserver registered: AppBlocObserver',
        tag: AppLogTags.main,
      );

      // Catch Flutter framework errors (rendering, layout, etc.).
      FlutterError.onError = (FlutterErrorDetails details) {
        AppLogger.error(
          'FlutterError: ${details.exceptionAsString()}',
          tag: AppLogTags.main,
          error: details.exception,
          stackTrace: details.stack,
        );
      };

      runApp(const FormulaScholarApp());
      AppLogger.info('App started successfully', tag: AppLogTags.main);
    },
    // Catch asynchronous errors that escape the Flutter framework.
    (Object error, StackTrace stackTrace) {
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
class FormulaScholarApp extends StatelessWidget {
  const FormulaScholarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthCubit>()),
        BlocProvider(create: (_) => getIt<SubjectSelectionCubit>()),
        BlocProvider(create: (_) => getIt<ThemeCubit>()),
        BlocProvider(create: (_) => getIt<CurriculumCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
