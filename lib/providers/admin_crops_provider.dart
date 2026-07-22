import 'package:flutter/material.dart';
import '../models/admin_crop_model.dart';

class AdminCropsProvider extends ChangeNotifier {
  bool isLoading = false;
  String selectedFilter = "All";
  String searchQuery = "";

  final List<AdminCropModel> _crops = [];

  List<AdminCropModel> get crops {
    return _crops.where((crop) {
      final matchesFilter =
          selectedFilter == "All" || crop.status == selectedFilter;

      final query = searchQuery.toLowerCase();

      final matchesSearch =
          crop.cropName.toLowerCase().contains(query) ||
          crop.farmerName.toLowerCase().contains(query) ||
          crop.category.toLowerCase().contains(query) ||
          crop.location.toLowerCase().contains(query);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  Future<void> fetchCrops() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _crops.clear();
    _crops.addAll([
      AdminCropModel(
        id: "1",
        cropName: "Organic Wheat",
        farmerName: "Ahmed Khan",
        category: "Grains",
        location: "Sahiwal",
        price: "Rs. 5,500 / maund",
        quantity: "80 maund",
        status: "Active",
        listedDate: "20 Jun 2026",
      ),
      AdminCropModel(
        id: "2",
        cropName: "Premium Rice",
        farmerName: "Usman Malik",
        category: "Grains",
        location: "Okara",
        price: "Rs. 6,800 / maund",
        quantity: "60 maund",
        status: "Active",
        listedDate: "21 Jun 2026",
      ),
      AdminCropModel(
        id: "3",
        cropName: "Fresh Potatoes",
        farmerName: "Bilal Ahmed",
        category: "Vegetables",
        location: "Lahore",
        price: "Rs. 120 / kg",
        quantity: "500 kg",
        status: "Inactive",
        listedDate: "22 Jun 2026",
      ),
      AdminCropModel(
        id: "4",
        cropName: "Cotton Crop",
        farmerName: "Hassan Ali",
        category: "Fiber",
        location: "Multan",
        price: "Rs. 8,200 / maund",
        quantity: "40 maund",
        status: "Reported",
        listedDate: "23 Jun 2026",
      ),
    ]);

    isLoading = false;
    notifyListeners();
  }

  void changeFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }

  void updateSearch(String value) {
    searchQuery = value;
    notifyListeners();
  }

  void toggleCropStatus(String id) {
    final index = _crops.indexWhere((crop) => crop.id == id);
    if (index == -1) return;

    final old = _crops[index];

    _crops[index] = AdminCropModel(
      id: old.id,
      cropName: old.cropName,
      farmerName: old.farmerName,
      category: old.category,
      location: old.location,
      price: old.price,
      quantity: old.quantity,
      status: old.status == "Active" ? "Inactive" : "Active",
      listedDate: old.listedDate,
    );

    notifyListeners();
  }

  void deleteCrop(String id) {
    _crops.removeWhere((crop) => crop.id == id);
    notifyListeners();
  }
}
