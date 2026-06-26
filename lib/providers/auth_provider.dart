import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool isPasswordHidden = true;
  bool rememberMe = false;
  String _location = "";
  String? _profileImagePath;


  String selectedRole = "Farmer";

  String _userName = "Farmer User";
  String _email = "";
  String _phone = "";
  String _password = "";

  String get userName => _userName;
  String get email => _email;
  String get phone => _phone;
  String get password => _password;
  String get location => _location;
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

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    debugPrint("===== LOGIN API CALL =====");
    debugPrint("Email: $email");
    debugPrint("Password: $password");
    debugPrint("Role: $selectedRole");

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

    // Temporary local data until Django JWT Register API integration
    _userName = name;
    _email = email;
    _phone = phone;
    _password = password;

    notifyListeners();

    return true;
  }

  Future<bool> forgotPassword({
    required String email,
  }) async {
    debugPrint("===== FORGOT PASSWORD API CALL =====");
    debugPrint("Email: $email");

    return true;
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

    notifyListeners();

    return true;
  }

  void logout() {
    _userName = "Farmer User";
    _email = "";
    _phone = "";
    _password = "";
    rememberMe = false;
    selectedRole = "Farmer";
    _profileImagePath = null;

    debugPrint("===== LOGOUT =====");

    notifyListeners();
  }
  void updateProfileImage(String imagePath) {
    _profileImagePath = imagePath;

    debugPrint("===== PROFILE IMAGE UPDATED =====");
    debugPrint("Image Path: $imagePath");

    notifyListeners();
  }
}