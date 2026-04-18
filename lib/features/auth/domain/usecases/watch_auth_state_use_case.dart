import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/auth_user.dart';
import '../ports/auth_repository_port.dart';

/// Exposes auth state as a reactive stream for the UI and router.
@injectable
class WatchAuthStateUseCase {

  WatchAuthStateUseCase(this._repository);
  final AuthRepositoryPort _repository;

  Stream<AuthUser?> call() {
    AppLogger.trace(
      'WatchAuthStateUseCase subscribed',
      tag: AppLogTags.authRepo,
    );
    return _repository.authStateChanges();
  }
}
