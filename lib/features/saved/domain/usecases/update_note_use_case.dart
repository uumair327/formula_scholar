import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/saved_note.dart';
import '../ports/saved_repository_port.dart';

@injectable
class UpdateNoteUseCase {
  const UpdateNoteUseCase({required SavedRepositoryPort repository})
    : _repository = repository;
  final SavedRepositoryPort _repository;

  Future<Result<void>> call(SavedNote note) {
    AppLogger.trace('UpdateNoteUseCase called: "${note.title}"', tag: AppLogTags.savedUseCase);
    return _repository.updateNote(note);
  }
}
