import 'package:flutter/material.dart';
import '../models/crop_model.dart';

class CropProvider extends ChangeNotifier {
  int activeCrops = 12;
  int newInquiries = 5;

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

  void changeFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void addCrop(CropModel crop) {
    _crops.add(crop);
    activeCrops = activeCount;
    notifyListeners();
  }

  void deleteCrop(String id) {
    _crops.removeWhere((crop) => crop.id == id);
    activeCrops = activeCount;
    notifyListeners();
  }
}