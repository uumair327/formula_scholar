import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import 'profile_state.dart';

/// Cubit managing the Profile/Account screen's state.
///
/// Depends on use cases (not repositories directly) following SRP.
/// Uses [Result] pattern matching for typed error handling.
@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final GetUserProfileUseCase _getUserProfile;
  final GetProfileStatsUseCase _getProfileStats;
  final GetSettingsItemsUseCase _getSettingsItems;

  ProfileCubit({
    required GetUserProfileUseCase getUserProfile,
    required GetProfileStatsUseCase getProfileStats,
    required GetSettingsItemsUseCase getSettingsItems,
  })  : _getUserProfile = getUserProfile,
        _getProfileStats = getProfileStats,
        _getSettingsItems = getSettingsItems,
        super(const ProfileState());

  /// Loads all profile data in parallel.
  Future<void> loadProfile() async {
    AppLogger.info('Loading profile data', tag: AppLogTags.profileCubit);
    emit(state.copyWith(status: ProfileStatus.loading));

    final (profileResult, statsResult, settingsResult) = await (
      _getUserProfile(),
      _getProfileStats(),
      _getSettingsItems(),
    ).wait;

    // Pattern match on each result for typed error handling.
    final profile = switch (profileResult) {
      Success(:final data) => data,
      Error(:final failure) => _logFailure('user profile', failure),
    };

    final stats = switch (statsResult) {
      Success(:final data) => data,
      Error(:final failure) => _logFailure('profile stats', failure),
    };

    final settingsItems = switch (settingsResult) {
      Success(:final data) => data,
      Error(:final failure) => _logFailure('settings items', failure),
    };

    if (profile != null && stats != null && settingsItems != null) {
      AppLogger.info(
        'Profile loaded successfully',
        tag: AppLogTags.profileCubit,
      );
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: profile,
        stats: stats,
        settingsItems: settingsItems,
      ));
    } else {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: AppStrings.failedToLoadProfile,
      ));
    }
  }

  /// Toggles dark mode (UI-only state for now).
  void toggleDarkMode() {
    final newValue = !state.isDarkMode;
    AppLogger.debug(
      'Dark mode toggled: $newValue',
      tag: AppLogTags.profileCubit,
    );
    emit(state.copyWith(isDarkMode: newValue));
  }

  /// Handles settings item tap.
  void onSettingsTapped(String settingsId) {
    AppLogger.info(
      'Settings item tapped: $settingsId',
      tag: AppLogTags.profileCubit,
    );
  }

  /// Logs a failure and returns null to indicate the operation failed.
  Null _logFailure(String operation, Failure failure) {
    AppLogger.error(
      'Failed to load $operation: ${failure.message}',
      tag: AppLogTags.profileCubit,
      error: failure.originalError,
      stackTrace: failure.stackTrace,
    );
    return null;
  }
}
