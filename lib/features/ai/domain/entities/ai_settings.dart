import 'package:equatable/equatable.dart';

import 'ai_provider_type.dart';

class AiSettings extends Equatable {
  const AiSettings({
    required this.provider,
    required this.hasApiKey,
    this.maskedApiKey,
    this.model,
  });

  final AiProviderType provider;
  final bool hasApiKey;
  final String? maskedApiKey;
  final String? model;

  String get effectiveModel =>
      model?.isNotEmpty == true ? model! : provider.defaultModel;

  AiSettings copyWith({
    AiProviderType? provider,
    bool? hasApiKey,
    String? maskedApiKey,
    Object? model = _unset,
  }) {
    return AiSettings(
      provider: provider ?? this.provider,
      hasApiKey: hasApiKey ?? this.hasApiKey,
      maskedApiKey: maskedApiKey ?? this.maskedApiKey,
      model: identical(model, _unset) ? this.model : model as String?,
    );
  }

  @override
  List<Object?> get props => [provider, hasApiKey, maskedApiKey, model];
}

const Object _unset = Object();
