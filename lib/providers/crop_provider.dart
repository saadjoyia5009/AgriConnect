import 'package:flutter/material.dart';
import '../models/crop_model.dart';

class WeatherAlertModel {
  final String title;
  final String description;

  WeatherAlertModel({
    required this.title,
    required this.description,
  });

  factory WeatherAlertModel.fromJson(Map<String, dynamic> json) {
    return WeatherAlertModel(
      title: json["title"] ?? "",
      description: json["description"] ?? "",
    );
  }
}

class InquiryModel {
  final String buyerName;
  final String message;
  final String timeAgo;
  final String? buyerImage;
  final String avatarText;
  final bool isUnread;

  InquiryModel({
    required this.buyerName,
    required this.message,
    required this.timeAgo,
    this.buyerImage,
    required this.avatarText,
    required this.isUnread,
  });

  factory InquiryModel.fromJson(Map<String, dynamic> json) {
    return InquiryModel(
      buyerName: json["buyer_name"] ?? json["buyerName"] ?? "",
      message: json["message"] ?? "",
      timeAgo: json["time_ago"] ?? json["timeAgo"] ?? "",
      buyerImage: json["buyer_image"] ?? json["buyerImage"],
      avatarText: json["avatar_text"] ?? json["avatarText"] ?? "",
      isUnread: json["is_unread"] ?? json["isUnread"] ?? false,
    );
  }
}

class CropProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isSubmitting = false;
  String? errorMessage;

  int activeCrops = 12;
  int newInquiries = 5;

  WeatherAlertModel? weatherAlert;
  List<InquiryModel> recentInquiries = [];

  String _selectedFilter = "All";
  String get selectedFilter => _selectedFilter;

  final List<CropModel> _crops = [
    CropModel(
      id: "1",
      name: "Premium Winter Wheat",
      imageUrl:
      "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=800",
      quantity: "150 Tons left",
      price: "\$320",
      unit: "/t",
      category: "Organic",
      status: "Active",
      isOrganic: true,
      isReadyToShip: false,
      location: "Sahiwal, Punjab",
      description: "High quality premium winter wheat available.",
      harvestDate: "25/06/2026",
    ),
    CropModel(
      id: "2",
      name: "Heirloom Tomatoes",
      imageUrl:
      "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=800",
      quantity: "40 Boxes left",
      price: "\$45",
      unit: "/box",
      category: "Ready to ship",
      status: "Active",
      isOrganic: false,
      isReadyToShip: true,
      location: "Lahore, Punjab",
      description: "Fresh tomatoes ready for bulk order.",
      harvestDate: "20/06/2026",
    ),
    CropModel(
      id: "3",
      name: "Sunflower Seeds",
      imageUrl:
      "https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800",
      quantity: "0 Tons left",
      price: "\$180",
      unit: "/t",
      category: "",
      status: "Sold Out",
      isOrganic: false,
      isReadyToShip: false,
      location: "Multan, Punjab",
      description: "Sunflower seeds crop listing.",
      harvestDate: "10/06/2026",
    ),
  ];

  List<CropModel> get crops {
    if (_selectedFilter == "Active") {
      return _crops.where((crop) => crop.status == "Active").toList();
    } else if (_selectedFilter == "Sold Out") {
      return _crops.where((crop) => crop.status == "Sold Out").toList();
    }
    return _crops;
  }

  int get allCount => _crops.length;

  int get activeCount {
    return _crops.where((crop) => crop.status == "Active").length;
  }

  int get soldOutCount {
    return _crops.where((crop) => crop.status == "Sold Out").length;
  }

  Future<void> fetchFarmerDashboard() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      // Later:
      // final data = await CropService.fetchFarmerDashboard();

      await Future.delayed(const Duration(milliseconds: 500));

      activeCrops = activeCount;
      newInquiries = 2;

      weatherAlert = WeatherAlertModel(
        title: "Heavy Rain Expected",
        description: "Tomorrow, 2:00 PM - 6:00 PM",
      );

      recentInquiries = [
        InquiryModel(
          buyerName: "John Smith",
          message: "Inquiring about Organic Tomatoes",
          timeAgo: "2h ago",
          avatarText: "JS",
          isUnread: true,
        ),
        InquiryModel(
          buyerName: "Fresh Market Co.",
          message: "Bulk order negotiation",
          timeAgo: "Yesterday",
          buyerImage: "https://i.pravatar.cc/150?img=12",
          avatarText: "FM",
          isUnread: false,
        ),
      ];

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Failed to load dashboard data";
      notifyListeners();
    }
  }

  Future<bool> addCrop(CropModel crop) async {
    try {
      isSubmitting = true;
      errorMessage = null;
      notifyListeners();

      // Later:
      // final createdCrop = await CropService.addCrop(crop);
      // _crops.add(createdCrop);

      await Future.delayed(const Duration(milliseconds: 400));

      _crops.add(crop);
      activeCrops = activeCount;

      isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      isSubmitting = false;
      errorMessage = "Failed to add crop";
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCrop(String id) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      // Later:
      // await CropService.deleteCrop(id);

      await Future.delayed(const Duration(milliseconds: 300));

      _crops.removeWhere((crop) => crop.id == id);
      activeCrops = activeCount;

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = "Failed to delete crop";
      notifyListeners();
      return false;
    }
  }

  void changeFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
  Future<bool> updateCrop(
      CropModel crop, {
        dynamic imageFile,
      }) async {
    try {
      isSubmitting = true;
      errorMessage = null;
      notifyListeners();

      // Later:
      // final updatedCrop = await CropService.updateCrop(
      //   crop: crop,
      //   imageFile: imageFile,
      // );

      await Future.delayed(const Duration(milliseconds: 600));

      final index = _crops.indexWhere((item) => item.id == crop.id);

      if (index != -1) {
        _crops[index] = crop;
      }

      isSubmitting = false;
      notifyListeners();
      return true;
    } catch (e) {
      isSubmitting = false;
      errorMessage = "Failed to update crop";
      notifyListeners();
      return false;
    }
  }
}