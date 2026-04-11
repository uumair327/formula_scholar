import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../domain/domain.dart';

/// Hive-backed cache for profile data, enabling offline-first access.
@LazySingleton(as: ProfileCachePort)
class ProfileHiveCache implements ProfileCachePort {
  static const String _boxName = 'profile_cache';
  static const String _profileKey = 'user_profile';
  static const String _statsKey = 'profile_stats';

  Future<Box<dynamic>> _box() => Hive.openBox<dynamic>(_boxName);

  @override
  Future<void> cacheUserProfile(UserProfile profile) async {
    final box = await _box();
    await box.put(_profileKey, {
      'name': profile.name,
      'email': profile.email,
      'grade': profile.grade,
      'board': profile.board,
      'avatarUrl': profile.avatarUrl,
      'isPro': profile.isPro,
    });
  }

  @override
  Future<UserProfile?> getUserProfile() async {
    final box = await _box();
    final data = box.get(_profileKey) as Map<dynamic, dynamic>?;
    if (data == null) {
      return null;
    }

    return UserProfile(
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      grade: data['grade'] as String? ?? '',
      board: data['board'] as String? ?? '',
      avatarUrl: data['avatarUrl'] as String? ?? '',
      isPro: data['isPro'] as bool? ?? false,
    );
  }

  @override
  Future<void> cacheProfileStats(List<ProfileStat> stats) async {
    final box = await _box();
    await box.put(
      _statsKey,
      stats
          .map(
            (s) => {
              'id': s.id,
              'label': s.label,
              'value': s.value,
              'iconName': s.iconName,
            },
          )
          .toList(),
    );
  }

  @override
  Future<List<ProfileStat>> getProfileStats() async {
    final box = await _box();
    final cached = box.get(_statsKey) as List<dynamic>?;
    if (cached == null) {
      return const [];
    }

    return cached
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(
          (item) => ProfileStat(
            id: item['id'] as String? ?? '',
            label: item['label'] as String? ?? '',
            value: item['value'] as String? ?? '0',
            iconName: item['iconName'] as String? ?? '',
          ),
        )
        .toList();
  }
}
