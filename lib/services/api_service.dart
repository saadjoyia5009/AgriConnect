import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../utils/token_storage.dart';

class ApiService {
  static Uri _url(String endpoint) {
    return Uri.parse("${ApiConfig.baseUrl}$endpoint");
  }

  static Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    if (auth) {
      final token = await TokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }
    }

    return headers;
  }

  static Future<dynamic> post(
      String endpoint,
      Map<String, dynamic> body, {
        bool auth = false,
      }) async {
    final response = await http.post(
      _url(endpoint),
      headers: await _headers(auth: auth),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  static Future<dynamic> get(String endpoint, {bool auth = false}) async {
    final response = await http.get(
      _url(endpoint),
      headers: await _headers(auth: auth),
    );

    return _handleResponse(response);
  }

  static dynamic _handleResponse(http.Response response) {
    dynamic data;

    try {
      data = response.body.isNotEmpty ? jsonDecode(response.body) : null;
    } catch (_) {
      data = response.body;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    String message = "Something went wrong";

    if (data is Map) {
      if (data["message"] != null) {
        message = data["message"].toString();
      } else if (data["detail"] != null) {
        message = data["detail"].toString();
      } else if (data["error"] != null) {
        message = data["error"].toString();
      } else {
        final firstValue = data.values.first;

        if (firstValue is List && firstValue.isNotEmpty) {
          message = firstValue.first.toString();
        } else {
          message = firstValue.toString();
        }
      }
    } else if (data != null) {
      message = data.toString();
    }

    throw Exception(message);
  }
}