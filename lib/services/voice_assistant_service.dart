import 'package:speech_to_text/speech_to_text.dart';

class VoiceAssistantService {
  final SpeechToText _speechToText = SpeechToText();

  bool _isInitialized = false;

  bool get isListening => _speechToText.isListening;

  bool get isAvailable => _isInitialized;

  Future<bool> initialize({
    void Function(String message)? onError,
    void Function(String status)? onStatus,
  }) async {
    if (_isInitialized) {
      return true;
    }

    try {
      _isInitialized = await _speechToText.initialize(
        onError: (error) {
          onError?.call(error.errorMsg);
        },
        onStatus: (status) {
          onStatus?.call(status);
        },
      );

      return _isInitialized;
    } catch (e) {
      _isInitialized = false;
      onError?.call(e.toString());
      return false;
    }
  }

  Future<bool> startListening({
    required void Function(String text) onResult,
    required String localeId,
    void Function(String message)? onError,
    void Function(String status)? onStatus,
  }) async {
    final initialized = await initialize(
      onError: onError,
      onStatus: onStatus,
    );

    if (!initialized) {
      onError?.call(
        'Speech recognition is not available.',
      );
      return false;
    }

    try {
      await _speechToText.listen(
        onResult: (result) {
          print(
            'RAW SPEECH RESULT: '
                '${result.recognizedWords}',
          );

          print(
            'FINAL RESULT: '
                '${result.finalResult}',
          );

          onResult(
            result.recognizedWords,
          );
        },

        localeId: localeId,

        listenMode: ListenMode.dictation,

        partialResults: true,

        cancelOnError: false,

        listenFor: const Duration(
          seconds: 30,
        ),

        pauseFor: const Duration(
          seconds: 5,
        ),
      );

      return true;
    } catch (e) {
      onError?.call(
        e.toString(),
      );

      return false;
    }
  }

  Future<void> stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
    }
  }

  Future<void> cancelListening() async {
    if (_speechToText.isListening) {
      await _speechToText.cancel();
    }
  }

  void dispose() {
    _speechToText.cancel();
  }
}