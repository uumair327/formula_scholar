library;

import '../entities/widget_config.dart';
import '../repositories/widget_viewer_repository_port.dart';

class GetWidgetConfigUseCase {
  const GetWidgetConfigUseCase({required this.repository});

  final WidgetViewerRepositoryPort repository;

  Future<WidgetConfig?> call(String id) {
    return repository.getWidgetConfig(id);
  }
}
