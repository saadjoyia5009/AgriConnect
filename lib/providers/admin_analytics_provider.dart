import 'package:flutter/material.dart';

class AdminAnalyticsProvider extends ChangeNotifier {
  bool isLoading = false;

  int totalUsers = 204;
  int totalCrops = 312;
  int totalInquiries = 154;
  int completedDeals = 87;

  final Map<String, double> userGrowth = {
    "Jan": 22,
    "Feb": 38,
    "Mar": 61,
    "Apr": 92,
    "May": 146,
    "Jun": 204,
  };

  final Map<String, double> cropCategories = {
    "Grains": 42,
    "Vegetables": 26,
    "Fruits": 18,
    "Fiber": 14,
  };

  final Map<String, double> inquiryStats = {
    "Pending": 42,
    "Accepted": 71,
    "Rejected": 24,
    "Completed": 17,
  };

  Future<void> fetchAnalytics() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    isLoading = false;
    notifyListeners();
  }
}
