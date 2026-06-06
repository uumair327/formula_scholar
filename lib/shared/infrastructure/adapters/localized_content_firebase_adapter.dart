import 'package:injectable/injectable.dart';
import '../../../core/constants/app_firestore_collections.dart';
import '../../../core/constants/app_locales.dart';
import '../../../core/network/firestore_client_port.dart';
import '../../domain/models/localized_content_bundle.dart';
import '../../domain/ports/localized_content_data_source_port.dart';

@LazySingleton(as: LocalizedContentDataSourcePort)
class LocalizedContentFirebaseAdapter
    implements LocalizedContentDataSourcePort {
  const LocalizedContentFirebaseAdapter(this._api);

  final FirestoreClientPort _api;

  @override
  Future<LocalizedContentBundle> fetchContentBundle(String localeCode) async {
    final snapshot = await _api.execute(
      () => _api
          .collection(AppFirestoreCollections.dashboardContentValues)
          .doc(AppFirestoreCollections.current)
          .get(),
      tag: 'LocalizedContentFirebaseAdapter',
    );

    if (!snapshot.exists) {
      return LocalizedContentBundle.empty(localeCode: localeCode);
    }

    final data = snapshot.data();
    if (data == null) {
      return LocalizedContentBundle.empty(localeCode: localeCode);
    }

    final rawItems = _extractItems(data);
    final items = rawItems
        .map(LocalizedContentItem.fromMap)
        .where((item) => item.key.isNotEmpty && item.value.isNotEmpty)
        .toList();

    return LocalizedContentBundle.fromItems(
      items,
      localeCode: AppLocales.normalizeContentLocaleCode(localeCode),
    );
  }

  List<Map<String, dynamic>> _extractItems(Map<String, dynamic> data) {
    final rawItems = data['items'];
    if (rawItems is List) {
      return rawItems.whereType<Map>().map((item) {
        return item.map((key, value) => MapEntry(key.toString(), value));
      }).toList();
    }

    final rawValues = data['values'];
    if (rawValues is List) {
      return rawValues.whereType<Map>().map((item) {
        return item.map((key, value) => MapEntry(key.toString(), value));
      }).toList();
    }

    return const [];
  }
}
