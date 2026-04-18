import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import 'notifications_state.dart';

@injectable
class NotificationsCubit extends Cubit<NotificationsState>
    with CubitFailureLogger<NotificationsState> {

  NotificationsCubit({
    required GetNotificationPreferencesUseCase getNotificationPreferences,
    required UpdateNotificationPreferencesUseCase updateNotificationPreferences,
  }) : _getNotificationPreferences = getNotificationPreferences,
       _updateNotificationPreferences = updateNotificationPreferences,
       super(const NotificationsState());
  final GetNotificationPreferencesUseCase _getNotificationPreferences;
  final UpdateNotificationPreferencesUseCase _updateNotificationPreferences;

  @override
  String get logTag => AppLogTags.profileCubit;

  Future<void> loadPreferences() async {
    emit(
      state.copyWith(status: NotificationsStatus.loading, errorMessage: null),
    );

    final result = await _getNotificationPreferences();
    switch (result) {
      case Success(:final data):
        emit(
          state.copyWith(
            status: NotificationsStatus.loaded,
            preferences: data,
            errorMessage: null,
          ),
        );
      case Error(:final failure):
        logFailure('load notification preferences', failure);
        emit(
          state.copyWith(
            status: NotificationsStatus.error,
            errorMessage: failure.message,
          ),
        );
    }
  }

  Future<void> updatePreferences(NotificationPreferences next) async {
    final previous = state.preferences;
    emit(
      state.copyWith(
        status: NotificationsStatus.saving,
        preferences: next,
        errorMessage: null,
      ),
    );

    final result = await _updateNotificationPreferences(next);
    switch (result) {
      case Success():
        emit(
          state.copyWith(
            status: NotificationsStatus.loaded,
            preferences: next,
            errorMessage: null,
          ),
        );
      case Error(:final failure):
        logFailure('update notification preferences', failure);
        emit(
          state.copyWith(
            status: NotificationsStatus.error,
            preferences: previous,
            errorMessage: failure.message,
          ),
        );
    }
  }
}
