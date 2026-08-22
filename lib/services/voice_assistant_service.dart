import 'package:speech_to_text/speech_to_text.dart';

class VoiceAssistantService {
  final SpeechToText _speechToText = SpeechToText();

  bool _isInitialized = false;
  bool _starting = false;

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
          print(
            'SPEECH SERVICE ERROR: ${error.errorMsg}',
          );

          onError?.call(
            error.errorMsg,
          );
        },
        onStatus: (status) {
          print(
            'SPEECH SERVICE STATUS: $status',
          );

          onStatus?.call(
            status,
          );
        },
      );

      return _isInitialized;
    } catch (e) {
      _isInitialized = false;

      print(
        'SPEECH INITIALIZE ERROR: $e',
      );

      onError?.call(
        e.toString(),
      );

      return false;
    }
  }

  Future<bool> startListening({
    required void Function(String text) onResult,
    required String localeId,
    void Function(String text)? onFinalResult,
    void Function(String message)? onError,
    void Function(String status)? onStatus,
  }) async {
    if (_starting) {
      print(
        'SPEECH: start ignored because another start is in progress.',
      );

      return false;
    }

    _starting = true;

    try {
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

      // ---------------------------------------------------------
      // Important:
      // Never call listen() while another recognition session
      // is still active.
      // ---------------------------------------------------------

      if (_speechToText.isListening) {
        print(
          'SPEECH: stopping previous listening session.',
        );

        await _speechToText.stop();

        // Give Android speech service a moment to release
        // the previous recognition session.
        await Future.delayed(
          const Duration(
            milliseconds: 250,
          ),
        );
      }

      print(
        'SPEECH: starting new session with $localeId',
      );

      await _speechToText.listen(
        localeId: localeId,
        listenMode: ListenMode.dictation,

        partialResults: true,

        cancelOnError: true,

        listenFor: const Duration(
          seconds: 30,
        ),

        pauseFor: const Duration(
          seconds: 5,
        ),

        onResult: (result) {
          final text = result.recognizedWords.trim();

          print(
            'RAW SPEECH RESULT: $text',
          );

          print(
            'FINAL RESULT: ${result.finalResult}',
          );

          // -----------------------------------------------------
          // Partial result
          // -----------------------------------------------------

          if (text.isNotEmpty) {
            onResult(text);
          }

          // -----------------------------------------------------
          // Final result
          // -----------------------------------------------------

          if (result.finalResult && text.isNotEmpty) {
            print(
              'FINAL SPEECH TEXT: $text',
            );

            onFinalResult?.call(
              text,
            );
          }
        },
      );

      return true;
    } catch (e) {
      print(
        'SPEECH START ERROR: $e',
      );

      onError?.call(
        e.toString(),
      );

      return false;
    } finally {
      _starting = false;
    }
  }

  Future<void> stopListening() async {
    if (!_speechToText.isListening) {
      return;
    }

    print(
      'SPEECH: stopping...',
    );

    try {
      await _speechToText.stop();

      await Future.delayed(
        const Duration(
          milliseconds: 150,
        ),
      );
    } catch (e) {
      print(
        'SPEECH STOP ERROR: $e',
      );
    }
  }

  Future<void> cancelListening() async {
    try {
      if (_speechToText.isListening) {
        print(
          'SPEECH: cancelling...',
        );

        await _speechToText.cancel();
      }
    } catch (e) {
      print(
        'SPEECH CANCEL ERROR: $e',
      );
    }
  }

  Future<void> dispose() async {
    try {
      await _speechToText.cancel();
    } catch (_) {}

    _isInitialized = false;
    _starting = false;
  }
}