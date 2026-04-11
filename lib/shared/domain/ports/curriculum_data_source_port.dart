import '../entities/selected_curriculum.dart';

abstract interface class CurriculumDataSourcePort {
  Future<SelectedCurriculum?> loadCurriculum();

  Future<void> saveCurriculum(SelectedCurriculum curriculum);

  Stream<SelectedCurriculum?> watchCurriculum();
}
