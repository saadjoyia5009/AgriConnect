import 'package:agriconnect/services/api_service.dart';

class ChatService {
  static const String _endpoint = "/chats/";

  static Future<List<dynamic>> fetchConversations() async {
    final response = await ApiService.get(
      _endpoint,
      auth: true,
    );

    if (response is List) {
      return response;
    }

    if (response is Map) {
      if (response["results"] is List) {
        return response["results"] as List<dynamic>;
      }

      if (response["data"] is List) {
        return response["data"] as List<dynamic>;
      }
    }

    return [];
  }

  static Future<Map<String, dynamic>> createConversation({
    required String inquiryId,
  }) async {
    final response = await ApiService.post(
      _endpoint,
      {
        "inquiry": inquiryId,
      },
      auth: true,
    );

    if (response is Map) {
      final responseData = response["data"];

      if (responseData is Map) {
        return Map<String, dynamic>.from(responseData);
      }

      return Map<String, dynamic>.from(response);
    }

    throw Exception("Invalid conversation response.");
  }

  static Future<List<dynamic>> fetchMessages({
    required String conversationId,
  }) async {
    final response = await ApiService.get(
      "$_endpoint$conversationId/messages/",
      auth: true,
    );

    if (response is List) {
      return response;
    }

    if (response is Map) {
      if (response["results"] is List) {
        return response["results"] as List<dynamic>;
      }

      if (response["data"] is List) {
        return response["data"] as List<dynamic>;
      }
    }

    return [];
  }

  static Future<Map<String, dynamic>> sendMessage({
    required String conversationId,
    required String message,
  }) async {
    final cleanedMessage = message.trim();

    if (cleanedMessage.isEmpty) {
      throw Exception("Message cannot be empty.");
    }

    final response = await ApiService.post(
      "$_endpoint$conversationId/messages/",
      {
        "text": cleanedMessage,
      },
      auth: true,
    );

    if (response is Map) {
      final responseData = response["data"];

      if (responseData is Map) {
        return Map<String, dynamic>.from(responseData);
      }

      return Map<String, dynamic>.from(response);
    }

    throw Exception("Invalid message response.");
  }
}