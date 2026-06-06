import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';

import 'analytics_service_port.dart';

/// Concrete implementation of [AnalyticsServicePort] using Firebase.
///
/// Registered as a LazySingleton via get_it.
@LazySingleton(as: AnalyticsServicePort)
class FirebaseAnalyticsAdapter implements AnalyticsServicePort {
  FirebaseAnalyticsAdapter() : _analytics = FirebaseAnalytics.instance;
  final FirebaseAnalytics _analytics;

  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> setCurrentScreen({
    required String screenName,
    String? screenClassOverride,
  }) async {
    await _analytics.logEvent(
      name: 'screen_view',
      parameters: {
        'firebase_screen': screenName,
        'firebase_screen_class': ?screenClassOverride,
      },
    );
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    await _analytics.setUserProperty(name: name, value: value);
  }
}
