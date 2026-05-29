import 'package:equatable/equatable.dart';

class AiValidationResult extends Equatable {
  const AiValidationResult({required this.isValid, required this.message});

  final bool isValid;
  final String message;

  static const missing = AiValidationResult(
    isValid: false,
    message: 'Add an API key before validating this provider.',
  );

  @override
  List<Object?> get props => [isValid, message];
}
