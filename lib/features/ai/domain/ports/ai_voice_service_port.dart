typedef AiSpeechResultCallback =
    void Function(String recognizedWords, {required bool isFinal});

abstract class AiVoiceServicePort {
  bool get isListening;

  Future<bool> initializeSpeech();

  Future<void> startListening({
    required AiSpeechResultCallback onResult,
    String localeId,
  });

  Future<void> stopListening();

  Future<void> speak(String text, {String localeId});

  Future<void> stopSpeaking();
}
