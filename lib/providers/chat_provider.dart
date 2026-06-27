import 'package:flutter/material.dart';
import '../models/chat_message_model.dart';

class ChatProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isSending = false;
  String? errorMessage;

  final List<ChatMessageModel> _messages = [];

  List<ChatMessageModel> get messages => List.unmodifiable(_messages);

  Future<void> fetchMessages({
    required String chatId,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      // Later:
      // final response = await ChatService.fetchMessages(chatId);
      // _messages
      //   ..clear()
      //   ..addAll(response.map((e) => ChatMessageModel.fromJson(e)));

      await Future.delayed(const Duration(milliseconds: 400));

      _messages
        ..clear()
        ..addAll([
          ChatMessageModel(
            id: "1",
            chatId: chatId,
            senderId: "buyer_1",
            receiverId: "farmer_1",
            message: "Hello, I am interested in your crop.",
            createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
            isRead: true,
          ),
          ChatMessageModel(
            id: "2",
            chatId: chatId,
            senderId: "farmer_1",
            receiverId: "buyer_1",
            message: "Yes, it is available. How much quantity do you need?",
            createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
            isRead: true,
          ),
        ]);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Failed to load chat";
      notifyListeners();
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    if (message.trim().isEmpty) return;

    final newMessage = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId,
      senderId: senderId,
      receiverId: receiverId,
      message: message.trim(),
      createdAt: DateTime.now(),
    );

    _messages.add(newMessage);
    notifyListeners();

    // Later:
    // await ChatService.sendMessage(newMessage.toJson());
  }
}