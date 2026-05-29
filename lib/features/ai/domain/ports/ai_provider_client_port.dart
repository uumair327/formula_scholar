import '../entities/entities.dart';

abstract class AiProviderClientPort {
  AiProviderType get provider;

  Future<AiProviderResponse> complete(AiProviderRequest request);

  Future<AiValidationResult> validateApiKey(String apiKey);
}
