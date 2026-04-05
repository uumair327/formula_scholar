import 'package:equatable/equatable.dart';

/// Represents a Country for localized curriculum selection.
class Country extends Equatable {
  final String id;
  final String name;
  final String isoCode;
  final String flagUrl;

  const Country({
    required this.id,
    required this.name,
    required this.isoCode,
    required this.flagUrl,
  });

  @override
  List<Object?> get props => [id, name, isoCode];
}
