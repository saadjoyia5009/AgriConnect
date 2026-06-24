import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool isPasswordHidden = true;
  bool rememberMe = false;

  String selectedRole = "Farmer";

  // Password Visibility
  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    notifyListeners();
  }

  // Remember Me
  void toggleRememberMe(bool value) {
    rememberMe = value;
    notifyListeners();
  }

  // Role Selection
  void selectRole(String role) {
    selectedRole = role;
    notifyListeners();
  }

  // Login
  void login({
    required String email,
    required String password,
  }) {
    debugPrint("===== LOGIN =====");
    debugPrint("Email: $email");
    debugPrint("Password: $password");
    debugPrint("Role: $selectedRole");
  }

  // Signup
  void signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    debugPrint("===== SIGNUP =====");
    debugPrint("Name: $name");
    debugPrint("Email: $email");
    debugPrint("Phone: $phone");
    debugPrint("Password: $password");
    debugPrint("Role: $selectedRole");
  }

  // Forgot Password
  void forgotPassword(String email) {
    debugPrint("===== RESET PASSWORD =====");
    debugPrint("Email: $email");
  }

  // Logout
  void logout() {
    debugPrint("===== LOGOUT =====");
  }
}