import 'dart:io';
import 'package:flutter/material.dart';
import '../models/disease_detection_model.dart';

class DiseaseDetectionProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  File? selectedImage;
  DiseaseDetectionModel? result;

  void setImage(File image) {
    selectedImage = image;
    result = null;
    errorMessage = null;
    notifyListeners();
  }

  Future<void> analyzeImage() async {
    if (selectedImage == null) {
      errorMessage = "Please select an image first";
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      // Later yahan Django API / AI model call hogi.
      await Future.delayed(const Duration(seconds: 2));

      result = DiseaseDetectionModel(
        diseaseName: "Early Blight",
        scientificName: "Alternaria solani",
        confidence: 92,
        status: "Detection Complete",
        treatmentPlan: [
          TreatmentStepModel(
            title: "Prune Affected Foliage",
            description:
                "Immediately remove and destroy spotted leaves. Do not compost them to prevent spore spread.",
          ),
          TreatmentStepModel(
            title: "Adjust Watering Practices",
            description:
                "Water at the base of the plant early in the day. Avoid overhead irrigation to keep leaves dry.",
          ),
          TreatmentStepModel(
            title: "Apply Fungicide",
            description:
                "Use a copper-based organic fungicide or chlorothalonil. Apply every 7–10 days per label instructions.",
          ),
        ],
      );

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Failed to analyze image";
      notifyListeners();
    }
  }

  void clearResult() {
    selectedImage = null;
    result = null;
    errorMessage = null;
    notifyListeners();
  }
}
