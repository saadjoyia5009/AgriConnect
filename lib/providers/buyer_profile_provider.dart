import 'package:flutter/material.dart';
import '../models/buyer_profile_model.dart';

class BuyerProfileProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isUpdating = false;
  String? errorMessage;

  BuyerProfileModel? profile;

  Future<void> fetchProfile() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 500));

      profile = BuyerProfileModel(
        id: "buyer_1",
        name: "Muhammad Saad",
        email: "saad@example.com",
        phone: "+92 300 1234567",
        location: "Sahiwal, Punjab",
        imageUrl: "https://i.pravatar.cc/150?img=12",
        totalInquiries: 8,
        acceptedDeals: 3,
        favoriteCrops: 5,
      );

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Failed to load buyer profile";
      notifyListeners();
    }
  }
}