import 'package:equatable/equatable.dart';
import '../../../domain/entities/ad_config.dart';
import '../../../domain/entities/ad_density_level.dart';

enum AdStatus { initial, loading, ready, presenting, error }

class AdState extends Equatable {
  const AdState({
    this.status = AdStatus.initial,
    this.config = const AdConfig(),
    this.isBypassedDueToPremium = false,
    this.errorMessage,
  });

  final AdStatus status;
  final AdConfig config;
  final bool isBypassedDueToPremium;
  final String? errorMessage;

  AdDensityLevel get densityLevel => config.densityLevel;
  int get actionCounter => config.actionCounter;
  bool get isCooldownActive => config.isCooldownActive;
  int get remainingCooldownSeconds => config.remainingCooldownSeconds;

  AdState copyWith({
    AdStatus? status,
    AdConfig? config,
    bool? isBypassedDueToPremium,
    String? errorMessage,
  }) {
    return AdState(
      status: status ?? this.status,
      config: config ?? this.config,
      isBypassedDueToPremium: isBypassedDueToPremium ?? this.isBypassedDueToPremium,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    config,
    isBypassedDueToPremium,
    errorMessage,
  ];
}
