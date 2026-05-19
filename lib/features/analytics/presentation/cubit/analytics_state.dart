import 'package:equatable/equatable.dart';

import '../../domain/entities/analytics_data.dart';

enum AnalyticsStatus { initial, loading, loaded, error }

class AnalyticsState extends Equatable {
  const AnalyticsState({
    this.status = AnalyticsStatus.initial,
    this.data,
    this.errorMessage,
  });

  final AnalyticsStatus status;
  final AnalyticsData? data;
  final String? errorMessage;

  AnalyticsState copyWith({
    AnalyticsStatus? status,
    AnalyticsData? data,
    String? errorMessage,
  }) {
    return AnalyticsState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, data, errorMessage];
}
