import 'package:equatable/equatable.dart';

/// User notification preference flags.
class NotificationPreferences extends Equatable {
  final bool studyReminders;
  final bool streakAlerts;
  final bool newContent;
  final bool achievements;
  final bool weeklyReport;
  final bool pushNotifications;
  final bool emailNotifications;

  const NotificationPreferences({
    this.studyReminders = true,
    this.streakAlerts = true,
    this.newContent = false,
    this.achievements = true,
    this.weeklyReport = false,
    this.pushNotifications = true,
    this.emailNotifications = false,
  });

  NotificationPreferences copyWith({
    bool? studyReminders,
    bool? streakAlerts,
    bool? newContent,
    bool? achievements,
    bool? weeklyReport,
    bool? pushNotifications,
    bool? emailNotifications,
  }) {
    return NotificationPreferences(
      studyReminders: studyReminders ?? this.studyReminders,
      streakAlerts: streakAlerts ?? this.streakAlerts,
      newContent: newContent ?? this.newContent,
      achievements: achievements ?? this.achievements,
      weeklyReport: weeklyReport ?? this.weeklyReport,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
    );
  }

  @override
  List<Object?> get props => [
    studyReminders,
    streakAlerts,
    newContent,
    achievements,
    weeklyReport,
    pushNotifications,
    emailNotifications,
  ];
}
