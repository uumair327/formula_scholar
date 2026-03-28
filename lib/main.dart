import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/core.dart';

void main() {
  // Capture synchronous errors during widget binding.
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

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
class FormulaScholarApp extends StatelessWidget {
  const FormulaScholarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
