import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/constants.dart';
import 'app_logger.dart';

/// Global [BlocObserver] that logs every Bloc/Cubit lifecycle event.
///
/// Registered in `main()` via `Bloc.observer = AppBlocObserver()`.
/// Provides a single place to monitor all state management activity,
/// which is invaluable for debugging complex state flows.
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    AppLogger.trace(
      '${bloc.runtimeType} created',
      tag: AppLogTags.bloc,
    );
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    AppLogger.debug(
      '${bloc.runtimeType} state changed: '
      '${change.currentState.runtimeType} → ${change.nextState.runtimeType}',
      tag: AppLogTags.bloc,
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    AppLogger.error(
      '${bloc.runtimeType} error',
      tag: AppLogTags.bloc,
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    AppLogger.trace(
      '${bloc.runtimeType} closed',
      tag: AppLogTags.bloc,
    );
  }
}
