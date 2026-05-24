import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import 'analytics_state.dart';

@injectable
class AnalyticsCubit extends Cubit<AnalyticsState>
    with CubitFailureLogger<AnalyticsState> {
  AnalyticsCubit({required GetAnalyticsDataUseCase getAnalytics})
    : _getAnalytics = getAnalytics,
      super(const AnalyticsState()) {
    Future.microtask(load);
  }

  final GetAnalyticsDataUseCase _getAnalytics;

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
  }
}
