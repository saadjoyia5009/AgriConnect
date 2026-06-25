import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool isPasswordHidden = true;
  bool rememberMe = false;

  String selectedRole = "Farmer";

  String _userName = "Farmer User";
  String _email = "";
  String _phone = "";
  String _password = "";

  String get userName => _userName;
  String get email => _email;
  String get phone => _phone;
  String get password => _password;

  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    notifyListeners();
  }

  void toggleRememberMe(bool value) {
    rememberMe = value;
    notifyListeners();
  }

  void selectRole(String role) {
    selectedRole = role;
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    debugPrint("===== LOGIN API CALL =====");
    debugPrint("Email: $email");
    debugPrint("Password: $password");
    debugPrint("Role: $selectedRole");

    // Later yahan Django JWT API call hogi
    // final response = await AuthService.login(email, password);
    // save JWT token
    // return response.success;

    return true;
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    debugPrint("===== SIGNUP API CALL =====");
    debugPrint("Name: $name");
    debugPrint("Email: $email");
    debugPrint("Phone: $phone");
    debugPrint("Password: $password");
    debugPrint("Role: $selectedRole");

    // Later yahan Django JWT Register API call hogi
    // final response = await AuthService.signup(...);
    // return response.success;

    return true;
  }

  Future<bool> forgotPassword({
    required String email,
  }) async {
    debugPrint("===== FORGOT PASSWORD API CALL =====");
    debugPrint("Email: $email");

    // Later yahan Django backend API call hogi:
    // final response = await AuthService.forgotPassword(email: email);
    // return response.success;

    return true;
  }

  void logout() {
    _userName = "Farmer User";
    _email = "";
    _phone = "";
    _password = "";
    rememberMe = false;
    selectedRole = "Farmer";

    debugPrint("===== LOGOUT =====");

    notifyListeners();
  }
  bool changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    if (_password != currentPassword) {
      return false;
    }

    _password = newPassword;
    debugPrint("Password updated successfully");

    return true;
  }
}