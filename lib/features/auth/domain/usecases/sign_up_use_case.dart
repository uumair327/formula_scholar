import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/auth_user.dart';
import '../ports/auth_repository_port.dart';

/// Sign-up business logic.
///
/// Satisfies Golden Rule 2 & 11 (SOLID & Testable).
@injectable
class SignUpUseCase {
  SignUpUseCase(this._repository);
  final AuthRepositoryPort _repository;

  Future<Result<AuthUser>> call({
    required String name,
    required String email,
    required String password,
  }) {
    return _repository.signUp(name: name, email: email, password: password);
  }
}
