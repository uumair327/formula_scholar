library;

enum InteractiveWidgetType {
  graph,
  circuit,
  model3d,
  image,
  simulation,
  chemistry,
  formula;

  static InteractiveWidgetType fromString(String value) {
    return InteractiveWidgetType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => InteractiveWidgetType.formula,
    );
  }
}
