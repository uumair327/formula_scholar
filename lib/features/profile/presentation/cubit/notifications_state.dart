import 'package:equatable/equatable.dart';
import '../../domain/domain.dart';

const Object _unset = Object();

enum NotificationsStatus { initial, loading, loaded, saving, error }

class NotificationsState extends Equatable {
  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.preferences = const NotificationPreferences(),
    this.errorMessage,
    this.errorKey,
  });
  final NotificationsStatus status;
  final NotificationPreferences preferences;
  final String? errorMessage;
  final String? errorKey;

  NotificationsState copyWith({
    NotificationsStatus? status,
    NotificationPreferences? preferences,
    Object? errorMessage = _unset,
    Object? errorKey = _unset,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      preferences: preferences ?? this.preferences,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      errorKey: identical(errorKey, _unset)
          ? this.errorKey
          : errorKey as String?,
    );
  }

  @override
  List<Object?> get props => [status, preferences, errorMessage, errorKey];
}
