abstract interface class StreakProviderPort {
  /// Returns the user's current streak.
  Future<int> getCurrentStreak();
}
