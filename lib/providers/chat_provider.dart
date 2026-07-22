import 'package:flutter/material.dart';

import '../models/chat_message_model.dart';
import '../models/chat_conversation_model.dart';
import '../services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isSending = false;

  String? errorMessage;
  String? conversationId;

  final List<ChatMessageModel> _messages = [];
  final List<ChatConversationModel> _conversations = [];
  bool isConversationLoading = false;
  String? conversationErrorMessage;

  List<ChatMessageModel> get messages {
    return List.unmodifiable(_messages);
  }

  List<ChatConversationModel> get conversations =>
      List.unmodifiable(_conversations);

  Future<void> fetchConversations({bool showLoading = true}) async {
    try {
      if (showLoading) isConversationLoading = true;
      conversationErrorMessage = null;
      notifyListeners();

      final response = await ChatService.fetchConversations();
      _conversations
        ..clear()
        ..addAll(
          response.map(
            (item) =>
                ChatConversationModel.fromJson(Map<String, dynamic>.from(item)),
          ),
        );
    } catch (error) {
      conversationErrorMessage = _cleanError(
        error,
        fallback: "Failed to load chats",
      );
    } finally {
      isConversationLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // CREATE OR GET CONVERSATION, THEN FETCH MESSAGES
  // =========================================================

  Future<void> createConversationAndFetchMessages({
    required String inquiryId,
  }) async {
    if (inquiryId.trim().isEmpty) {
      errorMessage = "Inquiry ID is required";
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final conversation = await ChatService.createConversation(
        inquiryId: inquiryId,
      );

      conversationId =
          conversation["id"]?.toString() ??
          conversation["conversation_id"]?.toString();

      if (conversationId == null || conversationId!.isEmpty) {
        throw Exception("Conversation ID not found");
      }

      final response = await ChatService.fetchMessages(
        conversationId: conversationId!,
      );

      _messages
        ..clear()
        ..addAll(
          response.map((item) {
            return ChatMessageModel.fromJson(Map<String, dynamic>.from(item));
          }),
        );
    } catch (error) {
      errorMessage = _cleanError(error, fallback: "Failed to load chat");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // FETCH EXISTING CONVERSATION MESSAGES
  // Buyer aur Farmer dono is method ko use karenge
  // =========================================================

  Future<void> fetchMessages({
    required String conversationId,
    bool showLoading = true,
  }) async {
    if (conversationId.trim().isEmpty) {
      errorMessage = "Conversation ID is required";
      notifyListeners();
      return;
    }

    try {
      if (showLoading) isLoading = true;
      errorMessage = null;

      // Important:
      // Provider ki conversation ID bhi set karni zaroori hai.
      this.conversationId = conversationId;

      notifyListeners();

      final response = await ChatService.fetchMessages(
        conversationId: conversationId,
      );

      _messages
        ..clear()
        ..addAll(
          response.map((item) {
            return ChatMessageModel.fromJson(Map<String, dynamic>.from(item));
          }),
        );
    } catch (error) {
      errorMessage = _cleanError(error, fallback: "Failed to load chat");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // SEND MESSAGE
  // =========================================================

  Future<bool> sendMessage({required String message}) async {
    final cleanMessage = message.trim();

    if (cleanMessage.isEmpty) {
      return false;
    }

    if (conversationId == null || conversationId!.isEmpty) {
      errorMessage = "Conversation not found";
      notifyListeners();
      return false;
    }

    if (isSending) {
      return false;
    }

    try {
      isSending = true;
      errorMessage = null;
      notifyListeners();

      final response = await ChatService.sendMessage(
        conversationId: conversationId!,
        message: cleanMessage,
      );

      final sentMessage = ChatMessageModel.fromJson(
        Map<String, dynamic>.from(response),
      );

      _messages.add(sentMessage);

      return true;
    } catch (error) {
      errorMessage = _cleanError(error, fallback: "Failed to send message");

      return false;
    } finally {
      isSending = false;
      notifyListeners();
    }
  }

  // =========================================================
  // REFRESH MESSAGES WITHOUT FULL-SCREEN LOADING
  // =========================================================

  Future<void> refreshMessages() async {
    final currentConversationId = conversationId;

    if (currentConversationId == null || currentConversationId.isEmpty) {
      return;
    }

    try {
      errorMessage = null;

      final response = await ChatService.fetchMessages(
        conversationId: currentConversationId,
      );

      _messages
        ..clear()
        ..addAll(
          response.map((item) {
            return ChatMessageModel.fromJson(Map<String, dynamic>.from(item));
          }),
        );

      notifyListeners();
    } catch (error) {
      errorMessage = _cleanError(error, fallback: "Failed to refresh messages");

      notifyListeners();
    }
  }

  // =========================================================
  // MARK LOCAL MESSAGES AS READ
  // =========================================================

  void markLocalMessagesAsRead({required String currentUserId}) {
    for (int index = 0; index < _messages.length; index++) {
      final message = _messages[index];

      if (message.senderId != currentUserId && !message.isRead) {
        _messages[index] = message.copyWith(isRead: true);
      }
    }

    notifyListeners();
  }

  // =========================================================
  // CLEAR ERROR
  // =========================================================

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  // =========================================================
  // CLEAR CURRENT CHAT
  // =========================================================

  void clearChat() {
    conversationId = null;
    _messages.clear();
    errorMessage = null;
    isLoading = false;
    isSending = false;
    notifyListeners();
  }

  // =========================================================
  // CLEAN ERROR MESSAGE
  // =========================================================

  String _cleanError(Object error, {required String fallback}) {
    final message = error.toString().replaceFirst("Exception: ", "");

    if (message.trim().isEmpty) {
      return fallback;
    }

    return message;
  }
}
