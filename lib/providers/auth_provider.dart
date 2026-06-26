import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isPasswordHidden = true;
  bool rememberMe = false;
  bool isLoading = false;
  String? errorMessage;

  String selectedRole = "Farmer";

  String _userName = "Farmer User";
  String _email = "";
  String _phone = "";
  String _password = "";
  String _role = "";

  String get userName => _userName;
  String get email => _email;
  String get phone => _phone;
  String get password => _password;
  String get role => _role;

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

  String _backendRole(String role) {
    return role.toLowerCase();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final response = await _authService.login(
      email: email,
      password: password,
    );

    isLoading = false;

    if (response.success) {
      _userName = response.username ?? "User";
      _email = response.email ?? email;
      _role = (response.role ?? selectedRole).toLowerCase();
      _password = password;

      notifyListeners();
      return true;
    }

    errorMessage = response.message;
    notifyListeners();
    return false;
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final response = await _authService.register(
      username: name,
      email: email,
      password: password,
      password2: password,
      role: _backendRole(selectedRole),
      phone: phone,
      address: "",
    );

    isLoading = false;

    if (response.success) {
      _userName = response.username ?? name;
      _email = response.email ?? email;
      _phone = phone;
      _password = password;
      _role = (response.role ?? _backendRole(selectedRole)).toLowerCase();

      notifyListeners();
      return true;
    }

    errorMessage = response.message;
    notifyListeners();
    return false;
  }

  Future<bool> forgotPassword({
    required String email,
  }) async {
    debugPrint("===== FORGOT PASSWORD API CALL =====");
    debugPrint("Email: $email");

    return true;
  }

  Future<void> logout() async {
    await _authService.logout();

    _userName = "Farmer User";
    _email = "";
    _phone = "";
    _password = "";
    _role = "";
    rememberMe = false;
    selectedRole = "Farmer";

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
    notifyListeners();
    return true;
  }
}