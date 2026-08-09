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
      final cleanEmail = email.trim().toLowerCase();

      final response = await ApiService.post("/login/", {
        "email": cleanEmail,
        "password": password,
      });
      print(response);

      final dynamic tokensData = response["tokens"];

      if (tokensData is Map &&
          tokensData["access"] != null &&
          tokensData["refresh"] != null) {
        await TokenStorage.saveTokens(
          tokensData["access"].toString(),
          tokensData["refresh"].toString(),
        );
      } else {
        throw Exception("Login tokens were not received from server.");
      }

      final dynamic rawUserData = response["user"];
      final Map<String, dynamic> userData = rawUserData is Map
          ? Map<String, dynamic>.from(rawUserData)
          : <String, dynamic>{};

      final int? parsedUserId = int.tryParse(
        userData["id"]?.toString() ?? "",
      );

      return AuthResponse(
        success: true,
        message: response["message"]?.toString() ?? "Login successful",
        username: userData["username"]?.toString(),
        email: userData["email"]?.toString() ?? cleanEmail,
        role: userData["role"]?.toString(),
        userId: parsedUserId,
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: _cleanErrorMessage(e),
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
      final cleanUsername = username.trim();
      final cleanEmail = email.trim().toLowerCase();
      final cleanRole = role.trim().toLowerCase();
      final cleanPhone = phone.trim();
      final cleanAddress = address.trim();

      /*
       * Signup se pehle purane tokens clear karna useful hai,
       * taa ke previous user ki session accidentally active na rahe.
       */
      await TokenStorage.clearTokens();

      final response = await ApiService.post("/register/", {
        "username": cleanUsername,
        "email": cleanEmail,
        "password": password,
        "password2": password2,
        "role": cleanRole,
        "phone": cleanPhone,
        "address": cleanAddress,
      });

      final dynamic rawData = response["data"];
      final Map<String, dynamic> data = rawData is Map
          ? Map<String, dynamic>.from(rawData)
          : <String, dynamic>{};

      return AuthResponse(
        success: true,
        message:
        response["message"]?.toString() ??
            "Account created successfully. Please login.",
        username: data["username"]?.toString() ?? cleanUsername,
        email: data["email"]?.toString() ?? cleanEmail,
        role: data["role"]?.toString() ?? cleanRole,
        userId: int.tryParse(
          data["id"]?.toString() ?? "",
        ),
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: _cleanErrorMessage(e),
      );
    }
  }

  Future<AuthResponse> verifyEmailOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final cleanEmail = email.trim().toLowerCase();
      final cleanOtp = otp.trim();

      final response = await ApiService.post("/verify-email-otp/", {
        "email": cleanEmail,
        "otp": cleanOtp,
      });

      return AuthResponse(
        success: true,
        message:
        response["message"]?.toString() ??
            "Email verified successfully",
        email: cleanEmail,
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: _cleanErrorMessage(e),
      );
    }
  }

  Future<AuthResponse> forgotPassword({
    required String email,
  }) async {
    try {
      final cleanEmail = email.trim().toLowerCase();

      final response = await ApiService.post("/forgot-password/", {
        "email": cleanEmail,
      });

      return AuthResponse(
        success: true,
        message: response["otp"] != null
            ? "OTP: ${response["otp"]}"
            : response["message"]?.toString() ??
            "OTP sent successfully",
        email: cleanEmail,
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: _cleanErrorMessage(e),
      );
    }
  }

  Future<AuthResponse> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final cleanEmail = email.trim().toLowerCase();
      final cleanOtp = otp.trim();

      final response = await ApiService.post("/verify-reset-otp/", {
        "email": cleanEmail,
        "otp": cleanOtp,
      });

      return AuthResponse(
        success: true,
        message:
        response["message"]?.toString() ??
            "OTP verified successfully",
        email: cleanEmail,
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: _cleanErrorMessage(e),
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
      final cleanEmail = email.trim().toLowerCase();
      final cleanOtp = otp.trim();

      final response = await ApiService.post("/reset-password/", {
        "email": cleanEmail,
        "otp": cleanOtp,
        "new_password": newPassword,
        "confirm_password": confirmPassword,
      });

      return AuthResponse(
        success: true,
        message:
        response["message"]?.toString() ??
            "Password reset successfully",
        email: cleanEmail,
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: _cleanErrorMessage(e),
      );
    }
  }

  Future<void> logout() async {
    await TokenStorage.clearTokens();
  }

  String _cleanErrorMessage(Object error) {
    return error
        .toString()
        .replaceFirst("Exception:", "")
        .trim();
  }
}