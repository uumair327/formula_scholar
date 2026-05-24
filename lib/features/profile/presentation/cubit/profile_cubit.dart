import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';
import 'profile_state.dart';

/// Cubit managing the Profile/Account screen's state.
///
/// Depends on use cases (not repositories directly) following SRP.
/// Uses [Result] pattern matching for typed error handling.
/// Uses [CubitFailureLogger] mixin to eliminate boilerplate.
@injectable
class ProfileCubit extends Cubit<ProfileState>
    with CubitFailureLogger<ProfileState> {
  ProfileCubit({
    required GetUserProfileUseCase getUserProfile,
    required GetProfileStatsUseCase getProfileStats,
    required GetSettingsItemsUseCase getSettingsItems,
    required UpdateProfileUseCase updateProfile,
    required ActivityRefreshCubit activityRefreshCubit,
  }) : _getUserProfile = getUserProfile,
       _getProfileStats = getProfileStats,
       _getSettingsItems = getSettingsItems,
       _updateProfile = updateProfile,
       _activityRefreshCubit = activityRefreshCubit,
        super(const ProfileState()) {
    _activityRefreshSubscription = _activityRefreshCubit.stream.listen((_) {
      if (state.status == ProfileStatus.loading) {
        return;
      }
      Future.microtask(loadProfile);
    });
    Future.microtask(loadProfile);
  }
  final GetUserProfileUseCase _getUserProfile;
  final GetProfileStatsUseCase _getProfileStats;
  final GetSettingsItemsUseCase _getSettingsItems;
  final UpdateProfileUseCase _updateProfile;
  final ActivityRefreshCubit _activityRefreshCubit;
  late final StreamSubscription<int> _activityRefreshSubscription;

  @override
  String get logTag => AppLogTags.profileCubit;

  @override
  Future<void> close() {
    _activityRefreshSubscription.cancel();
    return super.close();
  }

  /// Loads all profile data in parallel.
  Future<void> loadProfile() async {
    AppLogger.info('Loading profile data', tag: AppLogTags.profileCubit);
    emit(state.copyWith(status: ProfileStatus.loading));

    final (profileResult, statsResult, settingsResult) = await (
      _getUserProfile(),
      _getProfileStats(),
      _getSettingsItems(),
    ).wait;

    if (isClosed) return;

    // Pattern match on each result for typed error handling.
    final profile = switch (profileResult) {
      Success(:final data) => data,
      Error(:final failure) => logFailure('user profile', failure),
    };

    final stats = switch (statsResult) {
      Success(:final data) => data,
      Error(:final failure) => logFailure('profile stats', failure),
    };

    final settingsItems = switch (settingsResult) {
      Success(:final data) => data,
      Error(:final failure) => logFailure('settings items', failure),
    };

    if (profile != null && stats != null && settingsItems != null) {
      AppLogger.info(
        'Profile loaded successfully',
        tag: AppLogTags.profileCubit,
      );
      emit(
        state.copyWith(
          status: ProfileStatus.loaded,
          profile: profile,
          stats: stats,
          settingsItems: settingsItems,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: AppStrings.failedToLoadProfile,
        ),
      );
    }
  }

  /// Updates the user's display name and avatar URL.
  Future<bool> updateProfile({
    required String name,
    required String avatarUrl,
  }) async {
    AppLogger.info('Updating profile data', tag: AppLogTags.profileCubit);
    emit(state.copyWith(status: ProfileStatus.loading));

    final result = await _updateProfile(name: name, avatarUrl: avatarUrl);
    switch (result) {
      case Success():
        await loadProfile();
        return true;
      case Error(:final failure):
        logFailure('update profile', failure);
        emit(
          state.copyWith(
            status: ProfileStatus.error,
            errorMessage: failure.message,
          ),
        );
        return false;
    }
  }
}
