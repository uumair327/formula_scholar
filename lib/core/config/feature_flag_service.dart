import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'feature_flag.dart';
import 'feature_flag_port.dart';

/// Production-ready [FeatureFlagPort] implementation.
///
/// Resolution order (first match wins):
/// 1. Local runtime override (set via [setOverride])
/// 2. Remote config override (refreshed via [refresh])
/// 3. [FeatureFlag.defaultEnabled]
///
/// In debug/profile builds, all flags default to their [FeatureFlag.defaultEnabled]
/// value, ensuring development behaviour matches production intent.
///
/// In release builds, remote config is consulted first before falling back
/// to defaults — but the app never blocks on remote fetch.
@LazySingleton(as: FeatureFlagPort)
class FeatureFlagService implements FeatureFlagPort {
  FeatureFlagService() {
    _applyBuildDefaults();
  }

  /// Remote config overrides (populated by [refresh]).
  final Map<FeatureFlag, bool> _remoteOverrides = {};

  /// Local runtime overrides (set via developer menu, A/B test, or E2E).
  final Map<FeatureFlag, bool> _localOverrides = {};

  /// Stream controller for flag change notifications.
  final StreamController<FeatureFlag> _controller =
      StreamController<FeatureFlag>.broadcast();

  @override
  Stream<FeatureFlag> get onFlagChanged => _controller.stream;

  /// Applies build-mode overrides.
  ///
  /// Currently only suppresses log output in release mode as a safety net,
  /// even if the remote config says otherwise.
  void _applyBuildDefaults() {
    if (kReleaseMode) {
      _localOverrides[FeatureFlag.loggerEnabled] = false;
    }
  }

  @override
  bool isEnabled(FeatureFlag flag) {
    // 1. Local override
    if (_localOverrides.containsKey(flag)) {
      return _localOverrides[flag]!;
    }
    // 2. Remote override
    if (_remoteOverrides.containsKey(flag)) {
      return _remoteOverrides[flag]!;
    }
    // 3. Build default
    return flag.defaultEnabled;
  }

  @override
  bool isDisabled(FeatureFlag flag) => !isEnabled(flag);

  @override
  void setOverride(FeatureFlag flag, bool value) {
    if (_localOverrides[flag] == value) return;
    _localOverrides[flag] = value;
    _controller.add(flag);
  }

  @override
  void clearOverride(FeatureFlag flag) {
    if (!_localOverrides.containsKey(flag)) return;
    _localOverrides.remove(flag);
    _controller.add(flag);
  }

  @override
  void clearAllOverrides() {
    final changed = Set<FeatureFlag>.from(_localOverrides.keys);
    _localOverrides.clear();
    for (final flag in changed) {
      _controller.add(flag);
    }
  }

  @override
  Future<bool> refresh() async {
    try {
      final fetched = await _fetchRemoteFlags();
      final hasChanges = !_mapsEqual(_remoteOverrides, fetched);
      if (hasChanges) {
        _remoteOverrides
          ..clear()
          ..addAll(fetched);
        for (final flag in fetched.keys) {
          _controller.add(flag);
        }
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Placeholder for Firebase Remote Config integration.
  ///
  /// Connect to Firebase Remote Config here:
  /// ```dart
  /// final remote = FirebaseRemoteConfig.instance;
  /// await remote.fetchAndActivate();
  /// for (final flag in FeatureFlag.values) {
  ///   final value = remote.getBool(flag.remoteKey);
  ///   result[flag] = value;
  /// }
  /// ```
  Future<Map<FeatureFlag, bool>> _fetchRemoteFlags() async {
    return {};
  }

  bool _mapsEqual(Map<FeatureFlag, bool> a, Map<FeatureFlag, bool> b) {
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (b[entry.key] != entry.value) return false;
    }
    return true;
  }

  /// Dispose the stream controller when the service is no longer needed.
  @override
  void dispose() {
    _controller.close();
  }
}
