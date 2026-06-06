import 'package:equatable/equatable.dart';

import '../../domain/entities/analytics_data.dart';
import '../../domain/entities/growth_metrics.dart';

enum AnalyticsStatus { initial, loading, loaded, error }
enum GrowthMetricsStatus { initial, loading, loaded, error }

class AnalyticsState extends Equatable {
  const AnalyticsState({
    this.status = AnalyticsStatus.initial,
    this.data,
    this.errorMessage,
    this.growthStatus = GrowthMetricsStatus.initial,
    this.growthMetrics,
    this.growthError,
    this.selectedPeriod = 'week',
    this.selectedSubjectId,
  });

  final AnalyticsStatus status;
  final AnalyticsData? data;
  final String? errorMessage;

  final GrowthMetricsStatus growthStatus;
  final GrowthMetrics? growthMetrics;
  final String? growthError;

  final String selectedPeriod;
  final String? selectedSubjectId;

  AnalyticsState copyWith({
    AnalyticsStatus? status,
    AnalyticsData? data,
    Object? errorMessage = const Object(),
    GrowthMetricsStatus? growthStatus,
    GrowthMetrics? growthMetrics,
    Object? growthError = const Object(),
    String? selectedPeriod,
    Object? selectedSubjectId = const Object(),
  }) {
    return AnalyticsState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: identical(errorMessage, const Object())
          ? this.errorMessage
          : errorMessage as String?,
      growthStatus: growthStatus ?? this.growthStatus,
      growthMetrics: growthMetrics ?? this.growthMetrics,
      growthError: identical(growthError, const Object())
          ? this.growthError
          : growthError as String?,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      selectedSubjectId: identical(selectedSubjectId, const Object())
          ? this.selectedSubjectId
          : selectedSubjectId as String?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    data,
    errorMessage,
    growthStatus,
    growthMetrics,
    growthError,
    selectedPeriod,
    selectedSubjectId,
  ];
}
