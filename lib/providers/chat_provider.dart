import 'package:flutter/material.dart';
import '../models/chat_message_model.dart';
import '../models/chat_message_model.dart';
import '../services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isSending = false;
  bool _isConversationLoading = false;

  String? _errorMessage;
  String? _conversationErrorMessage;
  String? _conversationId;

  final List<ChatMessageModel> _messages = [];
  final List<ChatConversationModel> _conversations = [];

  bool get isLoading => _isLoading;
  bool get isSending => _isSending;

  bool get isConversationLoading {
    return _isConversationLoading;
  }

  String? get errorMessage => _errorMessage;

  String? get conversationErrorMessage {
    return _conversationErrorMessage;
  }

  String? get conversationId => _conversationId;

  List<ChatMessageModel> get messages {
    return List.unmodifiable(_messages);
  }

  List<ChatConversationModel> get conversations {
    return List.unmodifiable(_conversations);
  }

  int get totalUnreadCount {
    return _conversations.fold(
      0,
          (total, conversation) {
        return total + conversation.unreadCount;
      },
    );
  }

  Future<void> fetchConversations({
    bool showLoading = true,
  }) async {
    if (_isConversationLoading) return;

    try {
      _isConversationLoading = true;
      _conversationErrorMessage = null;

      if (showLoading) {
        notifyListeners();
      }

      final response =
      await ChatService.fetchConversations();

      final loadedConversations = response
          .whereType<Map>()
          .map(
            (item) => ChatConversationModel.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList();

      loadedConversations.sort((first, second) {
        final firstTime =
            first.displayTime ??
                DateTime.fromMillisecondsSinceEpoch(0);

        final secondTime =
            second.displayTime ??
                DateTime.fromMillisecondsSinceEpoch(0);

        return secondTime.compareTo(firstTime);
      });

      _conversations
        ..clear()
        ..addAll(loadedConversations);
    } catch (error) {
      _conversationErrorMessage = _cleanError(error);
    } finally {
      _isConversationLoading = false;
      notifyListeners();
    }
  }

  Future<void> initializeChat({
    required String inquiryId,
    String? conversationId,
  }) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _errorMessage = null;
      _messages.clear();
      notifyListeners();

      final existingConversationId =
      conversationId?.trim();

      if (
      existingConversationId != null &&
          existingConversationId.isNotEmpty
      ) {
        _conversationId = existingConversationId;
      } else {
        final conversation =
        await ChatService.createConversation(
          inquiryId: inquiryId,
        );

        _conversationId =
            conversation["id"]?.toString();
      }

      if (
      _conversationId == null ||
          _conversationId!.trim().isEmpty
      ) {
        throw Exception(
          "Conversation ID was not found.",
        );
      }

      await _loadMessagesWithoutLoadingState();
    } catch (error) {
      _errorMessage = _cleanError(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createConversationAndFetchMessages({
    required String inquiryId,
  }) async {
    await initializeChat(
      inquiryId: inquiryId,
    );
  }

  Future<void> fetchMessages({
    String? conversationId,
    bool showLoading = true,
  }) async {
    if (_isLoading) return;

    final requestedConversationId =
    conversationId?.trim();

    if (
    requestedConversationId != null &&
        requestedConversationId.isNotEmpty
    ) {
      _conversationId = requestedConversationId;
    }

    if (
    _conversationId == null ||
        _conversationId!.trim().isEmpty
    ) {
      _errorMessage = "Conversation not found.";
      notifyListeners();
      return;
    }

    try {
      if (showLoading) {
        _isLoading = true;
      }

      _errorMessage = null;
      notifyListeners();

      await _loadMessagesWithoutLoadingState();

      await fetchConversations(
        showLoading: false,
      );
    } catch (error) {
      _errorMessage = _cleanError(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendMessage({
    required String message,
  }) async {
    final cleanedMessage = message.trim();

    if (cleanedMessage.isEmpty) {
      return false;
    }

    if (cleanedMessage.length > 5000) {
      _errorMessage =
      "Message cannot contain more than 5000 characters.";
      notifyListeners();
      return false;
    }

    if (
    _conversationId == null ||
        _conversationId!.trim().isEmpty
    ) {
      _errorMessage = "Conversation not found.";
      notifyListeners();
      return false;
    }

    if (_isSending) {
      return false;
    }

    try {
      _isSending = true;
      _errorMessage = null;
      notifyListeners();

      final response = await ChatService.sendMessage(
        conversationId: _conversationId!,
        message: cleanedMessage,
      );

      final sentMessage =
      ChatMessageModel.fromJson(response);

      _messages.add(sentMessage);

      await fetchConversations(
        showLoading: false,
      );

      return true;
    } catch (error) {
      _errorMessage = _cleanError(error);
      return false;
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  Future<void> _loadMessagesWithoutLoadingState() async {
    final response = await ChatService.fetchMessages(
      conversationId: _conversationId!,
    );

    final loadedMessages = response
        .whereType<Map>()
        .map(
          (item) => ChatMessageModel.fromJson(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();

    loadedMessages.sort(
          (first, second) {
        return first.createdAt.compareTo(
          second.createdAt,
        );
      },
    );

    _messages
      ..clear()
      ..addAll(loadedMessages);
  }

  void clearMessageError() {
    if (_errorMessage == null) return;

    _errorMessage = null;
    notifyListeners();
  }

  void clearConversationError() {
    if (_conversationErrorMessage == null) return;

    _conversationErrorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    _conversationErrorMessage = null;
    notifyListeners();
  }

  void clearChat() {
    _conversationId = null;
    _messages.clear();
    _errorMessage = null;
    _isLoading = false;
    _isSending = false;
    notifyListeners();
  }

  void clearAll() {
    _conversationId = null;
    _messages.clear();
    _conversations.clear();

    _errorMessage = null;
    _conversationErrorMessage = null;

    _isLoading = false;
    _isSending = false;
    _isConversationLoading = false;

    notifyListeners();
  }

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst("Exception: ", "")
        .trim();
  }
}