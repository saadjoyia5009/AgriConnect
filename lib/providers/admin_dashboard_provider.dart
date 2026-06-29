import 'package:flutter/material.dart';
import '../models/admin_dashboard_stats_model.dart';

class AdminDashboardProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  AdminDashboardStatsModel? stats;

  Future<void> fetchDashboardStats() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      stats = AdminDashboardStatsModel(
        totalFarmers: 128,
        totalBuyers: 76,
        totalCrops: 312,
        totalInquiries: 154,
        activeListings: 248,
        pendingReports: 9,
      );
    } catch (e) {
      errorMessage = "Failed to load dashboard stats";
    }

    isLoading = false;
    notifyListeners();
  }
}