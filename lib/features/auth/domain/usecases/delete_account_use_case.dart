import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../ports/auth_repository_port.dart';

/// Delete account business logic.
///
/// Satisfies Golden Rule 2 & 11 (SOLID & Testable).
@injectable
class DeleteAccountUseCase {

  DeleteAccountUseCase(this._repository);
  final AuthRepositoryPort _repository;

  Future<Result<void>> call() {
    return _repository.deleteAccount();
  }
}
