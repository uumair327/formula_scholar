import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/mastery_tool.dart';
import '../ports/chapters_repository_port.dart';

@injectable
class GetMasteryToolsUseCase {
  const GetMasteryToolsUseCase(this._repository);
  final ChaptersRepositoryPort _repository;

  Future<Result<List<MasteryTool>>> call(String subjectId) {
    return _repository.getMasteryTools(subjectId);
  }
}
