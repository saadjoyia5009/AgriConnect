import 'package:flutter/material.dart';

import '../models/admin_dashboard_stats_model.dart';
import '../services/admin_service.dart';

class AdminDashboardProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  AdminDashboardStatsModel? _stats;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AdminDashboardStatsModel? get stats => _stats;

  Future<void> fetchDashboardStats() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _stats = await AdminService.fetchDashboardStats();
    } catch (error) {
      _errorMessage = _cleanError(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshDashboardStats() async {
    try {
      _errorMessage = null;

      _stats = await AdminService.fetchDashboardStats();
    } catch (error) {
      _errorMessage = _cleanError(error);
    } finally {
      notifyListeners();
    }
  }

  void clearError() {
    if (_errorMessage == null) return;

    _errorMessage = null;
    notifyListeners();
  }

  void clearDashboard() {
    _stats = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst("Exception: ", "")
        .trim();
  }
}