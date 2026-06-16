import 'package:flutter_tts/flutter_tts.dart';

class TtsHelper {
  static final TtsHelper _instance = TtsHelper._internal();
  factory TtsHelper() => _instance;
  TtsHelper._internal();

  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    await _tts.setVolume(1.0);
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    _isInitialized = true;
  }

  Future<void> setLanguage(String langCode) async {
    final Map<String, String> ttsLangMap = {'ar': 'ar-SA', 'en': 'en-US'};
    final code = ttsLangMap[langCode] ?? 'en-US';
    await _tts.setLanguage(code);
  }

  Future<void> speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  void dispose() {
    _tts.stop();
  }
}
