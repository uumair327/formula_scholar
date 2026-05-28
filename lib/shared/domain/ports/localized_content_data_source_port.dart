import '../models/localized_content_bundle.dart';

abstract interface class LocalizedContentDataSourcePort {
  Future<LocalizedContentBundle> fetchContentBundle(String localeCode);
}
