import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import 'analytics_state.dart';

@injectable
class AnalyticsCubit extends Cubit<AnalyticsState>
    with CubitFailureLogger<AnalyticsState> {
  AnalyticsCubit({
    required GetAnalyticsDataUseCase getAnalytics,
    required AnalyticsRepositoryPort repository,
  }) : _getAnalytics = getAnalytics,
       _repository = repository,
       super(const AnalyticsState()) {
    Future.microtask(load);
  }

  final GetAnalyticsDataUseCase _getAnalytics;
  final AnalyticsRepositoryPort _repository;

  @override
  String get logTag => AppLogTags.analyticsCubit;

  Future<void> load() async {
    emit(state.copyWith(status: AnalyticsStatus.loading));

    final result = await _getAnalytics();
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
    emit(state.copyWith(growthStatus: GrowthMetricsStatus.loading));

    final result = await _repository.getGrowthMetrics();
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
    emit(state.copyWith(selectedPeriod: period));
  }

  void setSubjectFilter(String? subjectId) {
    emit(state.copyWith(selectedSubjectId: subjectId));
  }
}
