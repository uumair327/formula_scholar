/// Port for checking network connectivity.
///
/// Satisfies Golden Rule 13: Network Handling First-Class.
/// Implementations:
/// - `ConnectivityNetworkInfo` — uses `connectivity_plus`
/// - (test) `FakeNetworkInfo` — always returns true/false
///
/// Repositories can check connectivity before making remote calls
/// and immediately return cached data when offline.
abstract interface class NetworkInfoPort {
  /// Returns `true` if the device currently has internet connectivity.
  Future<bool> get isConnected;
}
