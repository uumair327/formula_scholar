import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../datasources/ai_settings_secure_data_source.dart';

class AiSettingsRepositoryImpl implements AiSettingsRepositoryPort {
  const AiSettingsRepositoryImpl({
    required AiSettingsSecureDataSource dataSource,
    required AiProviderFactory providerFactory,
  }) : _dataSource = dataSource,
       _providerFactory = providerFactory;

  final AiSettingsSecureDataSource _dataSource;
  final AiProviderFactory _providerFactory;

  @override
  Future<AiSettings> loadSettings() async {
    final provider = await _dataSource.readProvider();
    final apiKey = await _dataSource.readApiKey(provider);
    final model = await _dataSource.readModel();
    return AiSettings(
      provider: provider,
      hasApiKey: apiKey != null && apiKey.isNotEmpty,
      maskedApiKey: SecretRedactor.maskSecret(apiKey),
      model: model,
    );
  }

  @override
  Future<void> saveProvider(AiProviderType provider) {
    return _dataSource.writeProvider(provider);
  }

  @override
  Future<void> saveModel(String? model) {
    return _dataSource.writeModel(model);
  }

  @override
  Future<void> saveApiKey({
    required AiProviderType provider,
    required String apiKey,
  }) {
    return _dataSource.writeApiKey(provider: provider, apiKey: apiKey);
  }

  @override
  Future<void> deleteApiKey(AiProviderType provider) {
    return _dataSource.deleteApiKey(provider);
  }

  @override
  Future<String?> readApiKey(AiProviderType provider) {
    return _dataSource.readApiKey(provider);
  }

  @override
  Future<AiValidationResult> validateApiKey(AiProviderType provider) async {
    final apiKey = await _dataSource.readApiKey(provider);
    if (apiKey == null || apiKey.isEmpty) return AiValidationResult.missing;

    try {
      return await _providerFactory.clientFor(provider).validateApiKey(apiKey);
    } catch (error, stackTrace) {
      AppLogger.error(
        'AI API key validation failed',
        tag: AppLogTags.aiSettings,
        error: error,
        stackTrace: stackTrace,
      );
      return const AiValidationResult(
        isValid: false,
        message: 'Validation failed. Check the key and network connection.',
      );
    }
  }
}
