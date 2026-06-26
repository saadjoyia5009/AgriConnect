import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isPasswordHidden = true;
  bool rememberMe = false;
<<<<<<< HEAD
  bool isLoading = false;
  String? errorMessage;
=======
  String _location = "";
  String? _profileImagePath;

>>>>>>> origin/main

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
<<<<<<< HEAD
  String get role => _role;
=======
  String get location => _location;
  String? get profileImagePath => _profileImagePath;
>>>>>>> origin/main

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

    debugPrint("===== PROFILE UPDATED =====");
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

<<<<<<< HEAD
    final response = await _authService.login(
      email: email,
      password: password,
    );
=======
    // Temporary local data until Django JWT API integration
    _email = email;
    _password = password;

    // Login screen mein name/phone nahi hota,
    // is liye temporary values set kar rahy hain.
    if (_userName.trim().isEmpty || _userName == "Farmer User") {
      _userName = selectedRole == "Farmer"
          ? "Farmer User"
          : selectedRole == "Buyer"
          ? "Buyer User"
          : "Admin User";
    }

    if (_phone.trim().isEmpty) {
      _phone = "No phone added";
    }

    notifyListeners();
>>>>>>> origin/main

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

<<<<<<< HEAD
    final response = await _authService.register(
      username: name,
      email: email,
      password: password,
      password2: password,
      role: _backendRole(selectedRole),
      phone: phone,
      address: "",
    );
=======
    // Temporary local data until Django JWT Register API integration
    _userName = name;
    _email = email;
    _phone = phone;
    _password = password;

    if (_location.isEmpty) {
      _location = "Sahiwal, Punjab";
    }

    notifyListeners();
>>>>>>> origin/main

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

<<<<<<< HEAD
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

=======
>>>>>>> origin/main
  bool changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    if (_password != currentPassword) {
      return false;
    }

    _password = newPassword;
<<<<<<< HEAD
    notifyListeners();
=======
    debugPrint("Password updated successfully");

    notifyListeners();

>>>>>>> origin/main
    return true;
  }

  void logout() {
    _userName = "Farmer User";
    _email = "";
    _phone = "";
    _password = "";
    _location = "";

    rememberMe = false;
    selectedRole = "Farmer";

    _profileImagePath = null;

    notifyListeners();
  }
  void updateProfileImage(String imagePath) {
    _profileImagePath = imagePath;

    debugPrint("===== PROFILE IMAGE UPDATED =====");
    debugPrint("Image Path: $imagePath");

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