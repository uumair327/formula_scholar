/// Barrel file for the entire core layer.
///
/// Provides a single import for constants, theme, utils, and router:
/// ```dart
/// import 'package:formula_scholar/core/core.dart';
/// ```
library;

export 'constants/constants.dart';
export 'di/di.dart';
export 'domain/entities/paginated_response.dart';
export 'error/error.dart';
export 'network/network.dart';
export 'router/router.dart';
export 'theme/theme.dart';
export 'utils/utils.dart';

