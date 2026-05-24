library;

import '../../domain/entities/widget_config.dart';
import '../../domain/repositories/widget_viewer_repository_port.dart';

class WidgetViewerRepositoryMock implements WidgetViewerRepositoryPort {
  @override
  Future<WidgetConfig?> getWidgetConfig(String id) async {
    return null;
  }
}
