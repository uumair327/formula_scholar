import '../entities/entities.dart';

class AiPermissionDecision {
  const AiPermissionDecision.allowed() : message = null;

  const AiPermissionDecision.denied(this.message);

  final String? message;

  bool get isAllowed => message == null;
}

class AiPermissionService {
  AiPermissionDecision validate({
    required AiActionDefinition definition,
    required AiContextSnapshot context,
  }) {
    if (definition.requiresAuthentication && !context.isAuthenticated) {
      return const AiPermissionDecision.denied(
        'Please sign in before I perform that action.',
      );
    }

    if (!context.permissions.contains(definition.permission)) {
      return AiPermissionDecision.denied(
        'You do not have permission to use ${definition.id}.',
      );
    }

    return const AiPermissionDecision.allowed();
  }
}
