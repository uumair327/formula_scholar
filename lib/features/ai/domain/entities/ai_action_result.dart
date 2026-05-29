import 'package:equatable/equatable.dart';

class AiActionResult extends Equatable {
  const AiActionResult({
    required this.success,
    required this.message,
    this.data = const {},
  });

  final bool success;
  final String message;
  final Map<String, dynamic> data;

  @override
  List<Object?> get props => [success, message, data.toString()];
}
