import '../models/weather_model.dart';
import 'api_service.dart';

class WeatherService {
  static Future<WeatherModel> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final endpoint = "/weather/?latitude=$latitude&longitude=$longitude";

    print("WEATHER ENDPOINT: $endpoint");

    final response = await ApiService.get(
      endpoint,
      auth: true,
    );

    if (response["success"] == true) {
      return WeatherModel.fromJson(response);
    }

    throw Exception(response["error"] ?? "Failed to fetch weather data");
  }
}