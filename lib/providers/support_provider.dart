import 'package:flutter/foundation.dart';

import '../models/support_request_model.dart';
import '../services/support_service.dart';

class SupportProvider extends ChangeNotifier {
  final SupportService _supportService = SupportService();

  List<SupportRequestModel> _requests = [];

  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  String? _successMessage;

  // Getters
  List<SupportRequestModel> get requests => _requests;

  bool get isLoading => _isLoading;

  bool get isSubmitting => _isSubmitting;

  String? get errorMessage => _errorMessage;

  String? get successMessage => _successMessage;

  /// Submit a new support request
  Future<bool> submitRequest({
    required String message,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    _successMessage = null;

    notifyListeners();

    try {
      final request = await _supportService.submitRequest(
        message: message,
      );

      _requests.insert(0, request);

      _successMessage = 'Your request has been submitted successfully.';

      return true;
    } catch (e) {
      _errorMessage = 'Failed to submit your request.';
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  /// Get current user's support requests
  Future<void> fetchMyRequests() async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _requests = await _supportService.getMyRequests();
    } catch (e) {
      _errorMessage = 'Failed to load support requests.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear success/error messages
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;

    notifyListeners();
  }
}