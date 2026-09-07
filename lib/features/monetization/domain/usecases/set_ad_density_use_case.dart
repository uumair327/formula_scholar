import 'package:injectable/injectable.dart';
import '../entities/ad_density_level.dart';
import '../ports/ad_repository_port.dart';

@injectable
class SetAdDensityUseCase {
  const SetAdDensityUseCase(this._repository);
  final AdRepositoryPort _repository;

  Future<void> call(AdDensityLevel density) =>
      _repository.setAdDensity(density);
}
