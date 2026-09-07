import 'package:injectable/injectable.dart';
import '../entities/ad_config.dart';
import '../ports/ad_repository_port.dart';

@injectable
class GetAdConfigUseCase {
  const GetAdConfigUseCase(this._repository);
  final AdRepositoryPort _repository;

  Future<AdConfig> call() => _repository.getAdConfig();
}
