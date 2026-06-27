import 'package:flutter/material.dart';
import '../models/crop_model.dart';

class BuyerFavoriteProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isSubmitting = false;
  String? errorMessage;

  String _selectedCategory = "All Favorites";
  String get selectedCategory => _selectedCategory;

  final List<CropModel> _favorites = [];

  List<CropModel> get favoriteCrops {
    if (_selectedCategory == "All Favorites") {
      return List.unmodifiable(_favorites);
    }

    return _favorites
        .where((crop) => crop.category == _selectedCategory)
        .toList();
  }

  bool isFavorite(String cropId) {
    return _favorites.any((crop) => crop.id == cropId);
  }

  Future<void> fetchFavorites() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 400));

      // Later backend:
      // final response = await BuyerFavoriteService.fetchFavorites();
      // _favorites
      //   ..clear()
      //   ..addAll(response.map((item) => CropModel.fromJson(item)));
    } catch (e) {
      errorMessage = "Failed to load favorites";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite(CropModel crop) async {
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      // Later backend:
      // if (isFavorite(crop.id)) {
      //   await BuyerFavoriteService.removeFavorite(crop.id);
      // } else {
      //   await BuyerFavoriteService.addFavorite(crop.id);
      // }

      if (isFavorite(crop.id)) {
        _favorites.removeWhere((item) => item.id == crop.id);
      } else {
        _favorites.add(crop);
      }
    } catch (e) {
      errorMessage = "Failed to update favorite";
    }

    isSubmitting = false;
    notifyListeners();
  }

  Future<void> removeFavorite(String id) async {
    isSubmitting = true;
    errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      // Later backend:
      // await BuyerFavoriteService.removeFavorite(id);

      _favorites.removeWhere((crop) => crop.id == id);
    } catch (e) {
      errorMessage = "Failed to remove favorite";
    }

    isSubmitting = false;
    notifyListeners();
  }

  void changeCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}