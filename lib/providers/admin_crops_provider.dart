import 'dart:async';

import 'package:flutter/material.dart';

import '../models/admin_crop_model.dart';
import '../services/admin_service.dart';

class AdminCropsProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  String _selectedFilter = "All";
  String _searchQuery = "";

  Timer? _searchDebounce;

  final List<AdminCropModel> _allCrops = [];
  final Set<String> _updatingCropIds = {};
  final Set<String> _deletingCropIds = {};

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;

  List<AdminCropModel> get crops {
    final normalizedFilter = _selectedFilter
        .trim()
        .toLowerCase()
        .replaceAll("_", " ");

    final normalizedSearch = _searchQuery.trim().toLowerCase();

    return List.unmodifiable(
      _allCrops.where((crop) {
        final cropStatus = crop.status
            .trim()
            .toLowerCase()
            .replaceAll("_", " ");

        final matchesFilter =
            normalizedFilter == "all" ||
                cropStatus == normalizedFilter;

        final matchesSearch =
            normalizedSearch.isEmpty ||
                crop.cropName.toLowerCase().contains(normalizedSearch) ||
                crop.farmerName.toLowerCase().contains(normalizedSearch) ||
                crop.category.toLowerCase().contains(normalizedSearch) ||
                crop.location.toLowerCase().contains(normalizedSearch);

        return matchesFilter && matchesSearch;
      }).toList(),
    );
  }

  int get allCount => _allCrops.length;

  int get activeCount {
    return _countByStatus("Active");
  }

  int get soldOutCount {
    return _countByStatus("Sold Out");
  }

  int get draftCount {
    return _countByStatus("Draft");
  }

  int _countByStatus(String status) {
    final normalizedStatus = status.trim().toLowerCase();

    return _allCrops.where((crop) {
      return crop.status.trim().toLowerCase() == normalizedStatus;
    }).length;
  }

  bool isUpdatingCrop(String cropId) {
    return _updatingCropIds.contains(cropId);
  }

  bool isDeletingCrop(String cropId) {
    return _deletingCropIds.contains(cropId);
  }

  bool isProcessingCrop(String cropId) {
    return isUpdatingCrop(cropId) || isDeletingCrop(cropId);
  }

  Future<void> fetchCrops({
    bool showLoading = true,
  }) async {
    if (_isLoading) return;

    try {
      if (showLoading) {
        _isLoading = true;
      }

      _errorMessage = null;
      notifyListeners();

      // Complete crop list fetch hoti hai.
      // Filtering frontend par reliably apply hoti hai.
      final loadedCrops = await AdminService.fetchCrops(
        search: "",
        status: "All",
      );

      _allCrops
        ..clear()
        ..addAll(loadedCrops);
    } catch (error) {
      _errorMessage = _cleanError(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshCrops() async {
    await fetchCrops(showLoading: false);
  }

  void changeFilter(String filter) {
    if (_selectedFilter == filter) return;

    _selectedFilter = filter;
    _errorMessage = null;
    notifyListeners();
  }

  void updateSearch(String value) {
    _searchQuery = value.trim();
    _searchDebounce?.cancel();

    // Local search foran UI par apply ho jayegi.
    notifyListeners();

    // Future mein backend search/pagination ke liye debounce ready hai.
    _searchDebounce = Timer(
      const Duration(milliseconds: 500),
          () {
        notifyListeners();
      },
    );
  }

  Future<bool> toggleCropStatus(String id) async {
    if (isProcessingCrop(id)) return false;

    final index = _allCrops.indexWhere(
          (crop) => crop.id == id,
    );

    if (index == -1) {
      _errorMessage = "Crop not found.";
      notifyListeners();
      return false;
    }

    final crop = _allCrops[index];

    final nextStatus = crop.backendStatus == "active"
        ? "draft"
        : "active";

    try {
      _updatingCropIds.add(id);
      _errorMessage = null;
      notifyListeners();

      final updatedCrop = await AdminService.updateCropStatus(
        cropId: id,
        status: nextStatus,
      );

      final updatedIndex = _allCrops.indexWhere(
            (item) => item.id == id,
      );

      if (updatedIndex != -1) {
        _allCrops[updatedIndex] = updatedCrop;
      }

      return true;
    } catch (error) {
      _errorMessage = _cleanError(error);
      return false;
    } finally {
      _updatingCropIds.remove(id);
      notifyListeners();
    }
  }

  Future<bool> deleteCrop(String id) async {
    if (isProcessingCrop(id)) return false;

    try {
      _deletingCropIds.add(id);
      _errorMessage = null;
      notifyListeners();

      await AdminService.deleteCrop(cropId: id);

      _allCrops.removeWhere(
            (crop) => crop.id == id,
      );

      return true;
    } catch (error) {
      _errorMessage = _cleanError(error);
      return false;
    } finally {
      _deletingCropIds.remove(id);
      notifyListeners();
    }
  }

  void clearError() {
    if (_errorMessage == null) return;

    _errorMessage = null;
    notifyListeners();
  }

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst("Exception: ", "")
        .trim();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}