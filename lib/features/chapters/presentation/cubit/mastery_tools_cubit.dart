import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

@injectable
class MasteryToolsCubit extends Cubit<void> {
  MasteryToolsCubit({required GetFormulasUseCase getFormulas})
    : _getFormulas = getFormulas,
      super(null);

  final GetFormulasUseCase _getFormulas;

  /// Prepare formulas for the given chapters and subject.
  Future<List<Formula>?> prepareFormulas(
    String subjectId,
    List<Chapter> chapters,
    String? curriculumKey,
  ) async {
    try {
      final List<Future<Result<List<Formula>>>> futures = chapters.map((ch) {
        return _getFormulas(subjectId, ch.id, curriculumKey: curriculumKey);
      }).toList();

      final results = await Future.wait(futures);
      final List<Formula> allFormulas = [];
      for (final res in results) {
        if (res is Success<List<Formula>>) {
          allFormulas.addAll(res.data);
        }
      }
      return allFormulas;
    } catch (e, st) {
      AppLogger.error(
        'MasteryToolsCubit.prepareFormulas failed',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }
}
