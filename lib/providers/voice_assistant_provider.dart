import 'package:flutter/foundation.dart';

import '../services/ai_chat_service.dart';
import '../services/voice_assistant_service.dart';
import '../services/voice_tts_service.dart';

enum VoiceAssistantState {
  idle,
  listening,
  processing,
  speaking,
  error,
}

class VoiceAssistantProvider extends ChangeNotifier {
  final VoiceAssistantService _voiceService = VoiceAssistantService();
  final AIChatService _aiService = AIChatService();
  final VoiceTtsService _ttsService = VoiceTtsService();

  VoiceAssistantState _state = VoiceAssistantState.idle;

  String _recognizedText = '';
  String _responseText = '';
  String? _error;

  String? _conversationId;
  Map<String, dynamic>? _action;

  String _language = 'en';
  String? _currentScreen;

  bool _requestSentForCurrentSpeech = false;

  VoiceAssistantProvider() {
    _ttsService.initialize();
  }

  VoiceAssistantState get state => _state;
  String get language => _language;
  String? get currentScreen => _currentScreen;
  String get recognizedText => _recognizedText;
  String get responseText => _responseText;
  String? get error => _error;
  String? get conversationId => _conversationId;

  String? get actionType => _action?['type']?.toString();
  String? get actionTarget => _action?['target']?.toString();
  Map<String, dynamic>? get action => _action;

  Map<String, dynamic>? consumeAction() {
    final currentAction = _action;
    _action = null;
    notifyListeners();
    return currentAction;
  }

  bool get isListening => _state == VoiceAssistantState.listening;
  bool get isProcessing => _state == VoiceAssistantState.processing;
  bool get isSpeaking => _state == VoiceAssistantState.speaking;

  // =========================================================
  // START LISTENING
  // =========================================================

  Future<void> startListening({
    String language = 'en',
    String? currentScreen,
  }) async {
    if (_state == VoiceAssistantState.listening ||
        _state == VoiceAssistantState.processing ||
        _state == VoiceAssistantState.speaking) {
      return;
    }

    _language = language;

    if (currentScreen != null) {
      _currentScreen = currentScreen;
    }

    _error = null;
    _recognizedText = '';
    _requestSentForCurrentSpeech = false;

    _state = VoiceAssistantState.listening;
    notifyListeners();

    final String localeId = language == 'ur' ? 'ur_PK' : 'en_US';

    debugPrint('VOICE LANGUAGE: $language');
    debugPrint('VOICE LOCALE: $localeId');

    final bool started = await _voiceService.startListening(
      localeId: localeId,
      onResult: (text) {
        debugPrint('VOICE RESULT: $text');
        _recognizedText = text;
        notifyListeners();
      },
      onFinalResult: (text) async {
        debugPrint('FINAL VOICE TEXT: $text');

        if (_requestSentForCurrentSpeech) {
          debugPrint('AI REQUEST ALREADY SENT. IGNORING DUPLICATE FINAL RESULT.');
          return;
        }

        if (_state != VoiceAssistantState.listening) {
          return;
        }

        final String trimmedText = text.trim();

        if (trimmedText.isEmpty) {
          _state = VoiceAssistantState.idle;
          _error = language == 'ur'
              ? 'میں آپ کی بات سمجھ نہیں سکا۔'
              : 'I could not understand your voice.';
          notifyListeners();
          return;
        }

        _requestSentForCurrentSpeech = true;

        await _sendToAI(
          trimmedText,
          currentScreen: _currentScreen,
        );
      },
      onError: (message) {
        debugPrint('VOICE ERROR: $message');

        // error_no_match is not a fatal application error.
        // Speech recognition may stop because no speech was detected.
        if (message == 'error_no_match') {
          debugPrint(
            'VOICE: error_no_match ignored; keeping conversation alive.',
          );

          _state = VoiceAssistantState.idle;
          notifyListeners();
          return;
        }

        _state = VoiceAssistantState.error;
        _error = message;
        notifyListeners();
      },
      onStatus: (status) {
        debugPrint('VOICE STATUS: $status');
      },
    );

    if (!started) {
      _state = VoiceAssistantState.error;
      _error = language == 'ur'
          ? 'مائیکروفون یا speech recognition دستیاب نہیں ہے۔'
          : 'Microphone or speech recognition is not available.';
      notifyListeners();
    }
  }

