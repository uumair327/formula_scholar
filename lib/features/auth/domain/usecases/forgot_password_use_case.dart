import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../ports/auth_repository_port.dart';

/// Sends a password reset email to the given address.
///
/// Satisfies Golden Rule 2 & 15 (SOLID & Testable).
@injectable
class ForgotPasswordUseCase {
  ForgotPasswordUseCase(this._repository);
  final AuthRepositoryPort _repository;

  Future<Result<void>> call({required String email}) {
    return _repository.sendPasswordResetEmail(email: email);
  }
}
