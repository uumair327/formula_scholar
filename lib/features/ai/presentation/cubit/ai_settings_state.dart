import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

enum AiSettingsStatus { initial, loading, loaded, saving, validating, error }

class AiSettingsState extends Equatable {
  const AiSettingsState({
    this.status = AiSettingsStatus.initial,
    this.settings = const AiSettings(
      provider: AiProviderType.openai,
      hasApiKey: false,
    ),
    this.message,
    this.validationResult,
  });

  final AiSettingsStatus status;
  final AiSettings settings;
  final String? message;
  final AiValidationResult? validationResult;

  AiSettingsState copyWith({
    AiSettingsStatus? status,
    AiSettings? settings,
    Object? message = _unset,
    Object? validationResult = _unset,
  }) {
    return AiSettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      message: identical(message, _unset) ? this.message : message as String?,
      validationResult: identical(validationResult, _unset)
          ? this.validationResult
          : validationResult as AiValidationResult?,
    );
  }

  @override
  List<Object?> get props => [status, settings, message, validationResult];
}

const Object _unset = Object();
