import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

const Object _unset = Object();

enum NotificationsStatus { initial, loading, loaded, saving, error }

class NotificationsState extends Equatable {
  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.preferences = const NotificationPreferences(),
    this.errorMessage,
  });
  final NotificationsStatus status;
  final NotificationPreferences preferences;
  final String? errorMessage;

  NotificationsState copyWith({
    NotificationsStatus? status,
    NotificationPreferences? preferences,
    Object? errorMessage = _unset,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      preferences: preferences ?? this.preferences,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, preferences, errorMessage];
}
