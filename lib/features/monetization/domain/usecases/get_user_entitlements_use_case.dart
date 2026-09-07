import 'package:injectable/injectable.dart';
import '../entities/user_entitlements.dart';
import '../ports/premium_repository_port.dart';

@injectable
class GetUserEntitlementsUseCase {
  const GetUserEntitlementsUseCase(this._repository);
  final PremiumRepositoryPort _repository;

  Future<UserEntitlements> call() => _repository.getUserEntitlements();

  Stream<UserEntitlements> watch() => _repository.onEntitlementsChanged;
}
