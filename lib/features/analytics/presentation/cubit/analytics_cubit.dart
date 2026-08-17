import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../../domain/usecases/get_growth_metrics_use_case.dart';
import 'analytics_state.dart';

@injectable
class AnalyticsCubit extends Cubit<AnalyticsState>
    with CubitFailureLogger<AnalyticsState> {
  AnalyticsCubit({
    required GetAnalyticsDataUseCase getAnalytics,
    required GetGrowthMetricsUseCase getGrowthMetrics,
  }) : _getAnalytics = getAnalytics,
       _getGrowthMetrics = getGrowthMetrics,
       super(const AnalyticsState()) {
    Future.microtask(load);
  }

  final GetAnalyticsDataUseCase _getAnalytics;
  final GetGrowthMetricsUseCase _getGrowthMetrics;

  @override
  String get logTag => AppLogTags.analyticsCubit;

  Future<void> load() async {
    if (isClosed) return;
    emit(state.copyWith(status: AnalyticsStatus.loading));

    final result = await _getAnalytics();
    if (isClosed) return;
    switch (result) {
      case Success(:final data):
        emit(state.copyWith(status: AnalyticsStatus.loaded, data: data));
      case Error(:final failure):
        logFailure('loadAnalytics', failure);
        emit(
          state.copyWith(
            status: AnalyticsStatus.error,
            errorMessage: failure.message,
          ),
        );
    }

    // Also load growth metrics in background
    unawaited(loadGrowthMetrics());
  }

  Future<void> loadGrowthMetrics() async {
    if (isClosed) return;
    emit(state.copyWith(growthStatus: GrowthMetricsStatus.loading));

    final result = await _getGrowthMetrics();
    if (isClosed) return;
    switch (result) {
      case Success(:final data):
        emit(
          state.copyWith(
            growthStatus: GrowthMetricsStatus.loaded,
            growthMetrics: data,
          ),
        );
      case Error(:final failure):
        logFailure('loadGrowthMetrics', failure);
        emit(
          state.copyWith(
            growthStatus: GrowthMetricsStatus.error,
            growthError: failure.message,
          ),
        );
    }
  }

  void setPeriod(String period) {
    if (isClosed) return;
    emit(state.copyWith(selectedPeriod: period));
  }

  void setSubjectFilter(String? subjectId) {
    if (isClosed) return;
    emit(state.copyWith(selectedSubjectId: subjectId));
  }
}
