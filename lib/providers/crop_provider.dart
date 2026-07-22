import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/crop_model.dart';
import '../services/crop_service.dart';

class WeatherAlertModel {
  final String title;
  final String description;

  WeatherAlertModel({required this.title, required this.description});

  factory WeatherAlertModel.fromJson(Map<String, dynamic> json) {
    return WeatherAlertModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
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
      buyerName: json['buyer_name'] ?? json['buyerName'] ?? '',
      message: json['message'] ?? '',
      timeAgo: json['time_ago'] ?? json['timeAgo'] ?? '',
      buyerImage: json['buyer_image'] ?? json['buyerImage'],
      avatarText: json['avatar_text'] ?? json['avatarText'] ?? '',
      isUnread: json['is_unread'] ?? json['isUnread'] ?? false,
    );
  }
}

class CropProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isSubmitting = false;
  String? errorMessage;

  int activeCrops = 0;
  int newInquiries = 0;

  WeatherAlertModel? weatherAlert;
  List<InquiryModel> recentInquiries = [];

  String _selectedFilter = 'All';

  String get selectedFilter => _selectedFilter;

  String _buyerSearchQuery = '';
  String _buyerSelectedCategory = 'All';

  String get buyerSearchQuery => _buyerSearchQuery;

  String get buyerSelectedCategory => _buyerSelectedCategory;

  final List<CropModel> _crops = [
    CropModel(
      id: '1',
      farmerId: 'farmer_1',
      farmerName: 'Green Valley Farm',
      name: 'Premium Winter Wheat',
      imageUrl:
          'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=800',
      quantity: '150 Tons left',
      price: '\$320',
      unit: '/t',
      category: 'Grains',
      status: 'Active',
      isOrganic: true,
      isReadyToShip: false,
      location: 'Sahiwal, Punjab',
      description: 'High quality premium winter wheat available.',
      harvestDate: '25/06/2026',
    ),
    CropModel(
      id: '2',
      farmerId: 'farmer_2',
      farmerName: 'Ali Fresh Farm',
      name: 'Heirloom Tomatoes',
      imageUrl:
          'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=800',
      quantity: '40 Boxes left',
      price: '\$45',
      unit: '/box',
      category: 'Vegetables',
      status: 'Active',
      isOrganic: false,
      isReadyToShip: true,
      location: 'Lahore, Punjab',
      description: 'Fresh tomatoes ready for bulk order.',
      harvestDate: '20/06/2026',
    ),
    CropModel(
      id: '3',
      farmerId: 'farmer_3',
      farmerName: 'Multan Seed Farm',
      name: 'Sunflower Seeds',
      imageUrl:
          'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800',
      quantity: '0 Tons left',
      price: '\$180',
      unit: '/t',
      category: 'Grains',
      status: 'Sold Out',
      isOrganic: false,
      isReadyToShip: false,
      location: 'Multan, Punjab',
      description: 'Sunflower seeds crop listing.',
      harvestDate: '10/06/2026',
    ),
  ];

  List<CropModel> get allCrops => List.unmodifiable(_crops);

  List<CropModel> get crops {
    if (_selectedFilter == 'Active') {
      return _crops.where((crop) {
        return crop.status.toLowerCase() == 'active';
      }).toList();
    }

    if (_selectedFilter == 'Sold Out') {
      return _crops.where((crop) {
        final status = crop.status.toLowerCase();

        return status == 'sold out' || status == 'sold_out';
      }).toList();
    }

    return List.from(_crops);
  }

  List<CropModel> get buyerCrops {
    List<CropModel> result = _crops.where((crop) {
      return crop.status.toLowerCase() == 'active';
    }).toList();

    if (_buyerSelectedCategory != 'All') {
      result = result.where((crop) {
        return crop.category.toLowerCase() ==
            _buyerSelectedCategory.toLowerCase();
      }).toList();
    }

    if (_buyerSearchQuery.trim().isNotEmpty) {
      final query = _buyerSearchQuery.trim().toLowerCase();

      result = result.where((crop) {
        return crop.name.toLowerCase().contains(query) ||
            crop.location.toLowerCase().contains(query) ||
            crop.category.toLowerCase().contains(query) ||
            crop.farmerName.toLowerCase().contains(query);
      }).toList();
    }

    return result;
  }

  List<CropModel> get recommendedCrops => buyerCrops;

  int get allCount => _crops.length;

  int get activeCount {
    return _crops.where((crop) {
      return crop.status.toLowerCase() == 'active';
    }).length;
  }

  int get soldOutCount {
    return _crops.where((crop) {
      final status = crop.status.toLowerCase();

      return status == 'sold out' || status == 'sold_out';
    }).length;
  }

  Future<void> fetchFarmerDashboard() async {
    try {
      errorMessage = null;

      activeCrops = activeCount;
      newInquiries = 2;

      weatherAlert = WeatherAlertModel(
        title: 'Heavy Rain Expected',
        description: 'Tomorrow, 2:00 PM - 6:00 PM',
      );

      recentInquiries = [
        InquiryModel(
          buyerName: 'John Smith',
          message: 'Inquiring about Organic Tomatoes',
          timeAgo: '2h ago',
          avatarText: 'JS',
          isUnread: true,
        ),
        InquiryModel(
          buyerName: 'Fresh Market Co.',
          message: 'Bulk order negotiation',
          timeAgo: 'Yesterday',
          buyerImage: 'https://i.pravatar.cc/150?img=12',
          avatarText: 'FM',
          isUnread: false,
        ),
      ];

      notifyListeners();
    } catch (error) {
      errorMessage = 'Failed to load dashboard data';
      notifyListeners();
    }
  }

  Future<void> fetchCrops() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await CropService.fetchFarmerCrops();

      _crops
        ..clear()
        ..addAll(_extractCropList(response));

      activeCrops = activeCount;
    } catch (error) {
      errorMessage = 'Failed to load crops: $error';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMarketplaceCrops() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await CropService.fetchMarketplaceCrops();

      _crops
        ..clear()
        ..addAll(_extractCropList(response));
    } catch (error) {
      errorMessage = 'Failed to load marketplace crops: $error';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addCrop(
    CropModel crop, {
    XFile? imageFile,
    Uint8List? imageBytes,
  }) async {
    try {
      isSubmitting = true;
      errorMessage = null;
      notifyListeners();

      final response = await CropService.addCrop(
        crop,
        imageFile: imageFile,
        imageBytes: imageBytes,
      );

      final cropData = _extractCropData(response);
      final newCrop = CropModel.fromJson(cropData);

      _crops.insert(0, newCrop);
      activeCrops = activeCount;

      return true;
    } catch (error) {
      errorMessage = error.toString();
      debugPrint('Add crop error: $error');

      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> updateCrop(
    CropModel crop, {
    XFile? imageFile,
    Uint8List? imageBytes,
  }) async {
    try {
      isSubmitting = true;
      errorMessage = null;
      notifyListeners();

      final response = await CropService.updateCrop(
        crop,
        imageFile: imageFile,
        imageBytes: imageBytes,
      );

      final cropData = _extractCropData(response);
      final updatedCrop = CropModel.fromJson(cropData);

      final index = _crops.indexWhere((item) => item.id == crop.id);

      if (index != -1) {
        _crops[index] = updatedCrop;
      } else {
        _crops.insert(0, updatedCrop);
      }

      activeCrops = activeCount;

      return true;
    } catch (error) {
      errorMessage = error.toString();
      debugPrint('Update crop error: $error');

      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> deleteCrop(String id) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await CropService.deleteCrop(id);

      _crops.removeWhere((crop) => crop.id == id);
      activeCrops = activeCount;

      return true;
    } catch (error) {
      errorMessage = 'Failed to delete crop: $error';

      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Map<String, dynamic> _extractCropData(Map<String, dynamic> response) {
    final dynamic data = response['data'];

    if (data is Map<String, dynamic>) {
      return data;
    }

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    return response;
  }

  List<CropModel> _extractCropList(List<dynamic> response) {
    return response.map((item) {
      return CropModel.fromJson(Map<String, dynamic>.from(item as Map));
    }).toList();
  }

  void changeFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void searchCrops(String query) {
    _buyerSearchQuery = query;
    notifyListeners();
  }

  void filterByCategory(String category) {
    _buyerSelectedCategory = category;
    notifyListeners();
  }

  void clearFilters() {
    _buyerSearchQuery = '';
    _buyerSelectedCategory = 'All';
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
