import 'package:equatable/equatable.dart';

/// Represents a Country for localized curriculum selection.
class Country extends Equatable {

  const Country({
    required this.id,
    required this.name,
    required this.isoCode,
    required this.flagUrl,
  });
  final String id;
  final String name;
  final String isoCode;
  final String flagUrl;

  @override
  List<Object?> get props => [id, name, isoCode];
}
