/// Centralized API/network configuration for timeouts, retries and backoff.
abstract final class AppApiConfig {
  // Default timeout for network operations
  static const Duration timeout = Duration(seconds: 15);

  // Default maximum retry attempts for transient failures
  static const int maxRetries = 2;

  // Backoff base multiplier (milliseconds) used by clients when retrying
  static const int backoffBaseMs = 200;
}
