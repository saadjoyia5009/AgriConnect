import 'package:flutter/material.dart';
import '../models/inquiry_model.dart';
import '../services/inquiry_service.dart';

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
      return _inquiries.where((item) {
        final status = item.status.toLowerCase();
        return status == "active" || status == "accepted";
      }).toList();
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
      final response = await InquiryService.fetchInquiries();
      _inquiries
        ..clear()
        ..addAll(response.map((item) => InquiryModel.fromJson(item)));
    } catch (e) {
      _errorMessage = "Unable to load inquiries: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> acceptInquiry(String id) async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await InquiryService.acceptInquiry(id);
      
      final index = _inquiries.indexWhere((item) => item.id == id);
      if (index != -1 && response != null && response["data"] != null) {
        _inquiries[index] = InquiryModel.fromJson(response["data"]);
      } else if (index != -1) {
        _inquiries[index] = _inquiries[index].copyWith(status: "Accepted");
      }
    } catch (e) {
      _errorMessage = "Unable to accept inquiry: $e";
    }

    _isActionLoading = false;
    notifyListeners();
  }

  Future<void> rejectInquiry(String id) async {
    _isActionLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await InquiryService.rejectInquiry(id);

      final index = _inquiries.indexWhere((item) => item.id == id);
      if (index != -1 && response != null && response["data"] != null) {
        _inquiries[index] = InquiryModel.fromJson(response["data"]);
      } else if (index != -1) {
        _inquiries[index] = _inquiries[index].copyWith(status: "Rejected");
      }
    } catch (e) {
      _errorMessage = "Unable to reject inquiry: $e";
    }

    _isActionLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}