import 'package:flutter/material.dart';
import '../models/price_prediction_model.dart';

class PricePredictionProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  PricePredictionModel? prediction;

  Future<void> predictPrice({
    required String cropType,
    required String quantity,
    required String marketLocation,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      prediction = null;
      notifyListeners();

      // Later yahan Django API / ML model API call hogi.
      await Future.delayed(const Duration(milliseconds: 800));

      prediction = PricePredictionModel(
        cropType: cropType,
        quantity: quantity,
        marketLocation: marketLocation,
        estimatedRange: "\$240 - \$265",
        unit: "per Ton",
        changePercent: "+5.2% vs last month",
        recommendation:
            "Demand for $cropType is rising in the $marketLocation due to recent weather patterns affecting competing regions. Holding inventory for another 2 weeks could yield a 3–5% price increase.",
        confidence: 87,
        thirtyDayHigh: "\$272",
        recordedDate: "Oct 12, 2023",
      );

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Failed to predict price";
      notifyListeners();
    }
  }

  void clearPrediction() {
    prediction = null;
    errorMessage = null;
    notifyListeners();
  }
}
