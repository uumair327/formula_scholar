import 'package:equatable/equatable.dart';

class AiActionRequest extends Equatable {
  const AiActionRequest({required this.action, this.parameters = const {}});

  factory AiActionRequest.fromJson(Map<String, dynamic> json) {
    final rawParameters = json['parameters'];
    return AiActionRequest(
      action: (json['action'] ?? '').toString(),
      parameters: rawParameters is Map<String, dynamic> ? rawParameters : {},
    );
  }

  final String action;
  final Map<String, dynamic> parameters;

  Map<String, dynamic> toJson() {
    return {'action': action, 'parameters': parameters};
  }

  @override
  List<Object?> get props => [action, parameters.toString()];
}
