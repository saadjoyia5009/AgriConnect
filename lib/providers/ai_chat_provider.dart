import 'package:flutter/foundation.dart';

import '../models/ai_chat_message.dart';
import '../services/ai_chat_service.dart';

class AIChatProvider extends ChangeNotifier {
  final AIChatService _service = AIChatService();

  final List<AIChatMessage> _messages = [];

  String? _conversationId;
  bool _isLoading = false;
  String? _error;

  List<AIChatMessage> get messages =>
      List.unmodifiable(_messages);

  String? get conversationId => _conversationId;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> sendMessage({
    required String message,
    String? currentScreen,
  }) async {
    final trimmedMessage = message.trim();

    if (trimmedMessage.isEmpty || _isLoading) {
      return;
    }

    _error = null;

    _messages.add(
      AIChatMessage(
        role: 'user',
        content: trimmedMessage,
        createdAt: DateTime.now(),
      ),
    );

    _isLoading = true;

    notifyListeners();

    try {
      final response = await _service.sendMessage(
        message: trimmedMessage,
        conversationId: _conversationId,
        currentScreen: currentScreen,
      );

      if (response.success) {
        _conversationId = response.conversationId;

        _messages.add(
          AIChatMessage(
            role: 'assistant',
            content: response.message,
            createdAt: DateTime.now(),
          ),
        );
      } else {
        _error = response.message;
      }
    } catch (e) {
      _error = 'Unable to process your request.';
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  void clearConversation() {
    _messages.clear();
    _conversationId = null;
    _error = null;

    notifyListeners();
  }
}