import 'package:equatable/equatable.dart';

class AiContextSnapshot extends Equatable {
  const AiContextSnapshot({
    required this.currentRoute,
    required this.userRole,
    required this.isAuthenticated,
    required this.permissions,
    required this.availableFeatures,
    this.curriculumLabel,
    this.curriculumKey,
    this.selectedSubject,
    this.localeCode,
    this.recentActivity = const [],
  });

  final String currentRoute;
  final String userRole;
  final bool isAuthenticated;
  final List<String> permissions;
  final List<String> availableFeatures;
  final String? curriculumLabel;
  final String? curriculumKey;
  final String? selectedSubject;
  final String? localeCode;
  final List<String> recentActivity;

  Map<String, dynamic> toSanitizedJson() {
    return {
      'current_screen': currentRoute,
      'user_role': userRole,
      'is_authenticated': isAuthenticated,
      'permissions': permissions,
      'available_features': availableFeatures,
      'curriculum_label': curriculumLabel,
      'curriculum_key': curriculumKey,
      'selected_subject': selectedSubject,
      'locale_code': localeCode,
      'recent_activity': recentActivity.take(5).toList(),
    };
  }

  @override
  List<Object?> get props => [
    currentRoute,
    userRole,
    isAuthenticated,
    permissions,
    availableFeatures,
    curriculumLabel,
    curriculumKey,
    selectedSubject,
    localeCode,
    recentActivity,
  ];
}
