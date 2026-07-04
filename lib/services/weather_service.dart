import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import 'api_service.dart';

class WeatherService {
  static Future<WeatherModel> getWeather({
    double? latitude,
    double? longitude,
    String? city,
  }) async {
    String endpoint;

    if (city != null && city.trim().isNotEmpty) {
      endpoint = "/weather/?city=${Uri.encodeComponent(city.trim())}";
    } else {
      endpoint = "/weather/?latitude=$latitude&longitude=$longitude";
    }

    debugPrint("WEATHER ENDPOINT: $endpoint");

    final response = await ApiService.get(
      endpoint,
      auth: false,
    );

    if (response["success"] == true) {
      return WeatherModel.fromJson(response);
    }

    throw Exception(
      response["error"] ?? "Failed to fetch weather data",
    );
  }
}