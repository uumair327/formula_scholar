library;

class SliderConfig {
  const SliderConfig({
    required this.id,
    this.label = '',
    this.min = 0.0,
    this.max = 10.0,
    this.step = 0.1,
    this.defaultValue = 1.0,
    this.unit = '',
  });

  factory SliderConfig.fromMap(Map<String, dynamic> map) {
    final id = (map['id'] ?? map['variable'] ?? '').toString();
    return SliderConfig(
      id: id,
      label: (map['label'] ?? id).toString(),
      min: (map['min'] ?? 0.0) as double,
      max: (map['max'] ?? 10.0) as double,
      step: (map['step'] ?? 0.1) as double,
      defaultValue: (map['default'] ?? map['value'] ?? 1.0) as double,
      unit: (map['unit'] ?? '').toString(),
    );
  }

  final String id;
  final String label;
  final double min;
  final double max;
  final double step;
  final double defaultValue;
  final String unit;
}
