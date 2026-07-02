import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  WeatherModel? weather;

  Future<void> fetchWeatherForecast({
    double latitude = 30.67,
    double longitude = 73.10,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      weather = await WeatherService.getWeather(
        latitude: latitude,
        longitude: longitude,
      );

      isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("WEATHER ERROR: $e");

      isLoading = false;
      errorMessage = e.toString().replaceAll("Exception: ", "");
      notifyListeners();
    }
  }

  Future<void> refreshWeather({
    double latitude = 30.67,
    double longitude = 73.10,
  }) async {
    await fetchWeatherForecast(
      latitude: latitude,
      longitude: longitude,
    );
  }

  void clearWeather() {
    weather = null;
    errorMessage = null;
    notifyListeners();
  }
}