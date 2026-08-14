import 'package:flutter/foundation.dart';

import '../services/ai_chat_service.dart';
import '../services/voice_assistant_service.dart';

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

  VoiceAssistantState _state = VoiceAssistantState.idle;

  String _recognizedText = '';
  String _responseText = '';
  String? _error;

  String? _conversationId;
  Map<String, dynamic>? _action;

  VoiceAssistantState get state => _state;

  String get recognizedText => _recognizedText;

  String get responseText => _responseText;

  String? get error => _error;

  String? get conversationId => _conversationId;

  String? get actionType => _action?['type']?.toString();

  String? get actionTarget => _action?['target']?.toString();

  Map<String, dynamic>? get action => _action;

  bool get isListening => _state == VoiceAssistantState.listening;

  bool get isProcessing => _state == VoiceAssistantState.processing;

  bool get isSpeaking => _state == VoiceAssistantState.speaking;

  // ---------------------------------------------------------
  // Start Listening
  // ---------------------------------------------------------

  Future<void> startListening({
    String language = 'en',
  }) async {
    if (_state == VoiceAssistantState.listening ||
        _state == VoiceAssistantState.processing) {
      return;
    }

    _error = null;
    _recognizedText = '';
    _responseText = '';
    _action = null;

    _state = VoiceAssistantState.listening;

    notifyListeners();

    // English / Urdu locale
    final String localeId = language == 'ur' ? 'ur_PK' : 'en_US';

    debugPrint(
      'VOICE LANGUAGE: $language',
    );

    debugPrint(
      'VOICE LOCALE: $localeId',
    );

    final bool started = await _voiceService.startListening(
      localeId: localeId,
      onResult: (text) {
        debugPrint(
          'VOICE RESULT: $text',
        );

        _recognizedText = text;

        notifyListeners();
      },
      onError: (message) {
        debugPrint(
          'VOICE ERROR: $message',
        );

        _state = VoiceAssistantState.error;

        _error = message;

        notifyListeners();
      },
      onStatus: (status) {
        debugPrint(
          'VOICE STATUS: $status',
        );
      },
    );

    if (!started) {
      _state = VoiceAssistantState.error;

      _error = 'Microphone or speech recognition is not available.';

      notifyListeners();
    }
  }

  // ---------------------------------------------------------
  // Stop Listening
  // ---------------------------------------------------------

  Future<void> stopListening({
    String? currentScreen,
  }) async {
    if (_state != VoiceAssistantState.listening) {
      return;
    }

    await _voiceService.stopListening();

    final String text = _recognizedText.trim();

    debugPrint(
      'FINAL VOICE TEXT: $text',
    );

    if (text.isEmpty) {
      _state = VoiceAssistantState.idle;

      _error = 'I could not understand your voice.';

      notifyListeners();

      return;
    }

    await _sendToAI(
      text,
      currentScreen: currentScreen,
    );
  }

  // ---------------------------------------------------------
  // Send Voice Text to AI
  // ---------------------------------------------------------

  Future<void> _sendToAI(
      String text, {
        String? currentScreen,
      }) async {
    _state = VoiceAssistantState.processing;

    _error = null;

    notifyListeners();

    try {
      debugPrint(
        'SENDING VOICE TEXT TO AI: $text',
      );

      final AIChatResponse response = await _aiService.sendMessage(
        message: text,
        conversationId: _conversationId,
        currentScreen: currentScreen,
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

      debugPrint(
        'AI RESPONSE: $_responseText',
      );

      debugPrint(
        'AI ACTION: $_action',
      );

      _state = VoiceAssistantState.speaking;

      notifyListeners();

      // TTS next step mein add karenge.

      _state = VoiceAssistantState.idle;

      notifyListeners();
    } catch (e) {
      debugPrint(
        'AI VOICE ERROR: $e',
      );

      _state = VoiceAssistantState.error;

      _error = e.toString();

      notifyListeners();
    }
  }

  // ---------------------------------------------------------
  // Cancel Listening
  // ---------------------------------------------------------

  Future<void> cancelListening() async {
    await _voiceService.cancelListening();

    _recognizedText = '';

    _state = VoiceAssistantState.idle;

    notifyListeners();
  }

  // ---------------------------------------------------------
  // Clear Conversation
  // ---------------------------------------------------------

  void clearConversation() {
    _conversationId = null;

    _recognizedText = '';

    _responseText = '';

    _error = null;

    _action = null;

    _state = VoiceAssistantState.idle;

    notifyListeners();
  }

  // ---------------------------------------------------------
  // Dispose
  // ---------------------------------------------------------

  @override
  void dispose() {
    _voiceService.dispose();

    super.dispose();
  }
}