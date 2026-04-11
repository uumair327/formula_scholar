/// Sentinel value for nullable `copyWith` fields.
///
/// Used to distinguish "I didn't pass this argument" from "I explicitly
/// passed null". Without this, `copyWith(errorMessage: null)` would be
/// indistinguishable from omitting the argument entirely.
///
/// Usage in a `copyWith` method:
/// ```dart
/// DashboardState copyWith({Object? errorMessage = unset}) {
///   return DashboardState(
///     errorMessage: identical(errorMessage, unset)
///         ? this.errorMessage
///         : errorMessage as String?,
///   );
/// }
/// ```
const Object unset = _Unset();

class _Unset {
  const _Unset();
}
