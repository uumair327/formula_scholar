import '../../../core/error/result.dart';
import '../models/localized_content_bundle.dart';

abstract interface class LocalizedContentRepositoryPort {
  Future<Result<LocalizedContentBundle>> getContentBundle(String localeCode);
}
