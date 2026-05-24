library;

import '../entities/widget_config.dart';

abstract class WidgetViewerRepositoryPort {
  Future<WidgetConfig?> getWidgetConfig(String id);
}
