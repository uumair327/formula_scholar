import 'package:equatable/equatable.dart';
import '../../domain/domain.dart';

enum StudyPlannerStatus { initial, loading, loaded, error, creating }

class StudyPlannerState extends Equatable {
  const StudyPlannerState({
    this.status = StudyPlannerStatus.initial,
    this.plans = const [],
    this.errorMessage,
    this.selectedPlan,
  });

  final StudyPlannerStatus status;
  final List<StudyPlan> plans;
  final String? errorMessage;
  final StudyPlan? selectedPlan;

  StudyPlannerState copyWith({
    StudyPlannerStatus? status,
    List<StudyPlan>? plans,
    String? errorMessage,
    StudyPlan? selectedPlan,
    bool clearError = false,
  }) {
    return StudyPlannerState(
      status: status ?? this.status,
      plans: plans ?? this.plans,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedPlan: selectedPlan ?? this.selectedPlan,
    );
  }

  @override
  List<Object?> get props => [status, plans, errorMessage, selectedPlan];
}
