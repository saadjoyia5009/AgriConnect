import 'package:flutter/material.dart';
import '../models/inquiry_model.dart';

class InquiryProvider extends ChangeNotifier {
  String _selectedFilter = "Pending";

  String get selectedFilter => _selectedFilter;

  final List<InquiryModel> _inquiries = [
    InquiryModel(
      id: "1",
      cropName: "Organic Tomatoes",
      cropGrade: "Roma Variety",
      cropImage:
      "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=800",
      buyerName: "Sarah Miller",
      buyerInitials: "SM",
      requestedQuantity: "250 kg",
      proposedPrice: "\$1.20/kg",
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
      requestedQuantity: "1000 dz",
      proposedPrice: "\$4.50/dz",
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
      requestedQuantity: "50 kg",
      proposedPrice: "\$2.10/kg",
      status: "Pending",
    ),
  ];

  List<InquiryModel> get inquiries {
    if (_selectedFilter == "Active") {
      return _inquiries.where((item) => item.status == "Active").toList();
    } else if (_selectedFilter == "History") {
      return _inquiries.where((item) => item.status == "History").toList();
    }
    return _inquiries.where((item) => item.status == "Pending").toList();
  }

  void changeFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void acceptInquiry(String id) {
    final index = _inquiries.indexWhere((item) => item.id == id);
    if (index != -1) {
      _inquiries[index] = InquiryModel(
        id: _inquiries[index].id,
        cropName: _inquiries[index].cropName,
        cropGrade: _inquiries[index].cropGrade,
        cropImage: _inquiries[index].cropImage,
        buyerName: _inquiries[index].buyerName,
        buyerInitials: _inquiries[index].buyerInitials,
        requestedQuantity: _inquiries[index].requestedQuantity,
        proposedPrice: _inquiries[index].proposedPrice,
        status: "Active",
      );
      notifyListeners();
    }
  }

  void rejectInquiry(String id) {
    _inquiries.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}