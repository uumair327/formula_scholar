import '../entities/selected_curriculum.dart';

abstract interface class CurriculumRepositoryPort {
  Future<SelectedCurriculum?> loadCurriculum();

  Future<void> saveCurriculum(SelectedCurriculum curriculum);

  Stream<SelectedCurriculum?> watchCurriculum();
}
