import 'package:flutter/material.dart';

import '../models/inquiry_model.dart';
import '../services/inquiry_service.dart';

class InquiryProvider extends ChangeNotifier {
  String _selectedFilter = "Pending";

  bool _isLoading = false;
  bool _isActionLoading = false;
  String? _errorMessage;

  final List<InquiryModel> _inquiries = [];

  String get selectedFilter => _selectedFilter;
  bool get isLoading => _isLoading;
  bool get isActionLoading => _isActionLoading;
  String? get errorMessage => _errorMessage;

  List<InquiryModel> get allInquiries {
    return List.unmodifiable(_inquiries);
  }

  List<InquiryModel> get filteredInquiries {
    if (_selectedFilter == "Active") {
      return _inquiries.where((item) {
        final status = item.status.trim().toLowerCase();

        return status == "active" || status == "accepted";
      }).toList();
    }

    if (_selectedFilter == "History") {
      return _inquiries.where((item) {
        final status = item.status.trim().toLowerCase();

        return status == "history" ||
            status == "rejected" ||
            status == "completed";
      }).toList();
    }

    return _inquiries.where((item) {
      return item.status.trim().toLowerCase() == "pending";
    }).toList();
  }

  InquiryModel? getInquiryById(String id) {
    try {
      return _inquiries.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  void changeFilter(String filter) {
    if (_selectedFilter == filter) return;

    _selectedFilter = filter;
    notifyListeners();
  }

  Future<void> fetchFarmerInquiries() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await InquiryService.fetchInquiries();

      final loadedInquiries = response
          .whereType<Map>()
          .map((item) => InquiryModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      _inquiries
        ..clear()
        ..addAll(loadedInquiries);
    } catch (error) {
      _errorMessage = "Unable to load inquiries: ${_cleanError(error)}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> acceptInquiry(String id) async {
    if (_isActionLoading) return;

    try {
      _isActionLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await InquiryService.acceptInquiry(id);
      final responseData = response["data"];

      final index = _inquiries.indexWhere((item) => item.id == id);

      if (index == -1) return;

      if (responseData is Map) {
        _inquiries[index] = InquiryModel.fromJson(
          Map<String, dynamic>.from(responseData),
        );
      } else {
        _inquiries[index] = _inquiries[index].copyWith(status: "Accepted");
      }
    } catch (error) {
      _errorMessage = "Unable to accept inquiry: ${_cleanError(error)}";
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  Future<void> rejectInquiry(String id) async {
    if (_isActionLoading) return;

    try {
      _isActionLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await InquiryService.rejectInquiry(id);
      final responseData = response["data"];

      final index = _inquiries.indexWhere((item) => item.id == id);

      if (index == -1) return;

      if (responseData is Map) {
        _inquiries[index] = InquiryModel.fromJson(
          Map<String, dynamic>.from(responseData),
        );
      } else {
        _inquiries[index] = _inquiries[index].copyWith(status: "Rejected");
      }
    } catch (error) {
      _errorMessage = "Unable to reject inquiry: ${_cleanError(error)}";
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    if (_errorMessage == null) return;

    _errorMessage = null;
    notifyListeners();
  }

  String _cleanError(Object error) {
    return error.toString().replaceFirst("Exception: ", "").trim();
  }
}
