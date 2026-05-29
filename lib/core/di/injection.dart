import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../shared/domain/ports/localized_content_repository_port.dart';
import '../../shared/infrastructure/adapters/localized_content_firebase_adapter.dart';
import '../../shared/infrastructure/repositories/localized_content_repository_impl.dart';
import '../network/firestore_client_port.dart';
import '../../shared/infrastructure/dashboard_command_listener.dart';
import 'injection.config.dart';

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
void configureDependencies() => getIt.init();

void registerRuntimeDependencies() {
  if (!getIt.isRegistered<LocalizedContentRepositoryPort>()) {
    getIt.registerLazySingleton<LocalizedContentRepositoryPort>(
      () => LocalizedContentRepositoryImpl(
        LocalizedContentFirebaseAdapter(getIt<FirestoreClientPort>()),
      ),
    );
  }
  if (!getIt.isRegistered<DashboardCommandListener>()) {
    getIt.registerLazySingleton<DashboardCommandListener>(
      () => DashboardCommandListener(getIt<FirestoreClientPort>()),
    );
  }
}

