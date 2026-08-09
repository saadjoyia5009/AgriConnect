import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/api_config.dart';

class AIChatResponse {
  final bool success;
  final String message;
  final String? conversationId;

  const AIChatResponse({
    required this.success,
    required this.message,
    this.conversationId,
  });

  factory AIChatResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return AIChatResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      conversationId:
      json['conversation_id']?.toString(),
    );
  }
}

class AIChatService {
  final FlutterSecureStorage _storage =
  const FlutterSecureStorage();

  Future<AIChatResponse> sendMessage({
    required String message,
    String? conversationId,
    String? currentScreen,
  }) async {
    final token = await _storage.read(
      key: 'access_token',
    );

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token not found.');
    }

    final response = await http.post(
      Uri.parse(
        '${ApiConfig.baseUrl}/api/ai/chat/',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'message': message,
        if (conversationId != null)
          'conversation_id': conversationId,
        if (currentScreen != null)
          'current_screen': currentScreen,
      }),
    );

    Map<String, dynamic> data;

    try {
      data = jsonDecode(response.body)
      as Map<String, dynamic>;
    } catch (_) {
      throw Exception(
        'Invalid response from AI server.',
      );
    }

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return AIChatResponse.fromJson(data);
    }

    throw Exception(
      data['message']?.toString() ??
          'Unable to process AI request.',
    );
  }
}