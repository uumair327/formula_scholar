/// Barrel file for the entire core layer.
///
/// Provides a single import for constants, theme, utils, and router:
/// ```dart
/// import 'package:formula_scholar/core/core.dart';
/// ```
library;

export 'config/config.dart';
export 'constants/constants.dart';
export 'di/di.dart';
export 'domain/entities/paginated_response.dart';
export 'domain/usecase.dart';
export 'error/error.dart';
export 'network/network.dart';
export 'router/router.dart';
export 'security/security.dart';
export 'services/services.dart';
export 'theme/theme.dart';
export 'network/api_client.dart';
export 'utils/utils.dart';
// Also expose shared localization helpers
export '../shared/localized_error_extensions.dart';
// Re-export l10n so `context.l10n` is available via core imports
export '../l10n/l10n.dart';
// Re-export shared UI helpers but hide `ResponsiveContext` to avoid duplicate exports
export '../shared/shared.dart' hide ResponsiveContext;
