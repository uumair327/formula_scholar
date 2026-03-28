import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import 'algebra_state.dart';

/// Cubit managing the Algebra cheat sheet state.
///
/// Depends on [GetFormulaSectionsUseCase] (not repository directly).
/// Uses [Result] pattern matching for typed error handling.
@injectable
class AlgebraCubit extends Cubit<AlgebraState> {
  final GetFormulaSectionsUseCase _getFormulaSections;

  AlgebraCubit({required GetFormulaSectionsUseCase getFormulaSections})
      : _getFormulaSections = getFormulaSections,
        super(const AlgebraState());

  /// Loads formula sections.
  Future<void> loadFormulas() async {
    AppLogger.info('Loading algebra formulas', tag: AppLogTags.algebraCubit);
    emit(state.copyWith(status: AlgebraStatus.loading));

    final result = await _getFormulaSections();

    switch (result) {
      case Success(:final data):
        AppLogger.info(
          'Loaded ${data.length} formula sections',
          tag: AppLogTags.algebraCubit,
        );
        emit(state.copyWith(
          status: AlgebraStatus.loaded,
          sections: data,
        ));
      case Error(:final failure):
        AppLogger.error(
          'Failed to load formulas: ${failure.message}',
          tag: AppLogTags.algebraCubit,
          error: failure.originalError,
          stackTrace: failure.stackTrace,
        );
        emit(state.copyWith(
          status: AlgebraStatus.error,
          errorMessage: failure.message,
        ));
    }
  }
}
