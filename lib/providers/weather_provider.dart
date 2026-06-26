import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  WeatherModel? weather;

  Future<void> fetchWeatherForecast({String city = "Sahiwal"}) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 600));

      weather = WeatherModel(
        location: "Midwest Region, Farm Sector 4",
        temperature: "68°F",
        condition: "Heavy Rain",
        humidity: "85%",
        wind: "12 mph",
        precipitation: "2.5 in",
        feelsLike: "65°F",
        uvIndex: "2 Low",
        visibility: "6.2 mi",
        farmingSuggestion:
        "High rainfall expected throughout the day. Avoid watering crops today. Ensure field drainage systems are clear to prevent waterlogging, especially in Sector 4 tomatoes.",
        forecast: [
          WeatherForecastModel(
            day: "Tomorrow",
            condition: "Rain",
            icon: "🌧️",
            highTemp: "72°",
            lowTemp: "58°",
          ),
          WeatherForecastModel(
            day: "Wed",
            condition: "Sunny",
            icon: "☀️",
            highTemp: "75°",
            lowTemp: "60°",
          ),
          WeatherForecastModel(
            day: "Thu",
            condition: "Sunny",
            icon: "☀️",
            highTemp: "78°",
            lowTemp: "62°",
          ),
          WeatherForecastModel(
            day: "Fri",
            condition: "Cloudy",
            icon: "☁️",
            highTemp: "74°",
            lowTemp: "61°",
          ),
          WeatherForecastModel(
            day: "Sat",
            condition: "Rain",
            icon: "🌧️",
            highTemp: "69°",
            lowTemp: "55°",
          ),
        ],
      );

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = "Failed to load weather forecast";
      notifyListeners();
    }
  }
}