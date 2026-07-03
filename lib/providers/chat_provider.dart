import 'package:flutter/material.dart';

import '../models/chat_message_model.dart';
import '../services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isSending = false;
  String? errorMessage;

  String? conversationId;

  final List<ChatMessageModel> _messages = [];

  List<ChatMessageModel> get messages => List.unmodifiable(_messages);

  Future<void> createConversationAndFetchMessages({
    required String inquiryId,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final conversation = await ChatService.createConversation(
        inquiryId: inquiryId,
      );

      conversationId = conversation["id"]?.toString();

      if (conversationId == null || conversationId!.isEmpty) {
        throw Exception("Conversation id not found");
      }

      final response = await ChatService.fetchMessages(
        conversationId: conversationId!,
      );

      _messages
        ..clear()
        ..addAll(
          response.map((e) => ChatMessageModel.fromJson(e)).toList(),
        );

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Failed to load chat";
      notifyListeners();
    }
  }

  Future<void> fetchMessages({
    required String conversationId,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await ChatService.fetchMessages(
        conversationId: conversationId,
      );

      _messages
        ..clear()
        ..addAll(
          response.map((e) => ChatMessageModel.fromJson(e)).toList(),
        );

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Failed to load chat";
      notifyListeners();
    }
  }

  Future<void> sendMessage({
    required String message,
  }) async {
    if (message.trim().isEmpty) return;

    if (conversationId == null || conversationId!.isEmpty) {
      errorMessage = "Conversation not found";
      notifyListeners();
      return;
    }

    try {
      isSending = true;
      errorMessage = null;
      notifyListeners();

      final response = await ChatService.sendMessage(
        conversationId: conversationId!,
        message: message.trim(),
      );

      final sentMessage = ChatMessageModel.fromJson(response);

      _messages.add(sentMessage);

      isSending = false;
      notifyListeners();
    } catch (e) {
      isSending = false;
      errorMessage = "Failed to send message";
      notifyListeners();
    }
  }

  void clearChat() {
    conversationId = null;
    _messages.clear();
    errorMessage = null;
    notifyListeners();
  }
}