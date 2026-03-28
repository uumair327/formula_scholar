import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

enum ProfileStatus { initial, loading, loaded, error }

/// State for the Profile feature.
class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserProfile? profile;
  final List<ProfileStat> stats;
  final List<SettingsItem> settingsItems;
  final bool isDarkMode;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.stats = const [],
    this.settingsItems = const [],
    this.isDarkMode = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? profile,
    List<ProfileStat>? stats,
    List<SettingsItem>? settingsItems,
    bool? isDarkMode,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      stats: stats ?? this.stats,
      settingsItems: settingsItems ?? this.settingsItems,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        profile,
        stats,
        settingsItems,
        isDarkMode,
        errorMessage,
      ];
}
