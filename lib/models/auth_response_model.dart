class AuthResponseModel {
  final bool success;
  final String message;
  final String? accessToken;
  final String? refreshToken;
  final String? role;
  final String? username;
  final String? email;

  AuthResponseModel({
    required this.success,
    required this.message,
    this.accessToken,
    this.refreshToken,
    this.role,
    this.username,
    this.email,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: true,
      message: json["message"] ?? "",
      accessToken: json["tokens"]?["access"],
      refreshToken: json["tokens"]?["refresh"],
      role: json["user"]?["role"],
      username: json["user"]?["username"],
      email: json["user"]?["email"],
    );
  }

  factory AuthResponseModel.error(String message) {
    return AuthResponseModel(
      success: false,
      message: message,
    );
  }
}