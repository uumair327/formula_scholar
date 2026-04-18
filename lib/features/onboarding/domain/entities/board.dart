import 'package:equatable/equatable.dart';

enum BoardType { national, state, private, examination }

/// Academic board entity (CBSE, ICSE, State Board, etc.).
class Board extends Equatable {

  const Board({
    required this.id,
    required this.countryId,
    required this.type,
    required this.name,
    required this.description,
    this.stateId,
  });
  final String id;
  final String countryId;
  final String? stateId;
  final BoardType type;
  final String name;
  final String description;

  @override
  List<Object?> get props => [id, countryId, stateId, type, name];
}
