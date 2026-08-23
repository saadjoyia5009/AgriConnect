import 'package:speech_to_text/speech_to_text.dart';

class VoiceAssistantService {
  final SpeechToText _speechToText = SpeechToText();

  bool _isInitialized = false;
  bool _starting = false;

  String _lastRecognizedText = '';
  bool _finalResultReceived = false;

  bool get isListening => _speechToText.isListening;

  bool get isAvailable => _isInitialized;

  String get lastRecognizedText => _lastRecognizedText;

  bool get finalResultReceived => _finalResultReceived;

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
    // ---------------------------------------------------------
    // Prevent overlapping starts
    // ---------------------------------------------------------

    if (_starting) {
      print(
        'SPEECH: start ignored because another start is in progress.',
      );

      return false;
    }

    // ---------------------------------------------------------
    // Do not start another active session
    // ---------------------------------------------------------

    if (_speechToText.isListening) {
      print(
        'SPEECH: already listening. Ignoring duplicate start.',
      );

      return true;
    }

    _starting = true;

    // Reset previous recognition state
    _lastRecognizedText = '';
    _finalResultReceived = false;

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
      // Check again after initialization
      // ---------------------------------------------------------

      if (_speechToText.isListening) {
        print(
          'SPEECH: already listening after initialization.',
        );

        return true;
      }

      print(
        'SPEECH: starting new session with $localeId',
      );

      await _speechToText.listen(
        onResult: (result) {
          final text =
              result.recognizedWords.trim();

          print(
            'RAW SPEECH RESULT: $text',
          );

          print(
            'FINAL RESULT: ${result.finalResult}',
          );

          // -----------------------------------------------------
          // Always remember latest recognized text
          // -----------------------------------------------------

          if (text.isNotEmpty) {
            _lastRecognizedText = text;

            onResult(text);
          }

          // -----------------------------------------------------
          // Native final result
          // -----------------------------------------------------

          if (result.finalResult &&
              text.isNotEmpty) {
            if (_finalResultReceived) {
              print(
                'SPEECH: duplicate final result ignored.',
              );

              return;
            }

            _finalResultReceived = true;

            print(
              'FINAL SPEECH TEXT: $text',
            );

            onFinalResult?.call(text);
          }
        },

        localeId: localeId,

        partialResults: true,

        cancelOnError: false,
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

  // =========================================================
  // STOP LISTENING
  // =========================================================

 Future<String?> stopListening() async {
  final text = _lastRecognizedText.trim();

  print(
    'SPEECH: stopping...',
  );

  if (_speechToText.isListening) {
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

  if (text.isNotEmpty) {
    print(
      'SPEECH STOP RESULT: $text',
    );

    return text;
  }

  print(
    'SPEECH STOP RESULT: EMPTY',
  );

  return null;
}

  // =========================================================
  // CANCEL
  // =========================================================

  Future<void> cancelListening() async {
    try {
      if (_speechToText.isListening) {
        print(
          'SPEECH: cancelling...',
        );

        await _speechToText.cancel();
      }

      _lastRecognizedText = '';
      _finalResultReceived = false;
    } catch (e) {
      print(
        'SPEECH CANCEL ERROR: $e',
      );
    }
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  Future<void> dispose() async {
    try {
      await _speechToText.cancel();
    } catch (_) {}

    _isInitialized = false;
    _starting = false;

    _lastRecognizedText = '';
    _finalResultReceived = false;
  }
}