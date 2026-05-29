import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/domain.dart';
import 'ai_settings_state.dart';

class AiSettingsCubit extends Cubit<AiSettingsState> {
  AiSettingsCubit({
    required LoadAiSettingsUseCase loadSettings,
    required SaveAiSettingsUseCase saveSettings,
    required ValidateAiKeyUseCase validateKey,
  }) : _loadSettings = loadSettings,
       _saveSettings = saveSettings,
       _validateKey = validateKey,
       super(const AiSettingsState());

  final LoadAiSettingsUseCase _loadSettings;
  final SaveAiSettingsUseCase _saveSettings;
  final ValidateAiKeyUseCase _validateKey;

  Future<void> load() async {
    emit(state.copyWith(status: AiSettingsStatus.loading, message: null));
    final settings = await _loadSettings();
    emit(
      state.copyWith(
        status: AiSettingsStatus.loaded,
        settings: settings,
        validationResult: null,
      ),
    );
  }

  Future<void> selectProvider(AiProviderType provider) async {
    emit(
      state.copyWith(
        status: AiSettingsStatus.saving,
        settings: state.settings.copyWith(provider: provider),
        message: null,
        validationResult: null,
      ),
    );
    await _saveSettings.saveProvider(provider);
    await load();
  }

  Future<void> save({required String apiKey, required String model}) async {
    emit(state.copyWith(status: AiSettingsStatus.saving, message: null));
    await _saveSettings.saveModel(model.trim().isEmpty ? null : model.trim());
    if (apiKey.trim().isNotEmpty) {
      await _saveSettings.saveApiKey(
        provider: state.settings.provider,
        apiKey: apiKey.trim(),
      );
    }
    final settings = await _loadSettings();
    emit(
      state.copyWith(
        status: AiSettingsStatus.loaded,
        settings: settings,
        message: 'AI settings saved.',
        validationResult: null,
      ),
    );
  }

  Future<void> validate() async {
    emit(state.copyWith(status: AiSettingsStatus.validating, message: null));
    final result = await _validateKey(state.settings.provider);
    emit(
      state.copyWith(
        status: AiSettingsStatus.loaded,
        validationResult: result,
        message: result.message,
      ),
    );
  }

  Future<void> deleteApiKey() async {
    emit(state.copyWith(status: AiSettingsStatus.saving, message: null));
    await _saveSettings.deleteApiKey(state.settings.provider);
    final settings = await _loadSettings();
    emit(
      state.copyWith(
        status: AiSettingsStatus.loaded,
        settings: settings,
        message: 'API key deleted.',
        validationResult: null,
      ),
    );
  }
}
