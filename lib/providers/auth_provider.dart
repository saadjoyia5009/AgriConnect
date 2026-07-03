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
  String _location = "";
  String _resetEmail = "";
  String _resetOtp = "";
  String? _profileImagePath;

  String get userName => _userName;
  String get email => _email;
  String get phone => _phone;
  String get password => _password;
  String get role => _role;
  String get location => _location;
  String get resetEmail => _resetEmail;
  String get resetOtp => _resetOtp;
  String? get profileImagePath => _profileImagePath;

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

      if (_phone.trim().isEmpty) {
        _phone = "No phone added";
      }

      if (_location.trim().isEmpty) {
        _location = "Sahiwal, Punjab";
      }

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
      address: _location,
    );

    isLoading = false;

    if (response.success) {
      _userName = response.username ?? name;
      _email = response.email ?? email;
      _phone = phone;
      _password = password;
      _role = (response.role ?? _backendRole(selectedRole)).toLowerCase();

      if (_location.trim().isEmpty) {
        _location = "Sahiwal, Punjab";
      }

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
    if (email.trim().isEmpty) {
      errorMessage = "Please enter your email";
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final response = await _authService.forgotPassword(email: email.trim());

    isLoading = false;

    if (response.success) {
      _resetEmail = email.trim();
      _resetOtp = "";
      errorMessage = response.message;
      notifyListeners();
      return true;
    }

    errorMessage = response.message;
    notifyListeners();
    return false;
  }

  Future<bool> verifyOtp({
    required String otp,
  }) async {
    final cleanOtp = otp.trim();

    if (_resetEmail.trim().isEmpty) {
      errorMessage = "Email not found. Please request OTP again.";
      notifyListeners();
      return false;
    }

    if (cleanOtp.length != 6) {
      errorMessage = "Please enter valid 6 digit OTP";
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final response = await _authService.verifyResetOtp(
      email: _resetEmail,
      otp: cleanOtp,
    );

    isLoading = false;

    if (response.success) {
      _resetOtp = cleanOtp;
      notifyListeners();
      return true;
    }

    errorMessage = response.message;
    notifyListeners();
    return false;
  }

  Future<bool> resetPassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    final password = newPassword.trim();
    final confirm = confirmPassword.trim();

    if (_resetEmail.trim().isEmpty) {
      errorMessage = "Email not found. Please request OTP again.";
      notifyListeners();
      return false;
    }

    if (_resetOtp.trim().isEmpty) {
      errorMessage = "OTP not found. Please verify OTP first.";
      notifyListeners();
      return false;
    }

    if (password.isEmpty || confirm.isEmpty) {
      errorMessage = "Please fill all fields";
      notifyListeners();
      return false;
    }

    if (password.length < 8) {
      errorMessage = "Password must be at least 8 characters";
      notifyListeners();
      return false;
    }

    if (password != confirm) {
      errorMessage = "Passwords do not match";
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final response = await _authService.resetPassword(
      email: _resetEmail,
      otp: _resetOtp,
      newPassword: password,
      confirmPassword: confirm,
    );

    isLoading = false;

    if (response.success) {
      _password = password;
      _resetEmail = "";
      _resetOtp = "";
      notifyListeners();
      return true;
    }

    errorMessage = response.message;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    await _authService.logout();

    _userName = "Farmer User";
    _email = "";
    _phone = "";
    _password = "";
    _role = "";
    _location = "";
    _resetEmail = "";
    _resetOtp = "";
    _profileImagePath = null;
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

  void updateProfile({
    required String name,
    required String email,
    required String phone,
    required String location,
  }) {
    _userName = name;
    _email = email;
    _phone = phone;
    _location = location;

    notifyListeners();
  }

  void updateProfileImage(String imagePath) {
    _profileImagePath = imagePath;
    notifyListeners();
  }

  void setUserData({
    required String name,
    required String email,
    required String phone,
    required String location,
    String? profileImage,
  }) {
    _userName = name;
    _email = email;
    _phone = phone;
    _location = location;
    _profileImagePath = profileImage;

    notifyListeners();
  }
}