  // =========================================================
  // STOP LISTENING
  // =========================================================

Future<void> stopListening() async {
  if (_state != VoiceAssistantState.listening) {
    return;
  }

  final fallbackText =
      await _voiceService.stopListening();

  if (fallbackText == null ||
      fallbackText.trim().isEmpty) {
    return;
  }

  if (_requestSentForCurrentSpeech) {
    debugPrint(
      'AI REQUEST ALREADY SENT. FALLBACK IGNORED.',
    );
    return;
  }

  final trimmedText =
      fallbackText.trim();

  if (trimmedText.isEmpty) {
    return;
  }

  _requestSentForCurrentSpeech = true;

  debugPrint(
    'FALLBACK VOICE TEXT: $trimmedText',
  );

  await _sendToAI(
    trimmedText,
    currentScreen: _currentScreen,
  );
}

  // =========================================================
  // SEND TO AI
  // =========================================================

  Future<void> _sendToAI(
    String text, {
    String? currentScreen,
  }) async {
    _state = VoiceAssistantState.processing;
    _error = null;
    notifyListeners();

    // ── TRACE: before every AI request ──────────────────────────
    debugPrint('VOICE AI REQUEST conversationId: $_conversationId');
    debugPrint('VOICE AI REQUEST message: $text');
    debugPrint('VOICE AI REQUEST currentScreen: $_currentScreen');
    debugPrint('VOICE AI REQUEST providerInstance: ${identityHashCode(this)}');
    // ─────────────────────────────────────────────────────────────

    try {
      final AIChatResponse response = await _aiService.sendMessage(
        message: text,
        conversationId: _conversationId,
        currentScreen: currentScreen,
        language: _language,
      );

      debugPrint('========== AI RESULT ==========');
      debugPrint('SUCCESS: ${response.success}');
      debugPrint('MESSAGE: ${response.message}');
      debugPrint('CONVERSATION ID: ${response.conversationId}');
      debugPrint('ACTION: ${response.action}');
      debugPrint('ACTION TYPE: ${response.action?['type']}');
      debugPrint('ACTION TARGET: ${response.action?['target']}');
      debugPrint('================================');

      if (!response.success) {
        _state = VoiceAssistantState.error;
        _error = response.message;
        notifyListeners();
        return;
      }

      _conversationId = response.conversationId;
      _responseText = response.message;
      _action = response.action;

      // ── TRACE: conversationId snapshot right after it is set ──
      debugPrint('VOICE CONVERSATION AFTER SET: $_conversationId');
      // ─────────────────────────────────────────────────────────────

      // Update current screen from AI action
      // Update current screen from AI action
      final target = response.action?['target']?.toString();

      if (target == 'add_crop') {
        _currentScreen = 'add_crop';
        debugPrint('CURRENT SCREEN UPDATED: add_crop');
      } else if (target == 'my_crops') {
        _currentScreen = 'my_crops';
        debugPrint('CURRENT SCREEN UPDATED: my_crops');
      } else if (target == 'chat') {
        _currentScreen = 'chat';
        debugPrint('CURRENT SCREEN UPDATED: chat');
      } else if (target == 'farmer_dashboard') {
        _currentScreen = 'farmer_dashboard';
        debugPrint('CURRENT SCREEN UPDATED: farmer_dashboard');
      }

      debugPrint('AI RESPONSE: $_responseText');
      debugPrint('AI ACTION: $_action');

      // ── TRACE: conversationId before navigation action fires ──
      debugPrint('VOICE CONVERSATION BEFORE NAV: $_conversationId');
      // ─────────────────────────────────────────────────────────────

      // Speak AI response
      _state = VoiceAssistantState.speaking;
      notifyListeners();

      debugPrint('TTS: START');
      await _ttsService.speak(
        response.message,
        language: _language,
      );
      debugPrint('TTS: FINISHED');

      if (_action != null) {
        debugPrint('VOICE ACTION RECEIVED: $_action');
      }

      // Handle AI action
      // Handle AI action
      final actionType = response.action?['type']?.toString();
      final actionTarget = response.action?['target']?.toString();

      if (actionType == 'confirmation_required') {
        debugPrint('CONFIRMATION REQUIRED: waiting for user response');

        _state = VoiceAssistantState.idle;
        notifyListeners();

        return;
      }

// ---------------------------------------------------------
// Crop creation completed
// ---------------------------------------------------------
// Backend sends:
// type   = navigate
// target = my_crops
//
// Do NOT restart microphone after successful crop creation.
// The crop creation conversation is complete.
// ---------------------------------------------------------

      // ---------------------------------------------------------
// Navigation action completed
// Do NOT restart microphone after navigation.
// The voice interaction has handed control to the
// destination screen.
// ---------------------------------------------------------

      if (actionType == 'navigate' &&
          (actionTarget == 'my_crops' ||
              actionTarget == 'chat')) {
        debugPrint(
          'NAVIGATION COMPLETED: stopping voice conversation. '
              'target=$actionTarget',
        );

        await _voiceService.stopListening();

        _state = VoiceAssistantState.idle;
        notifyListeners();

        return;
      }

// ---------------------------------------------------------
// Normal conversational auto-listening
// ---------------------------------------------------------

      _state = VoiceAssistantState.idle;
      notifyListeners();

      await startListening(
        language: _language,
        currentScreen: _currentScreen,
      );
    } catch (e) {
      debugPrint('AI VOICE ERROR: $e');
      _state = VoiceAssistantState.error;
      _error = e.toString();
      notifyListeners();
    }
  }


