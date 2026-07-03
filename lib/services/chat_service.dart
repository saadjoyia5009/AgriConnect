import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../utils/token_storage.dart';

class ChatService {
  static Future<Map<String, dynamic>> createConversation({
    required String inquiryId,
  }) async {
    final token = await TokenStorage.getAccessToken();

    final url = Uri.parse("${ApiConfig.baseUrl}/chat/");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "inquiry": inquiryId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data["data"] ?? data;
    }

    throw Exception("Failed to create conversation");
  }

  static Future<List<dynamic>> fetchMessages({
    required String conversationId,
  }) async {
    final token = await TokenStorage.getAccessToken();

    final url = Uri.parse(
      "${ApiConfig.baseUrl}/chat/$conversationId/messages/",
    );

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      // Handle Django REST Framework paginated response
      if (decoded is List) {
        return decoded;
      }

      // DRF may wrap results in {"results": [...]} or {"data": [...]}
      if (decoded is Map) {
        if (decoded["results"] is List) return decoded["results"];
        if (decoded["data"] is List) return decoded["data"];
      }

      return [];
    }

    throw Exception("Failed to fetch messages");
  }

  static Future<Map<String, dynamic>> sendMessage({
    required String conversationId,
    required String message,
  }) async {
    final token = await TokenStorage.getAccessToken();

    final url = Uri.parse(
      "${ApiConfig.baseUrl}/chat/$conversationId/messages/",
    );

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "text": message,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["data"] ?? data;
    }

    throw Exception("Failed to send message");
  }
}