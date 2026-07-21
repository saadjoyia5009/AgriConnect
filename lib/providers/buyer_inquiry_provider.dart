import 'package:flutter/material.dart';

import '../models/buyer_inquiry_model.dart';
import '../models/crop_model.dart';
import '../services/inquiry_service.dart';

class BuyerInquiryProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  String _selectedTab = "Active";

  final List<BuyerInquiryModel> _inquiries = [];

  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  String get selectedTab => _selectedTab;

  List<BuyerInquiryModel> get allInquiries {
    return List.unmodifiable(_inquiries);
  }

  List<BuyerInquiryModel> get filteredInquiries {
    if (_selectedTab == "Active") {
      return _inquiries.where((item) {
        return item.isPending || item.isAccepted;
      }).toList();
    }

    if (_selectedTab == "Completed") {
      return _inquiries.where((item) {
        return item.isCompleted || item.isRejected;
      }).toList();
    }

    return List.unmodifiable(_inquiries);
  }

  BuyerInquiryModel? getInquiryById(String inquiryId) {
    try {
      return _inquiries.firstWhere(
            (item) => item.id == inquiryId,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> fetchBuyerInquiries() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await InquiryService.fetchInquiries();

      final loadedInquiries = response
          .whereType<Map>()
          .map(
            (item) => BuyerInquiryModel.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList();

      _inquiries
        ..clear()
        ..addAll(loadedInquiries);
    } catch (error) {
      _errorMessage = _cleanError(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendInquiry({
    required CropModel crop,
    required String quantity,
    required String offerPrice,
    required String deliveryDate,
    required String message,
  }) async {
    if (_isSubmitting) return false;

    try {
      _isSubmitting = true;
      _errorMessage = null;
      notifyListeners();

      final response = await InquiryService.sendInquiry(
        cropId: crop.id.toString(),
        quantity: quantity.trim(),
        offeredPrice: offerPrice.trim(),
        deliveryDate: deliveryDate.trim(),
        message: message.trim(),
      );

      final responseData = response["data"];

      if (responseData is! Map) {
        throw Exception("Inquiry data was not returned by server.");
      }

      final inquiry = BuyerInquiryModel.fromJson(
        Map<String, dynamic>.from(responseData),
      );

      _inquiries.removeWhere((item) => item.id == inquiry.id);
      _inquiries.insert(0, inquiry);

      return true;
    } catch (error) {
      _errorMessage = _cleanError(error);
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> refreshInquiry(String inquiryId) async {
    await fetchBuyerInquiries();
  }

  void changeTab(String tab) {
    if (_selectedTab == tab) return;

    _selectedTab = tab;
    notifyListeners();
  }

  void clearError() {
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