import 'package:flutter_tts/flutter_tts.dart';

class VoiceTtsService {
  final FlutterTts _tts = FlutterTts();

  Future<void> initialize() async {
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    await _tts.awaitSpeakCompletion(true);
  }

  /// Cleans AI text responses by stripping Markdown formatting
  /// and extra symbols so TTS speaks naturally.
  String _cleanForSpeech(String text) {
    var clean = text;

    // Remove Markdown bold / italic symbols
    clean = clean.replaceAll('**', '');
    clean = clean.replaceAll('*', '');

    // Remove Markdown headings
    clean = clean.replaceAll('#', '');

    // Remove Bullet points and dashes at line start
    clean = clean.replaceAll(RegExp(r'^\s*[-•]\s*', multiLine: true), '');

    // Normalize multiple spaces / line breaks into single spaces
    clean = clean.replaceAll(RegExp(r'\s+'), ' ');

    return clean.trim();
  }

  Future<void> speak(
    String text, {
    String language = 'en',
  }) async {
    final cleanText = _cleanForSpeech(text);

    if (cleanText.isEmpty) {
      return;
    }

    await _tts.stop();

    final locale = language == 'ur' ? 'ur-PK' : 'en-US';

    await _tts.setLanguage(locale);
    await _tts.speak(cleanText);
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  Future<void> dispose() async {
    await _tts.stop();
  }
}