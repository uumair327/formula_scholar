import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../features/ai/ai.dart';
import '../../features/auth/auth.dart';
import '../../shared/shared.dart';
import '../../shared/domain/ports/localized_content_repository_port.dart';
import '../../shared/infrastructure/adapters/localized_content_firebase_adapter.dart';
import '../../shared/infrastructure/repositories/localized_content_repository_impl.dart';
import '../network/firestore_client_port.dart';
import '../router/app_router.dart';
import '../../shared/infrastructure/dashboard_command_listener.dart';
import 'injection.config.dart';

/// Global [GetIt] service locator instance.
///
/// Access registered dependencies anywhere in the app:
/// ```dart
/// final repo = getIt<DashboardRepositoryPort>();
/// ```
final GetIt getIt = GetIt.instance;

/// Configures all injectable dependencies.
///
/// Must be called once in `main()` before `runApp()`.
/// The generated `injection.config.dart` file contains
/// all registrations discovered by `injectable_generator`.
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() => getIt.init();

void registerRuntimeDependencies() {
  if (!getIt.isRegistered<LocalizedContentRepositoryPort>()) {
    getIt.registerLazySingleton<LocalizedContentRepositoryPort>(
      () => LocalizedContentRepositoryImpl(
        LocalizedContentFirebaseAdapter(getIt<FirestoreClientPort>()),
      ),
    );
  }
  if (!getIt.isRegistered<DashboardCommandListener>()) {
    getIt.registerLazySingleton<DashboardCommandListener>(
      () => DashboardCommandListener(getIt<FirestoreClientPort>()),
    );
  }
  _registerAiRuntimeDependencies();
}

