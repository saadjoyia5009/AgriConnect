import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../config/api_config.dart';
import '../utils/token_storage.dart';

class AIChatResponse {
  final bool success;
  final String message;
  final String? conversationId;
  final Map<String, dynamic>? action;

  const AIChatResponse({
    required this.success,
    required this.message,
    this.conversationId,
    this.action,
  });

  factory AIChatResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawAction = json['action'];

    return AIChatResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      conversationId:
      json['conversation_id']?.toString(),
      action: rawAction is Map
          ? Map<String, dynamic>.from(rawAction)
          : null,
    );
  }
}

class AIChatService {
  Future<AIChatResponse> sendMessage({
    required String message,
    String? conversationId,
    String? currentScreen,
  }) async {
    // ---------------------------------------------------------
    // Get JWT access token
    // ---------------------------------------------------------

    final token =
    await TokenStorage.getAccessToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'Authentication token not found.',
      );
    }

    // ---------------------------------------------------------
    // Send request
    // ---------------------------------------------------------

    final response = await http.post(
      Uri.parse(
        '${ApiConfig.baseUrl}/ai/chat/',
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

    debugPrint(
      'AI URL: ${response.request?.url}',
    );

    debugPrint(
      'AI STATUS: ${response.statusCode}',
    );

    debugPrint(
      'AI BODY: ${response.body}',
    );

    // ---------------------------------------------------------
    // Decode response
    // ---------------------------------------------------------

    Map<String, dynamic> data;

    try {
      final decoded = jsonDecode(
        response.body,
      );

      if (decoded is! Map) {
        throw Exception(
          'Server returned non-object JSON.',
        );
      }

      data = Map<String, dynamic>.from(
        decoded,
      );
    } catch (_) {
      throw Exception(
        'Invalid response from AI server. '
            'Status: ${response.statusCode}. '
            'Body: ${response.body}',
      );
    }

    // ---------------------------------------------------------
    // Success
    // ---------------------------------------------------------

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return AIChatResponse.fromJson(
        data,
      );
    }

    // ---------------------------------------------------------
    // Error
    // ---------------------------------------------------------

    throw Exception(
      data['message']?.toString() ??
          'Unable to process AI request.',
    );
  }
}