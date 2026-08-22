import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isPasswordHidden = true;
  bool rememberMe = false;
  bool isLoading = false;
  String? errorMessage;

  String selectedRole = "Farmer";

  String _userName = "";
  String _email = "";
  String _phone = "";
  String _password = "";
  String _role = "";
  String _location = "";
  String _resetEmail = "";
  String _resetOtp = "";
  String? _profileImagePath;
  int? _userId;

  String get userName => _userName;
  String get email => _email;
  String get phone => _phone;
  String get password => _password;
  String get role => _role;
  String get location => _location;
  String get resetEmail => _resetEmail;
  String get resetOtp => _resetOtp;
  String? get profileImagePath => _profileImagePath;
  int? get userId => _userId;

  void togglePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    notifyListeners();
  }

  void toggleRememberMe(bool value) {
    rememberMe = value;
    notifyListeners();
  }

  void selectRole(String role) {
    final normalizedRole = role.trim().toLowerCase();

    if (normalizedRole == "farmer") {
      selectedRole = "Farmer";
    } else if (normalizedRole == "buyer") {
      selectedRole = "Buyer";
    } else {
      errorMessage = "Only Farmer or Buyer role can be selected.";
      notifyListeners();
      return;
    }

    errorMessage = null;
    notifyListeners();
  }

  String _backendRole(String role) {
    final normalizedRole = role.trim().toLowerCase();

    if (normalizedRole != "farmer" && normalizedRole != "buyer") {
      return "farmer";
    }

    return normalizedRole;
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.login(
        email: email.trim().toLowerCase(),
        password: password,
      );

      if (response.success) {
        _userName = (response.username ?? "").trim();
        _email = (response.email ?? email).trim();
        _role = (response.role ?? "").trim().toLowerCase();
        _password = password;
        _userId = response.userId;

        /*
         * Phone aur location login response mein available hon
         * to AuthService response model mein unhein map karke yahan set karein.
         *
         * Filhal fake/default values set nahi ki ja rahi hain.
         */
        _phone = "";
        _location = "";

        errorMessage = null;
        return true;
      }

      errorMessage = response.message;
      return false;
    } catch (error) {
      errorMessage = "Login failed. Please check your internet connection.";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
  }) async {
    final cleanName = name.trim();
    final cleanEmail = email.trim().toLowerCase();
    final cleanPhone = phone.trim();
    final cleanAddress = address.trim();

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.register(
        username: cleanName,
        email: cleanEmail,
        password: password,
        password2: password,
        role: _backendRole(selectedRole),
        phone: cleanPhone,
        address: cleanAddress,
      );

      if (response.success) {

        _clearAuthenticatedUserData();

        errorMessage = null;
        return true;
      }

      errorMessage = response.message;
      return false;
    } catch (error) {
      errorMessage =
      "Account creation failed. Please check your internet connection.";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyEmailOtp({
    required String email,
    required String otp,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanOtp = otp.trim();

    if (cleanEmail.isEmpty) {
      errorMessage = "Email not found. Please register again.";
      notifyListeners();
      return false;
    }

    if (cleanOtp.length != 6) {
      errorMessage = "Please enter a valid 6 digit OTP.";
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.verifyEmailOtp(
        email: cleanEmail,
        otp: cleanOtp,
      );

      if (response.success) {
        errorMessage = null;
        return true;
      }

      errorMessage = response.message;
      return false;
    } catch (error) {
      errorMessage =
      "OTP verification failed. Please check your internet connection.";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> forgotPassword({
    required String email,
  }) async {
    final cleanEmail = email.trim().toLowerCase();

    if (cleanEmail.isEmpty) {
      errorMessage = "Please enter your email.";
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.forgotPassword(
        email: cleanEmail,
      );

      if (response.success) {
        _resetEmail = cleanEmail;
        _resetOtp = "";
        errorMessage = null;
        return true;
      }

      errorMessage = response.message;
      return false;
    } catch (error) {
      errorMessage =
      "Unable to send OTP. Please check your internet connection.";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
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
      errorMessage = "Please enter a valid 6 digit OTP.";
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.verifyResetOtp(
        email: _resetEmail,
        otp: cleanOtp,
      );

      if (response.success) {
        _resetOtp = cleanOtp;
        errorMessage = null;
        return true;
      }

      errorMessage = response.message;
      return false;
    } catch (error) {
      errorMessage =
      "OTP verification failed. Please check your internet connection.";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resetPassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    final cleanPassword = newPassword.trim();
    final cleanConfirmPassword = confirmPassword.trim();

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

    if (cleanPassword.isEmpty || cleanConfirmPassword.isEmpty) {
      errorMessage = "Please fill all fields.";
      notifyListeners();
      return false;
    }

    if (cleanPassword.length < 8) {
      errorMessage = "Password must be at least 8 characters.";
      notifyListeners();
      return false;
    }

    if (cleanPassword != cleanConfirmPassword) {
      errorMessage = "Passwords do not match.";
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.resetPassword(
        email: _resetEmail,
        otp: _resetOtp,
        newPassword: cleanPassword,
        confirmPassword: cleanConfirmPassword,
      );

      if (response.success) {
        _password = cleanPassword;
        _resetEmail = "";
        _resetOtp = "";
        errorMessage = null;
        return true;
      }

      errorMessage = response.message;
      return false;
    } catch (error) {
      errorMessage =
      "Password reset failed. Please check your internet connection.";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
    } finally {
      _clearAuthenticatedUserData();

      _resetEmail = "";
      _resetOtp = "";
      rememberMe = false;
      selectedRole = "Farmer";
      errorMessage = null;
      isLoading = false;

      notifyListeners();
    }
  }

  void _clearAuthenticatedUserData() {
    _userName = "";
    _email = "";
    _phone = "";
    _password = "";
    _role = "";
    _location = "";
    _profileImagePath = null;
    _userId = null;
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
    _userName = name.trim();
    _email = email.trim();
    _phone = phone.trim();
    _location = location.trim();

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
    _userName = name.trim();
    _email = email.trim();
    _phone = phone.trim();
    _location = location.trim();
    _profileImagePath = profileImage;

    notifyListeners();
  }
}
