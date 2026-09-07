import 'package:injectable/injectable.dart';
import '../entities/user_entitlements.dart';
import '../ports/premium_repository_port.dart';

@injectable
class RestorePurchasesUseCase {
  const RestorePurchasesUseCase(this._repository);
  final PremiumRepositoryPort _repository;

  Future<UserEntitlements> call() => _repository.restorePurchases();
}
