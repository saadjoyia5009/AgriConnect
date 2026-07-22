import 'dart:io';

import 'package:flutter/material.dart';
import '../models/buyer_profile_model.dart';

class BuyerProfileProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isUpdating = false;
  String? errorMessage;

  File? selectedImage;
  BuyerProfileModel? profile;

  Future<void> fetchProfile() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      // Later:
      // final response = await BuyerProfileService.fetchProfile();
      // profile = BuyerProfileModel.fromJson(response);

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

  void setProfileImage(File image) {
    selectedImage = image;
    notifyListeners();
  }

  Future<bool> updateProfile(BuyerProfileModel updatedProfile) async {
    try {
      isUpdating = true;
      errorMessage = null;
      notifyListeners();

      // Later backend multipart:
      // await BuyerProfileService.updateProfile(
      //   data: updatedProfile.toJson(),
      //   imageFile: selectedImage,
      // );

      await Future.delayed(const Duration(milliseconds: 600));

      profile = updatedProfile;
      selectedImage = null;

      isUpdating = false;
      notifyListeners();

      return true;
    } catch (e) {
      isUpdating = false;
      errorMessage = "Failed to update profile";
      notifyListeners();

      return false;
    }
  }

  void clearSelectedImage() {
    selectedImage = null;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
