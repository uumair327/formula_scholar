library;

import 'interactive_widget_type.dart';
import 'slider_config.dart';

class WidgetConfig {
  const WidgetConfig({
    required this.type,
    this.title = '',
    this.latex,
    this.rawConfig = const {},
    this.sliders = const [],
  });

  factory WidgetConfig.fromMap(Map<String, dynamic> map) {
    final config = (map['config'] as Map<String, dynamic>?) ?? {};
    final slidersList =
        (config['sliders'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ??
        [];

    return WidgetConfig(
      type: InteractiveWidgetType.fromString(
        (map['type'] as String?) ?? 'formula',
      ),
      title: (map['title'] as String?) ?? '',
      latex: (map['latex'] as String?),
      rawConfig: config,
      sliders: slidersList.map(SliderConfig.fromMap).toList(),
    );
  }

  final InteractiveWidgetType type;
  final String title;
  final String? latex;
  final Map<String, dynamic> rawConfig;
  final List<SliderConfig> sliders;
}
