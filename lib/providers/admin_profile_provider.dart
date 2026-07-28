import 'package:flutter/material.dart';

import '../models/admin_profile_model.dart';
import '../services/admin_service.dart';

class AdminProfileProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isUpdating = false;
  String? _errorMessage;
  AdminProfileModel? _profile;

  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  String? get errorMessage => _errorMessage;
  AdminProfileModel? get profile => _profile;

  Future<void> fetchProfile({
    bool showLoading = true,
  }) async {
    if (_isLoading) return;

    try {
      if (showLoading) {
        _isLoading = true;
      }

      _errorMessage = null;
      notifyListeners();

      _profile = await AdminService.fetchAdminProfile();
    } catch (error) {
      _errorMessage = _cleanError(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshProfile() async {
    await fetchProfile(showLoading: false);
  }

  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String address,
  }) async {
    if (_isUpdating) return false;

    if (firstName.trim().isEmpty) {
      _errorMessage = "First name is required.";
      notifyListeners();
      return false;
    }

    try {
      _isUpdating = true;
      _errorMessage = null;
      notifyListeners();

      _profile = await AdminService.updateAdminProfile(
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        phone: phone.trim(),
        address: address.trim(),
      );

      return true;
    } catch (error) {
      _errorMessage = _cleanError(error);
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  void clearError() {
    if (_errorMessage == null) return;

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

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst("Exception: ", "")
        .trim();
  }
}