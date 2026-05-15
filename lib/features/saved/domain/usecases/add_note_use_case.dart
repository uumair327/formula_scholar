import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../entities/saved_note.dart';
import '../ports/saved_repository_port.dart';

@injectable
class AddNoteUseCase {
  const AddNoteUseCase({required SavedRepositoryPort repository})
    : _repository = repository;
  final SavedRepositoryPort _repository;

  Future<Result<void>> call(SavedNote note) {
    AppLogger.trace('AddNoteUseCase called: "${note.title}"', tag: AppLogTags.savedUseCase);
    return _repository.addNote(note);
  }
}
