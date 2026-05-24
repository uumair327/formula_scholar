library;

import '../../domain/entities/widget_config.dart';

class WidgetViewerAdapter {
  const WidgetViewerAdapter();

  WidgetConfig fromRawMap(Map<String, dynamic> map) {
    return WidgetConfig.fromMap(map);
  }
}
