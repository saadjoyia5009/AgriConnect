class WeatherForecastModel {
  final String day;
  final String condition;
  final String icon;
  final String highTemp;
  final String lowTemp;

  WeatherForecastModel({
    required this.day,
    required this.condition,
    required this.icon,
    required this.highTemp,
    required this.lowTemp,
  });
}

class WeatherModel {
  final String location;
  final String temperature;
  final String condition;
  final String humidity;
  final String wind;
  final String precipitation;
  final String feelsLike;
  final String uvIndex;
  final String visibility;
  final String farmingSuggestion;
  final List<WeatherForecastModel> forecast;

  WeatherModel({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.wind,
    required this.precipitation,
    required this.feelsLike,
    required this.uvIndex,
    required this.visibility,
    required this.farmingSuggestion,
    required this.forecast,
  });
}