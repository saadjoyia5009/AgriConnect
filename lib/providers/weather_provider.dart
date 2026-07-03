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

  Future<void> fetchWeatherByCity(String city) async {
    final trimmedCity = city.trim();

    if (trimmedCity.isEmpty) {
      errorMessage = "Please enter a city name";
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      weather = await WeatherService.getWeather(
        city: trimmedCity,
      );

      isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("WEATHER CITY ERROR: $e");

      isLoading = false;
      errorMessage = e.toString().replaceAll("Exception: ", "");
      notifyListeners();
    }
  }

  Future<void> refreshWeather({
    String? city,
    double latitude = 30.67,
    double longitude = 73.10,
  }) async {
    if (city != null && city.trim().isNotEmpty) {
      await fetchWeatherByCity(city);
    } else {
      await fetchWeatherForecast(
        latitude: latitude,
        longitude: longitude,
      );
    }
  }

  void clearWeather() {
    weather = null;
    errorMessage = null;
    notifyListeners();
  }
}