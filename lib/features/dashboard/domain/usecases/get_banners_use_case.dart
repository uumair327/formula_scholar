import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/carousel_item.dart';
import '../ports/dashboard_repository_port.dart';

@injectable
class GetBannersUseCase {
  const GetBannersUseCase({required DashboardRepositoryPort repository})
    : _repository = repository;
  final DashboardRepositoryPort _repository;

  Future<Result<List<CarouselItem>>> call() {
    AppLogger.trace(
      'GetBannersUseCase called',
      tag: AppLogTags.dashboardUseCase,
    );
    return _repository.getBanners();
  }
}
