import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

enum AlgebraStatus { initial, loading, loaded, error }

/// State for the Algebra cheat sheet feature.
class AlgebraState extends Equatable {
  final AlgebraStatus status;
  final List<FormulaSection> sections;
  final String? errorMessage;

  const AlgebraState({
    this.status = AlgebraStatus.initial,
    this.sections = const [],
    this.errorMessage,
  });

  AlgebraState copyWith({
    AlgebraStatus? status,
    List<FormulaSection>? sections,
    String? errorMessage,
  }) {
    return AlgebraState(
      status: status ?? this.status,
      sections: sections ?? this.sections,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, sections, errorMessage];
}
