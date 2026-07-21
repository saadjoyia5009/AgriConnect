import '../utils/token_storage.dart';
import 'api_service.dart';

class AuthResponse {
  final bool success;
  final String message;
  final String? username;
  final String? email;
  final String? role;
  final int? userId;

  AuthResponse({
    required this.success,
    required this.message,
    this.username,
    this.email,
    this.role,
    this.userId,
  });
}

class AuthService {
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiService.post("/login/", {
        "email": email,
        "password": password,
      });

      final tokens = response["tokens"];

      if (tokens != null &&
          tokens["access"] != null &&
          tokens["refresh"] != null) {
        await TokenStorage.saveTokens(
          tokens["access"].toString(),
          tokens["refresh"].toString(),
        );
      }

      final userData = response["user"];
      final int? parsedUserId = userData is Map
          ? int.tryParse(userData["id"]?.toString() ?? "")
          : null;

      return AuthResponse(
        success: true,
        message: response["message"]?.toString() ?? "Login successful",
        username: userData?["username"]?.toString(),
        email: userData?["email"]?.toString() ?? email,
        role: userData?["role"]?.toString(),
        userId: parsedUserId,
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
      await TokenStorage.clearTokens(); // add this

      final response = await ApiService.post("/register/", {
        "username": username,
        "email": email,
        "password": password,
        "password2": password2,
        "role": role,
        "phone": phone,
        "address": address,
      });

      final data = response["data"];

      return AuthResponse(
        success: true,
        message:
            response["message"]?.toString() ??
            "Account created successfully. Please verify your email.",
        username: data?["username"]?.toString() ?? username,
        email: data?["email"]?.toString() ?? email,
        role: data?["role"]?.toString() ?? role,
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: e.toString().replaceAll("Exception:", "").trim(),
      );
    }
  }

  Future<AuthResponse> verifyEmailOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await ApiService.post("/verify-email-otp/", {
        "email": email,
        "otp": otp,
      });

      return AuthResponse(
        success: true,
        message:
            response["message"]?.toString() ?? "Email verified successfully",
        email: email,
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: e.toString().replaceAll("Exception:", "").trim(),
      );
    }
  }

  Future<AuthResponse> forgotPassword({required String email}) async {
    try {
      final response = await ApiService.post("/forgot-password/", {
        "email": email,
      });

      return AuthResponse(
        success: true,
        message: response["otp"] != null
            ? "OTP: ${response["otp"]}"
            : response["message"]?.toString() ?? "OTP sent successfully",
        email: email,
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: e.toString().replaceAll("Exception:", "").trim(),
      );
    }
  }

  Future<AuthResponse> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await ApiService.post("/verify-reset-otp/", {
        "email": email,
        "otp": otp,
      });

      return AuthResponse(
        success: true,
        message: response["message"]?.toString() ?? "OTP verified successfully",
        email: email,
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: e.toString().replaceAll("Exception:", "").trim(),
      );
    }
  }

  Future<AuthResponse> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await ApiService.post("/reset-password/", {
        "email": email,
        "otp": otp,
        "new_password": newPassword,
        "confirm_password": confirmPassword,
      });

      return AuthResponse(
        success: true,
        message:
            response["message"]?.toString() ?? "Password reset successfully",
        email: email,
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
