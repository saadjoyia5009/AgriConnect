import 'package:flutter/material.dart';
import '../models/inquiry_model.dart';

class InquiryProvider extends ChangeNotifier {
  String _selectedFilter = "Pending";
  bool _isLoading = false;
  bool _isActionLoading = false;
  String? _errorMessage;

  String get selectedFilter => _selectedFilter;
  bool get isLoading => _isLoading;
  bool get isActionLoading => _isActionLoading;
  String? get errorMessage => _errorMessage;

  final List<InquiryModel> _inquiries = [];

  List<InquiryModel> get allInquiries => List.unmodifiable(_inquiries);

  List<InquiryModel> get filteredInquiries {
    if (_selectedFilter == "Active") {
      return _inquiries
          .where((item) => item.status.toLowerCase() == "active")
          .toList();
    }

    if (_selectedFilter == "History") {
      return _inquiries.where((item) {
        final status = item.status.toLowerCase();
        return status == "history" ||
            status == "rejected" ||
            status == "completed";
      }).toList();
    }

    return _inquiries
        .where((item) => item.status.toLowerCase() == "pending")
        .toList();
  }

  InquiryModel? getInquiryById(String id) {
    try {
      return _inquiries.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  void changeFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  Future<void> fetchFarmerInquiries() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Django REST API integration later
      // final response = await InquiryService.getFarmerInquiries();
      // _inquiries
      //   ..clear()
      //   ..addAll(response);

      await Future.delayed(const Duration(milliseconds: 600));

      _inquiries
        ..clear()
        ..addAll([
          InquiryModel(
            id: "1",
            cropName: "Organic Heirloom Tomatoes",
            cropGrade: "Roma Variety",
            cropImage:
            "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=800",
            buyerName: "John Doe",
            buyerInitials: "JD",
            buyerLocation: "Austin, TX",
            buyerImage: "https://i.pravatar.cc/150?img=12",
            requestedQuantity: "50 lbs",
            proposedPrice: "\$3.50 / lb",
            message:
            "Hello! I run a small farm-to-table restaurant downtown and I'm very interested in your upcoming harvest of heirloom tomatoes. Are they certified organic? I'd love to set up a regular weekly delivery if the quality matches the photos. Looking forward to hearing from you.",
            timeAgo: "2 hours ago",
            status: "Pending",
          ),
          InquiryModel(
            id: "2",
            cropName: "Sweet Corn",
            cropGrade: "Premium Grade",
            cropImage:
            "https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=800",
            buyerName: "Green Valley Grocers",
            buyerInitials: "GV",
            buyerLocation: "Lahore, PK",
            buyerImage: "",
            requestedQuantity: "1000 dz",
            proposedPrice: "Rs. 450 / dz",
            message:
            "We need fresh sweet corn for our grocery store. Please confirm availability, expected delivery time, and final wholesale price.",
            timeAgo: "5 hours ago",
            status: "Pending",
          ),
          InquiryModel(
            id: "3",
            cropName: "Bell Peppers",
            cropGrade: "Green & Red Mix",
            cropImage:
            "https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=800",
            buyerName: "Jack's Restaurant",
            buyerInitials: "JR",
            buyerLocation: "Karachi, PK",
            buyerImage: "https://i.pravatar.cc/150?img=32",
            requestedQuantity: "50 kg",
            proposedPrice: "Rs. 210 / kg",
            message:
            "I am looking for fresh bell peppers for my restaurant. Please confirm if you can supply mixed red and green peppers this week.",
            timeAgo: "1 day ago",
            status: "Pending",
          ),
        ]);
    } catch (_) {
      _errorMessage = "Unable to load inquiries. Please try again.";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> acceptInquiry(String id) async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Django REST API integration later
      // await InquiryService.updateInquiryStatus(
      //   inquiryId: id,
      //   status: "Active",
      // );

      await Future.delayed(const Duration(milliseconds: 300));

      final index = _inquiries.indexWhere((item) => item.id == id);

      if (index != -1) {
        _inquiries[index] = _inquiries[index].copyWith(status: "Active");
      }
    } catch (_) {
      _errorMessage = "Unable to accept inquiry.";
    }

    _isActionLoading = false;
    notifyListeners();
  }

  Future<void> rejectInquiry(String id) async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Django REST API integration later
      // await InquiryService.updateInquiryStatus(
      //   inquiryId: id,
      //   status: "Rejected",
      // );

      await Future.delayed(const Duration(milliseconds: 300));

      final index = _inquiries.indexWhere((item) => item.id == id);

      if (index != -1) {
        _inquiries[index] = _inquiries[index].copyWith(status: "Rejected");
      }
    } catch (_) {
      _errorMessage = "Unable to reject inquiry.";
    }

    _isActionLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}