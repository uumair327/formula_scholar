import 'package:equatable/equatable.dart';

/// Represents a State or Region within a Country for state-board selection.
class StateRegion extends Equatable {

  const StateRegion({
    required this.id,
    required this.countryId,
    required this.name,
    required this.stateCode,
  });
  final String id;
  final String countryId;
  final String name;
  final String stateCode;

  @override
  List<Object?> get props => [id, countryId, name, stateCode];
}
