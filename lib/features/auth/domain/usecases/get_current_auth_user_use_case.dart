import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/auth_user.dart';
import '../ports/auth_repository_port.dart';

@injectable
class GetCurrentAuthUserUseCase {
  final AuthRepositoryPort _repository;

  const GetCurrentAuthUserUseCase(this._repository);

  AuthUser? call() {
    AppLogger.trace(
      'GetCurrentAuthUserUseCase called',
      tag: AppLogTags.authRepo,
    );
    return _repository.currentUser;
  }
}
