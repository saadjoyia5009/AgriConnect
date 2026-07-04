import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  WeatherModel? weather;
  String? lastCity;
  double? lastLatitude;
  double? lastLongitude;

  Future<void> fetchWeatherForecast({
    required double latitude,
    required double longitude,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      lastCity = null;
      lastLatitude = latitude;
      lastLongitude = longitude;

      weather = await WeatherService.getWeather(
        latitude: latitude,
        longitude: longitude,
      );

      isLoading = false;
      notifyListeners();
    } catch (e) {
      _setError(e, "WEATHER ERROR");
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

      lastCity = trimmedCity;
      lastLatitude = null;
      lastLongitude = null;

      weather = await WeatherService.getWeather(
        city: trimmedCity,
      );

      isLoading = false;
      notifyListeners();
    } catch (e) {
      _setError(e, "WEATHER CITY ERROR");
    }
  }

  Future<void> refreshWeather() async {
    if (lastCity != null && lastCity!.trim().isNotEmpty) {
      await fetchWeatherByCity(lastCity!);
    } else if (lastLatitude != null && lastLongitude != null) {
      await fetchWeatherForecast(
        latitude: lastLatitude!,
        longitude: lastLongitude!,
      );
    } else {
      errorMessage = "No weather location available";
      notifyListeners();
    }
  }

  void clearWeather() {
    weather = null;
    errorMessage = null;
    lastCity = null;
    lastLatitude = null;
    lastLongitude = null;
    notifyListeners();
  }

  void _setError(Object e, String logTitle) {
    debugPrint("$logTitle: $e");
    isLoading = false;
    errorMessage = e.toString().replaceAll("Exception: ", "");
    notifyListeners();
  }
}