  // =========================================================
  // SPEAK LOCAL MESSAGE
  // =========================================================

  Future<void> speakMessage(
      String message, {
        String? language,
      }) async {
    final text = message.trim();

    if (text.isEmpty) {
      return;
    }

    try {
      _state = VoiceAssistantState.speaking;
      notifyListeners();

      debugPrint('LOCAL TTS START: $text');

      await _ttsService.speak(
        text,
        language: language ?? _language,
      );

      debugPrint('LOCAL TTS FINISHED');

      if (_state == VoiceAssistantState.speaking) {
        _state = VoiceAssistantState.idle;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('LOCAL TTS ERROR: $e');

      _state = VoiceAssistantState.error;
      _error = e.toString();
      notifyListeners();
    }
  }

  // =========================================================
  // STOP SPEAKING
  // =========================================================

  Future<void> stopSpeaking() async {
    await _ttsService.stop();
    _state = VoiceAssistantState.idle;
    notifyListeners();
  }

  // =========================================================
  // CANCEL
  // =========================================================

  Future<void> cancelListening() async {
    await _voiceService.cancelListening();
    await _ttsService.stop();

    _recognizedText = '';
    _action = null;
    _requestSentForCurrentSpeech = false;

    _state = VoiceAssistantState.idle;
    notifyListeners();
  }

  // =========================================================
  // CLEAR CONVERSATION
  // =========================================================

  void clearConversation() {
    _ttsService.stop();
    _conversationId = null;
    _recognizedText = '';
    _responseText = '';
    _error = null;
    _action = null;
    _currentScreen = null;
    _requestSentForCurrentSpeech = false;

    _state = VoiceAssistantState.idle;
    notifyListeners();
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    _voiceService.dispose();
    _ttsService.dispose();
    super.dispose();
  }
}
