import 'package:equatable/equatable.dart';
import 'ad_density_level.dart';

/// Runtime ad configuration entity.
///
/// Follows Clean Architecture (zero external dependencies).
class AdConfig extends Equatable {
  const AdConfig({
    this.densityLevel = AdDensityLevel.minimal,
    this.lastAdShownAt,
    this.actionCounter = 0,
    this.totalImpressions = 0,
    this.isMasterEnabled = true,
  });

  /// Current ad density mode (none, minimal, standard, maximum).
  final AdDensityLevel densityLevel;

  /// Timestamp of the last fullscreen ad presented.
  final DateTime? lastAdShownAt;

  /// Number of completed actions since the last ad was shown.
  final int actionCounter;

  /// Total recorded ad impressions in the session.
  final int totalImpressions;

  /// Master switch enabled status.
  final bool isMasterEnabled;

  /// Whether the cooldown period has elapsed since the last ad.
  bool get isCooldownActive {
    if (lastAdShownAt == null) return false;
    final elapsedSeconds = DateTime.now().difference(lastAdShownAt!).inSeconds;
    return elapsedSeconds < densityLevel.cooldownSeconds;
  }

  /// Remaining seconds in the current cooldown window.
  int get remainingCooldownSeconds {
    if (lastAdShownAt == null) return 0;
    final elapsed = DateTime.now().difference(lastAdShownAt!).inSeconds;
    final diff = densityLevel.cooldownSeconds - elapsed;
    return diff > 0 ? diff : 0;
  }

  /// Whether the action threshold has been met to trigger an ad.
  bool get hasReachedActionThreshold {
    return actionCounter >= densityLevel.actionIntervalCount;
  }

  AdConfig copyWith({
    AdDensityLevel? densityLevel,
    DateTime? lastAdShownAt,
    int? actionCounter,
    int? totalImpressions,
    bool? isMasterEnabled,
  }) {
    return AdConfig(
      densityLevel: densityLevel ?? this.densityLevel,
      lastAdShownAt: lastAdShownAt ?? this.lastAdShownAt,
      actionCounter: actionCounter ?? this.actionCounter,
      totalImpressions: totalImpressions ?? this.totalImpressions,
      isMasterEnabled: isMasterEnabled ?? this.isMasterEnabled,
    );
  }

  @override
  List<Object?> get props => [
    densityLevel,
    lastAdShownAt,
    actionCounter,
    totalImpressions,
    isMasterEnabled,
  ];
}
