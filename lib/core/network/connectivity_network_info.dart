import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

import 'network_info_port.dart';

/// Concrete implementation of [NetworkInfoPort] using `connectivity_plus`.
///
/// Returns `true` if the device has wifi, mobile, ethernet, or vpn
/// connectivity. Returns `false` only when [ConnectivityResult.none].
///
/// Note: This checks the *system's* connectivity status, not whether a
/// specific server is reachable. For server-level health, use the
/// [RetryInterceptor] which handles transient failures automatically.
@LazySingleton(as: NetworkInfoPort)
class ConnectivityNetworkInfo implements NetworkInfoPort {
  const ConnectivityNetworkInfo(this._connectivity);
  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }
}