void _registerAiRuntimeDependencies() {
  if (!getIt.isRegistered<http.Client>()) {
    getIt.registerLazySingleton<http.Client>(http.Client.new);
  }
  if (!getIt.isRegistered<FlutterSecureStorage>()) {
    getIt.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
      ),
    );
  }
  if (!getIt.isRegistered<SpeechToText>()) {
    getIt.registerLazySingleton<SpeechToText>(SpeechToText.new);
  }
  if (!getIt.isRegistered<FlutterTts>()) {
    getIt.registerLazySingleton<FlutterTts>(FlutterTts.new);
  }
  if (!getIt.isRegistered<AiResponseParser>()) {
    getIt.registerLazySingleton<AiResponseParser>(AiResponseParser.new);
  }
  if (!getIt.isRegistered<AiPromptBuilder>()) {
    getIt.registerLazySingleton<AiPromptBuilder>(AiPromptBuilder.new);
  }
  if (!getIt.isRegistered<AiLocalIntentResolver>()) {
    getIt.registerLazySingleton<AiLocalIntentResolver>(
      AiLocalIntentResolver.new,
    );
  }
  if (!getIt.isRegistered<AiSanitizer>()) {
    getIt.registerLazySingleton<AiSanitizer>(AiSanitizer.new);
  }
  if (!getIt.isRegistered<AiPermissionService>()) {
    getIt.registerLazySingleton<AiPermissionService>(AiPermissionService.new);
  }
  if (!getIt.isRegistered<AiSettingsSecureDataSource>()) {
    getIt.registerLazySingleton<AiSettingsSecureDataSource>(
      () => AiSettingsSecureDataSource(getIt<FlutterSecureStorage>()),
    );
  }
  if (!getIt.isRegistered<OpenAiProviderClient>()) {
    getIt.registerLazySingleton<OpenAiProviderClient>(
      () => OpenAiProviderClient(
        httpClient: getIt<http.Client>(),
        parser: getIt<AiResponseParser>(),
      ),
    );
  }
  if (!getIt.isRegistered<ClaudeProviderClient>()) {
    getIt.registerLazySingleton<ClaudeProviderClient>(
      () => ClaudeProviderClient(
        httpClient: getIt<http.Client>(),
        parser: getIt<AiResponseParser>(),
      ),
    );
  }
  if (!getIt.isRegistered<GeminiProviderClient>()) {
    getIt.registerLazySingleton<GeminiProviderClient>(
      () => GeminiProviderClient(
        httpClient: getIt<http.Client>(),
        parser: getIt<AiResponseParser>(),
      ),
    );
  }
  if (!getIt.isRegistered<AiProviderFactory>()) {
    getIt.registerLazySingleton<AiProviderFactory>(
      () => HttpAiProviderFactory([
        getIt<OpenAiProviderClient>(),
        getIt<ClaudeProviderClient>(),
        getIt<GeminiProviderClient>(),
      ]),
    );
  }
  if (!getIt.isRegistered<AiSettingsRepositoryPort>()) {
    getIt.registerLazySingleton<AiSettingsRepositoryPort>(
      () => AiSettingsRepositoryImpl(
        dataSource: getIt<AiSettingsSecureDataSource>(),
        providerFactory: getIt<AiProviderFactory>(),
      ),
    );
  }
  if (!getIt.isRegistered<AiNavigationPort>()) {
    getIt.registerLazySingleton<AiNavigationPort>(
      () => GoRouterAiNavigationAdapter(AppRouter.router),
    );
  }
  if (!getIt.isRegistered<AiActionRegistry>()) {
    getIt.registerLazySingleton<AiActionRegistry>(
      () => AiActionRegistry(
        buildFormulaScholarAiActions(getIt<AiNavigationPort>()),
      ),
    );
  }
  if (!getIt.isRegistered<AiActionExecutorPort>()) {
    getIt.registerLazySingleton<AiActionExecutorPort>(
      () => AiActionExecutor(
        registry: getIt<AiActionRegistry>(),
        permissionService: getIt<AiPermissionService>(),
      ),
    );
  }
  if (!getIt.isRegistered<AiContextEnginePort>()) {
    getIt.registerLazySingleton<AiContextEnginePort>(
      () => AppAiContextEngine(
        navigation: getIt<AiNavigationPort>(),
        getCurrentAuthUser: getIt<GetCurrentAuthUserUseCase>(),
        curriculumCubit: getIt<CurriculumCubit>(),
        subjectSelectionCubit: getIt<SubjectSelectionCubit>(),
      ),
    );
  }
  if (!getIt.isRegistered<AiVoiceServicePort>()) {
    getIt.registerLazySingleton<AiVoiceServicePort>(
      () => FlutterAiVoiceService(
        speechToText: getIt<SpeechToText>(),
        flutterTts: getIt<FlutterTts>(),
      ),
    );
  }
  if (!getIt.isRegistered<LoadAiSettingsUseCase>()) {
    getIt.registerFactory<LoadAiSettingsUseCase>(
      () => LoadAiSettingsUseCase(getIt<AiSettingsRepositoryPort>()),
    );
  }
  if (!getIt.isRegistered<SaveAiSettingsUseCase>()) {
    getIt.registerFactory<SaveAiSettingsUseCase>(
      () => SaveAiSettingsUseCase(getIt<AiSettingsRepositoryPort>()),
    );
  }
  if (!getIt.isRegistered<ValidateAiKeyUseCase>()) {
    getIt.registerFactory<ValidateAiKeyUseCase>(
      () => ValidateAiKeyUseCase(getIt<AiSettingsRepositoryPort>()),
    );
  }
  if (!getIt.isRegistered<RunAiPromptUseCase>()) {
    getIt.registerFactory<RunAiPromptUseCase>(
      () => RunAiPromptUseCase(
        settingsRepository: getIt<AiSettingsRepositoryPort>(),
        contextEngine: getIt<AiContextEnginePort>(),
        actionExecutor: getIt<AiActionExecutorPort>(),
        providerFactory: getIt<AiProviderFactory>(),
        promptBuilder: getIt<AiPromptBuilder>(),
        localIntentResolver: getIt<AiLocalIntentResolver>(),
        sanitizer: getIt<AiSanitizer>(),
      ),
    );
  }
  if (!getIt.isRegistered<AiSettingsCubit>()) {
    getIt.registerFactory<AiSettingsCubit>(
      () => AiSettingsCubit(
        loadSettings: getIt<LoadAiSettingsUseCase>(),
        saveSettings: getIt<SaveAiSettingsUseCase>(),
        validateKey: getIt<ValidateAiKeyUseCase>(),
      ),
    );
  }
  if (!getIt.isRegistered<AiChatCubit>()) {
    getIt.registerFactory<AiChatCubit>(
      () => AiChatCubit(
        runPrompt: getIt<RunAiPromptUseCase>(),
        voiceService: getIt<AiVoiceServicePort>(),
      ),
    );
  }
}
