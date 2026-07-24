import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/user_profile_model.dart';
import '../services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isUpdating = false;

  String? _errorMessage;
  UserProfileModel? _profile;

  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  String? get errorMessage => _errorMessage;
  UserProfileModel? get profile => _profile;

  Future<void> fetchProfile() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final Map<String, dynamic> response =
      await ProfileService.fetchProfile();

      _profile = UserProfileModel.fromJson(response);
    } catch (error) {
      _errorMessage = _cleanError(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    required String fullName,
    required String phone,
    required String address,
    XFile? profileImage,
  }) async {
    if (_isUpdating) return false;

    final String cleanFullName = fullName.trim();
    final String cleanPhone = phone.trim();
    final String cleanAddress = address.trim();

    if (cleanFullName.isEmpty) {
      _errorMessage = "Please enter your full name.";
      notifyListeners();
      return false;
    }

    if (cleanPhone.isEmpty) {
      _errorMessage = "Please enter your phone number.";
      notifyListeners();
      return false;
    }

    if (cleanAddress.isEmpty) {
      _errorMessage = "Please enter your location.";
      notifyListeners();
      return false;
    }

    try {
      _isUpdating = true;
      _errorMessage = null;
      notifyListeners();

      final Map<String, dynamic> response =
      await ProfileService.updateProfile(
        fullName: cleanFullName,
        phone: cleanPhone,
        address: cleanAddress,
        profileImage: profileImage,
      );

      final dynamic rawData = response["data"];

      if (rawData is Map) {
        _profile = UserProfileModel.fromJson(
          Map<String, dynamic>.from(rawData),
        );
      } else {
        _profile = UserProfileModel.fromJson(response);
      }

      return true;
    } catch (error) {
      _errorMessage = _cleanError(error);
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  void setProfile(UserProfileModel profile) {
    _profile = profile;
    _errorMessage = null;
    notifyListeners();
  }

  void clearProfile() {
    _profile = null;
    _errorMessage = null;
    _isLoading = false;
    _isUpdating = false;
    notifyListeners();
  }

  void clearError() {
    if (_errorMessage == null) return;

    _errorMessage = null;
    notifyListeners();
  }

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst("Exception:", "")
        .trim();
  }
}