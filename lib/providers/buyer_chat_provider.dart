import 'package:flutter/material.dart';

import '../models/chat_conversation_model.dart';
import '../services/chat_service.dart';

class BuyerChatProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  final List<ChatConversationModel> _conversations = [];
  List<ChatConversationModel> _filteredConversations = [];

  List<ChatConversationModel> get conversations {
    return List.unmodifiable(_conversations);
  }

  List<ChatConversationModel> get filteredConversations {
    return List.unmodifiable(_filteredConversations);
  }

  Future<void> fetchBuyerConversations() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await ChatService.fetchConversations();

      final loadedConversations = response.map((item) {
        return ChatConversationModel.fromJson(
          Map<String, dynamic>.from(item),
        );
      }).toList();

      _conversations
        ..clear()
        ..addAll(loadedConversations);

      _filteredConversations = List.from(_conversations);
    } catch (error) {
      errorMessage = error
          .toString()
          .replaceFirst('Exception: ', '');

      if (errorMessage == null || errorMessage!.trim().isEmpty) {
        errorMessage = 'Failed to load chats';
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    final value = query.trim().toLowerCase();

    if (value.isEmpty) {
      _filteredConversations = List.from(_conversations);
      notifyListeners();
      return;
    }

    _filteredConversations = _conversations.where((conversation) {
      return conversation.farmerName.toLowerCase().contains(value) ||
          conversation.cropName.toLowerCase().contains(value) ||
          conversation.lastMessage.toLowerCase().contains(value);
    }).toList();

    notifyListeners();
  }

  void clear() {
    _conversations.clear();
    _filteredConversations.clear();
    errorMessage = null;
    isLoading = false;
    notifyListeners();
  }
}