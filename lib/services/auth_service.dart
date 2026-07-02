import '../utils/token_storage.dart';
import 'api_service.dart';

class AuthResponse {
  final bool success;
  final String message;
  final String? username;
  final String? email;
  final String? role;

  AuthResponse({
    required this.success,
    required this.message,
    this.username,
    this.email,
    this.role,
  });
}

class AuthService {
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post(
        "/login/",
        {
          "email": email,
          "password": password,
        },
      );

      final tokens = response["tokens"];

      if (tokens != null &&
          tokens["access"] != null &&
          tokens["refresh"] != null) {
        await TokenStorage.saveTokens(
          tokens["access"].toString(),
          tokens["refresh"].toString(),
        );
      }

      final user = response["user"];

      return AuthResponse(
        success: true,
        message: response["message"]?.toString() ?? "Login successful",
        username: user?["username"]?.toString(),
        email: user?["email"]?.toString() ?? email,
        role: user?["role"]?.toString(),
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: e.toString().replaceAll("Exception:", "").trim(),
      );
    }
  }

  Future<AuthResponse> register({
    required String username,
    required String email,
    required String password,
    required String password2,
    required String role,
    required String phone,
    required String address,
  }) async {
    try {
      final response = await ApiService.post(
        "/register/",
        {
          "username": username,
          "email": email,
          "password": password,
          "password2": password2,
          "role": role,
          "phone": phone,
          "address": address,
        },
      );

      return AuthResponse(
        success: true,
        message: "Account created successfully",
        username: response["username"]?.toString() ?? username,
        email: response["email"]?.toString() ?? email,
        role: response["role"]?.toString() ?? role,
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: e.toString().replaceAll("Exception:", "").trim(),
      );
    }
  }

  Future<void> logout() async {
    await TokenStorage.clearTokens();
  }
}