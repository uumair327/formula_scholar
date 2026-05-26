/// Defines the contract for the application's analytics engine.
///
/// By depending on this port instead of FirebaseAnalytics directly,
/// the UI and business logic layers remain decoupled from the analytics provider
/// (Golden Rule #4: API Layer Must Be Swappable).
abstract class AnalyticsServicePort {
  /// Logs a custom event with optional parameters.
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  });

  /// Tracks when the user views a distinct screen.
  Future<void> setCurrentScreen({
    required String screenName,
    String? screenClassOverride,
  });

  /// Sets a persistent user property for segmentation.
  Future<void> setUserProperty({
    required String name,
    required String? value,
  });
}
