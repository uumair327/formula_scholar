import 'package:injectable/injectable.dart';
import '../../../../core/core.dart';

@injectable
class GetLocalizedContentUseCase {
  const GetLocalizedContentUseCase(this._repository);

  final LocalizedContentRepositoryPort _repository;

  Future<Result<LocalizedContentBundle>> call(String localeCode) {
    return _repository.getContentBundle(localeCode);
  }
}
