import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/auth_response_model.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.login),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final authResponse = AuthResponseModel.fromJson(data);

        await _storage.write(
          key: "access_token",
          value: authResponse.accessToken,
        );

        await _storage.write(
          key: "refresh_token",
          value: authResponse.refreshToken,
        );

        await _storage.write(
          key: "user_role",
          value: authResponse.role,
        );

        await _storage.write(
          key: "username",
          value: authResponse.username,
        );

        await _storage.write(
          key: "email",
          value: authResponse.email,
        );

        return authResponse;
      }

      return AuthResponseModel.error(
        data["error"] ??
            data["message"] ??
            "Login failed",
      );
    } catch (e) {
      return AuthResponseModel.error(
        "Server connection failed. Please check backend server.",
      );
    }
  }

  Future<AuthResponseModel> register({
    required String username,
    required String email,
    required String password,
    required String password2,
    required String role,
    String? phone,
    String? address,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.register),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
          "password2": password2,
          "role": role,
          "phone": phone ?? "",
          "address": address ?? "",
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return AuthResponseModel(
          success: true,
          message: data["message"] ?? "Registration successful",
          role: data["data"]?["role"],
          username: data["data"]?["username"],
          email: data["data"]?["email"],
        );
      }

      return AuthResponseModel.error(
        data["error"] ??
            data["email"]?.toString() ??
            data["username"]?.toString() ??
            data["message"] ??
            "Registration failed",
      );
    } catch (e) {
      return AuthResponseModel.error(
        "Server connection failed. Please check backend server.",
      );
    }
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: "access_token");
  }

  Future<String?> getUserRole() async {
    return await _storage.read(key: "user_role");
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }
}