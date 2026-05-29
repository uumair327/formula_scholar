import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../domain/domain.dart';

class FlutterAiVoiceService implements AiVoiceServicePort {
  FlutterAiVoiceService({
    required SpeechToText speechToText,
    required FlutterTts flutterTts,
  }) : _speechToText = speechToText,
       _flutterTts = flutterTts;

  final SpeechToText _speechToText;
  final FlutterTts _flutterTts;

  @override
  bool get isListening => _speechToText.isListening;

  @override
  Future<bool> initializeSpeech() {
    return _speechToText.initialize();
  }

  @override
  Future<void> startListening({
    required AiSpeechResultCallback onResult,
    String localeId = 'en_US',
  }) async {
    final available = await initializeSpeech();
    if (!available) return;
    await _speechToText.listen(
      localeId: localeId,
      onResult: (result) {
        onResult(result.recognizedWords, isFinal: result.finalResult);
      },
    );
  }

  @override
  Future<void> stopListening() {
    return _speechToText.stop();
  }

  @override
  Future<void> speak(String text, {String localeId = 'en-US'}) async {
    await _flutterTts.setLanguage(localeId);
    await _flutterTts.setSpeechRate(0.48);
    await _flutterTts.speak(text);
  }

  @override
  Future<void> stopSpeaking() {
    return _flutterTts.stop();
  }
}
