import 'package:equatable/equatable.dart';

class AiActionDefinition extends Equatable {
  const AiActionDefinition({
    required this.id,
    required this.description,
    required this.permission,
    this.parametersSchema = const {},
    this.requiresAuthentication = true,
  });

  final String id;
  final String description;
  final String permission;
  final Map<String, dynamic> parametersSchema;
  final bool requiresAuthentication;

  Map<String, dynamic> toPromptJson() {
    return {
      'action': id,
      'description': description,
      'permission': permission,
      'requires_authentication': requiresAuthentication,
      'parameters_schema': parametersSchema,
    };
  }

  @override
  List<Object?> get props => [
    id,
    description,
    permission,
    parametersSchema.toString(),
    requiresAuthentication,
  ];
}
