import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/auth_user.dart';
import '../ports/auth_repository_port.dart';

/// Google Sign-In business logic.
///
/// Satisfies Golden Rule 2 & 11 (SOLID & Testable).
/// Each use case = one job (Single Responsibility).
@injectable
class GoogleSignInUseCase {
  GoogleSignInUseCase(this._repository);
  final AuthRepositoryPort _repository;

  Future<Result<AuthUser>> call() {
    return _repository.signInWithGoogle();
  }
}
