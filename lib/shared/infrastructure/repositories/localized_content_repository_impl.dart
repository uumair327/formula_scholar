import 'package:injectable/injectable.dart';

import '../../../core/constants/app_log_tags.dart';
import '../../../core/error/failures.dart';
import '../../../core/error/result.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/utils/safe_operation.dart';
import '../../domain/models/localized_content_bundle.dart';
import '../../domain/ports/localized_content_data_source_port.dart';
import '../../domain/ports/localized_content_repository_port.dart';

@LazySingleton(as: LocalizedContentRepositoryPort)
class LocalizedContentRepositoryImpl implements LocalizedContentRepositoryPort {
  const LocalizedContentRepositoryImpl(this._dataSource);

  final LocalizedContentDataSourcePort _dataSource;

  @override
  Future<Result<LocalizedContentBundle>> getContentBundle(String localeCode) {
    return safeOperation(
      tag: AppLogTags.dashboardRepo,
      operation: 'getLocalizedContentBundle',
      execute: () async {
        final bundle = await _dataSource.fetchContentBundle(localeCode);
        AppLogger.info(
          'Localized content loaded for ${bundle.localeCode} with ${bundle.values.length} values',
          tag: AppLogTags.dashboardRepo,
        );
        return bundle;
      },
      onError: (error, stackTrace) => ServerFailure(
        message: 'Failed to load localized content',
        originalError: error,
        stackTrace: stackTrace,
      ),
    );
  }
}
