import 'package:injectable/injectable.dart';
import '../entities/premium_plan.dart';
import '../entities/user_entitlements.dart';
import '../ports/premium_repository_port.dart';

@injectable
class UpgradeToPremiumUseCase {
  const UpgradeToPremiumUseCase(this._repository);
  final PremiumRepositoryPort _repository;

  Future<UserEntitlements> call(PremiumPlan plan) =>
      _repository.purchasePlan(plan);
}
