import '../../../core/constants/app_locales.dart';

class LocalizedContentItem {
  const LocalizedContentItem({
    required this.key,
    required this.locale,
    required this.value,
    required this.status,
  });

  final String key;
  final String locale;
  final String value;
  final String status;

  factory LocalizedContentItem.fromMap(Map<String, dynamic> map) {
    return LocalizedContentItem(
      key: map['key']?.toString().trim() ?? '',
      locale: AppLocales.normalizeContentLocaleCode(map['locale']?.toString()),
      value: map['value']?.toString() ?? '',
      status: map['status']?.toString().trim() ?? 'Draft',
    );
  }

  bool get isPublished => status.toLowerCase() == 'published';
}

class LocalizedContentBundle {
  const LocalizedContentBundle({
    required this.localeCode,
    required this.items,
    required this.values,
  });

  const LocalizedContentBundle.empty({
    String localeCode = AppLocales.defaultContentLocaleCode,
  }) : this(localeCode: localeCode, items: const [], values: const {});

  final String localeCode;
  final List<LocalizedContentItem> items;
  final Map<String, String> values;

  factory LocalizedContentBundle.fromItems(
    Iterable<LocalizedContentItem> items, {
    required String localeCode,
  }) {
    final fallbacks = AppLocales.contentLocaleFallbacks(localeCode);
    final resolved = <String, String>{};
    final publishedItems = items.where((item) => item.isPublished).toList();

    for (final fallbackLocale in fallbacks) {
      for (final item in publishedItems) {
        if (item.locale == fallbackLocale ||
            item.locale.startsWith('$fallbackLocale-')) {
          resolved.putIfAbsent(item.key, () => item.value);
        }
      }
    }

    return LocalizedContentBundle(
      localeCode: AppLocales.normalizeContentLocaleCode(localeCode),
      items: publishedItems,
      values: resolved,
    );
  }

  String resolve(String key, {String fallback = ''}) {
    return values[key] ?? fallback;
  }
}
