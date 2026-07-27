import 'package:flutter/material.dart';

import '../models/admin_analytics_model.dart';
import '../services/admin_service.dart';

class AdminAnalyticsProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  AdminAnalyticsModel? _analytics;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AdminAnalyticsModel? get analytics => _analytics;

  int get totalUsers {
    return _analytics?.totalUsers ?? 0;
  }

  int get totalCrops {
    return _analytics?.totalCrops ?? 0;
  }

  int get totalInquiries {
    return _analytics?.totalInquiries ?? 0;
  }

  int get completedDeals {
    return _analytics?.completedDeals ?? 0;
  }

  Map<String, double> get userGrowth {
    return Map.unmodifiable(
      _analytics?.userGrowth ?? <String, double>{},
    );
  }

  Map<String, double> get cropCategories {
    return Map.unmodifiable(
      _analytics?.cropCategories ??
          <String, double>{},
    );
  }

  Map<String, double> get inquiryStats {
    return Map.unmodifiable(
      _analytics?.inquiryStats ??
          <String, double>{},
    );
  }

  Map<String, double> get userRoles {
    return Map.unmodifiable(
      _analytics?.userRoles ?? <String, double>{},
    );
  }

  Map<String, double> get cropStatuses {
    return Map.unmodifiable(
      _analytics?.cropStatuses ??
          <String, double>{},
    );
  }

  Map<String, double> get inquiryMonthlyTrend {
    return Map.unmodifiable(
      _analytics?.inquiryMonthlyTrend ??
          <String, double>{},
    );
  }

  Map<String, double> get topListedCrops {
    return Map.unmodifiable(
      _analytics?.topListedCrops ??
          <String, double>{},
    );
  }

  Future<void> fetchAnalytics({
    bool showLoading = true,
  }) async {
    if (_isLoading) return;

    try {
      if (showLoading) {
        _isLoading = true;
      }

      _errorMessage = null;
      notifyListeners();

      _analytics = await AdminService.fetchAnalytics();
    } catch (error) {
      _errorMessage = _cleanError(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshAnalytics() async {
    await fetchAnalytics(showLoading: false);
  }

  void clearError() {
    if (_errorMessage == null) return;

    _errorMessage = null;
    notifyListeners();
  }

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst("Exception: ", "")
        .trim();
  }
}