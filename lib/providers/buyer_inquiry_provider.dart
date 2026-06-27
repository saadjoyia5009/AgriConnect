import 'package:flutter/material.dart';

import '../models/buyer_inquiry_model.dart';
import '../models/crop_model.dart';

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
        return status == "pending" ||
            status == "requested" ||
            status == "accepted";
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

      // Later Django API:
      // final response = await InquiryService.fetchBuyerInquiries();
      // _inquiries
      //   ..clear()
      //   ..addAll(response.map((item) => BuyerInquiryModel.fromJson(item)));

      await Future.delayed(const Duration(milliseconds: 500));

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Failed to load inquiries";
      notifyListeners();
    }
  }

  Future<bool> sendInquiry({
    required CropModel crop,
    required String buyerId,
    required String quantity,
    required String offerPrice,
    required String deliveryDate,
    required String message,
  }) async {
    try {
      isSubmitting = true;
      errorMessage = null;
      notifyListeners();

      final inquiry = BuyerInquiryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        cropId: crop.id,
        farmerId: crop.farmerId,
        buyerId: buyerId,
        cropName: crop.name,
        farmerName: crop.farmerName,
        imageUrl: crop.imageUrl,
        quantity: quantity,
        offerPrice: offerPrice,
        deliveryDate: deliveryDate,
        date: _todayDate(),
        status: "Pending",
        message: message,
      );

      // Later Django API:
      // final createdInquiry = await InquiryService.sendInquiry(inquiry.toJson());
      // _inquiries.insert(0, BuyerInquiryModel.fromJson(createdInquiry));

      await Future.delayed(const Duration(milliseconds: 700));

      _inquiries.insert(0, inquiry);

      isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      isSubmitting = false;
      errorMessage = "Failed to send inquiry";
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

  String _todayDate() {
    final now = DateTime.now();

    return "${now.day.toString().padLeft(2, '0')}/"
        "${now.month.toString().padLeft(2, '0')}/"
        "${now.year}";
  }
}