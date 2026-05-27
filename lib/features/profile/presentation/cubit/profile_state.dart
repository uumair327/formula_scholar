import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

const Object _unset = Object();

enum ProfileStatus { initial, loading, loaded, error }

/// State for the Profile feature.
class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.stats = const [],
    this.settingsItems = const [],
    this.errorMessage,
  });
  final ProfileStatus status;
  final UserProfile? profile;
  final List<ProfileStat> stats;
  final List<SettingsItem> settingsItems;
  final String? errorMessage;

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? profile,
    List<ProfileStat>? stats,
    List<SettingsItem>? settingsItems,
    Object? errorMessage = _unset,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      stats: stats ?? this.stats,
      settingsItems: settingsItems ?? this.settingsItems,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    status,
    profile,
    stats,
    settingsItems,
    errorMessage,
  ];
}
