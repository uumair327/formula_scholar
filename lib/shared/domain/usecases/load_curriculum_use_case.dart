import 'package:injectable/injectable.dart';

import '../../../core/core.dart';
import '../entities/selected_curriculum.dart';
import '../ports/curriculum_repository_port.dart';

@injectable
class LoadCurriculumUseCase {
  final CurriculumRepositoryPort _repository;

  const LoadCurriculumUseCase(this._repository);

  Future<SelectedCurriculum?> call() {
    AppLogger.trace(
      'LoadCurriculumUseCase called',
      tag: AppLogTags.curriculumUseCase,
    );
    return _repository.loadCurriculum();
  }
}
