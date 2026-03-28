import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import 'geometry_state.dart';

/// Cubit managing the Geometry screen's state.
///
/// Depends on [GetGeometryTopicsUseCase] (not repository directly).
/// Uses [Result] pattern matching for typed error handling.
@injectable
class GeometryCubit extends Cubit<GeometryState> {
  final GetGeometryTopicsUseCase _getTopics;

  GeometryCubit({required GetGeometryTopicsUseCase getTopics})
      : _getTopics = getTopics,
        super(const GeometryState());

  /// Loads geometry topics.
  Future<void> loadTopics() async {
    AppLogger.info('Loading geometry topics', tag: AppLogTags.geometryCubit);
    emit(state.copyWith(status: GeometryStatus.loading));

    final result = await _getTopics();

    switch (result) {
      case Success(:final data):
        AppLogger.info(
          'Loaded ${data.length} geometry topics',
          tag: AppLogTags.geometryCubit,
        );
        emit(state.copyWith(
          status: GeometryStatus.loaded,
          topics: data,
        ));
      case Error(:final failure):
        AppLogger.error(
          'Failed to load geometry: ${failure.message}',
          tag: AppLogTags.geometryCubit,
          error: failure.originalError,
          stackTrace: failure.stackTrace,
        );
        emit(state.copyWith(
          status: GeometryStatus.error,
          errorMessage: failure.message,
        ));
    }
  }
}
