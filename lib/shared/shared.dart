/// Barrel file for shared components.
///
/// ```dart
/// import 'package:formula_scholar/shared/shared.dart';
/// ```
library;

export 'cubit/activity_refresh_cubit.dart';
export 'cubit/curriculum_cubit.dart';
export 'cubit/curriculum_state.dart';
export 'cubit/localization_cubit.dart';
export 'cubit/localization_state.dart';
export 'cubit/subject_selection_cubit.dart';
export 'cubit/subject_selection_state.dart';
export 'cubit/theme_cubit.dart';
export 'cubit/theme_state.dart';
export 'domain/domain.dart';
export 'infrastructure/adapters/localized_content_firebase_adapter.dart';
export 'infrastructure/repositories/localized_content_repository_impl.dart';
export 'infrastructure/user_stats_accumulator.dart';
export 'widgets/widgets.dart';
// Re-export localization helpers so common imports include `context.l10n`
export '../l10n/l10n.dart';
export 'localized_error_extensions.dart';
export 'infrastructure/dashboard_command_listener.dart';

