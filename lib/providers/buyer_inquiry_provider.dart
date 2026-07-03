import 'package:flutter/material.dart';

import '../models/buyer_inquiry_model.dart';
import '../models/crop_model.dart';
import '../services/inquiry_service.dart';

class BuyerInquiryProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isSubmitting = false;
  String? errorMessage;

  String _selectedTab = "Active";
  String get selectedTab => _selectedTab;

  final List<BuyerInquiryModel> _inquiries = [];

  List<BuyerInquiryModel> get allInquiries => List.unmodifiable(_inquiries);

  List<BuyerInquiryModel> get filteredInquiries {
    if (_selectedTab == "Active") {
      return _inquiries.where((item) {
        final status = item.status.toLowerCase();

        return status == "requested" ||
            status == "accepted" ||
            status == "pending";
      }).toList();
    }

    if (_selectedTab == "Completed") {
      return _inquiries.where((item) {
        final status = item.status.toLowerCase();

        return status == "completed" ||
            status == "declined" ||
            status == "rejected";
      }).toList();
    }

    return _inquiries;
  }

  Future<void> fetchBuyerInquiries() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await InquiryService.fetchInquiries();
      _inquiries
        ..clear()
        ..addAll(response.map((item) => BuyerInquiryModel.fromJson(item)));

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Failed to load inquiries: $e";
      notifyListeners();
    }
  }

  Future<bool> sendInquiry({
    required CropModel crop,
    required String quantity,
    required String offerPrice,
    required String message,
  }) async {
    try {
      isSubmitting = true;
      errorMessage = null;
      notifyListeners();

      final data = {
        "crop": crop.id,
        "message": message,
        "offered_price": offerPrice,
        "quantity_requested": quantity,
      };

      final response = await InquiryService.sendInquiry(data);
      
      if (response != null && response["data"] != null) {
        _inquiries.insert(0, BuyerInquiryModel.fromJson(response["data"]));
      }

      isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      isSubmitting = false;
      errorMessage = "Failed to send inquiry: $e";
      notifyListeners();
      return false;
    }
  }

  void changeTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}