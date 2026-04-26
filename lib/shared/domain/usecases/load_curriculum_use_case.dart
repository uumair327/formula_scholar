import 'package:injectable/injectable.dart';

import '../../../core/core.dart';
import '../entities/selected_curriculum.dart';
import '../ports/curriculum_repository_port.dart';

@injectable
class LoadCurriculumUseCase {
  const LoadCurriculumUseCase(this._repository);
  final CurriculumRepositoryPort _repository;

  Future<SelectedCurriculum?> call() {
    AppLogger.trace(
      'LoadCurriculumUseCase called',
      tag: AppLogTags.curriculumUseCase,
    );
    return _repository.loadCurriculum();
  }
}
