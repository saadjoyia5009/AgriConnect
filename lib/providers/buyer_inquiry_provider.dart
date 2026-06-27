import 'package:flutter/material.dart';

import '../models/buyer_inquiry_model.dart';
import '../models/crop_model.dart';

class BuyerInquiryProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isSubmitting = false;
  String? errorMessage;

  String _selectedTab = "Active";
  String get selectedTab => _selectedTab;

  final List<BuyerInquiryModel> _inquiries = [
    BuyerInquiryModel(
      id: "1",
      cropId: "crop_1",
      farmerId: "farmer_1",
      buyerId: "buyer_1",
      cropName: "Premium Winter Wheat",
      farmerName: "Ahmad Farm",
      imageUrl:
      "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=800",
      quantity: "50 Tons",
      offerPrice: "\$310/t",
      deliveryDate: "30 June 2026",
      date: "25 June 2026",
      status: "Requested",
      message: "Need wheat for flour mill.",
    ),

    BuyerInquiryModel(
      id: "2",
      cropId: "crop_2",
      farmerId: "farmer_2",
      buyerId: "buyer_1",
      cropName: "Fresh Tomatoes",
      farmerName: "Ali Fresh Farm",
      imageUrl:
      "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=800",
      quantity: "25 Boxes",
      offerPrice: "\$42/box",
      deliveryDate: "28 June 2026",
      date: "24 June 2026",
      status: "Accepted",
      message: "Interested in bulk tomatoes.",
    ),

    BuyerInquiryModel(
      id: "3",
      cropId: "crop_3",
      farmerId: "farmer_3",
      buyerId: "buyer_1",
      cropName: "Organic Asparagus",
      farmerName: "Valley Farm",
      imageUrl:
      "https://images.unsplash.com/photo-1515471209610-dae1c92d8777?w=800",
      quantity: "100 Bundles",
      offerPrice: "\$4.20/lb",
      deliveryDate: "01 July 2026",
      date: "23 June 2026",
      status: "Completed",
      message: "Order delivered successfully.",
    ),

    BuyerInquiryModel(
      id: "4",
      cropId: "crop_4",
      farmerId: "farmer_4",
      buyerId: "buyer_1",
      cropName: "Premium Blueberries",
      farmerName: "North Ridge Farm",
      imageUrl:
      "https://images.unsplash.com/photo-1498557850523-fd3d118b962e?w=800",
      quantity: "40 Boxes",
      offerPrice: "\$11.50/box",
      deliveryDate: "29 June 2026",
      date: "22 June 2026",
      status: "Declined",
      message: "Price negotiation failed.",
    ),
  ];

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