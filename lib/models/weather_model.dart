class WeatherForecastModel {
  final String day;
  final String condition;
  final String icon;
  final String highTemp;
  final String lowTemp;
  final String rainChance;

  WeatherForecastModel({
    required this.day,
    required this.condition,
    required this.icon,
    required this.highTemp,
    required this.lowTemp,
    required this.rainChance,
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

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'] ?? {};
    final daily = json['daily'] ?? {};

    final weatherCode = current['weather_code'] ?? 0;
    final temp = (current['temperature_2m'] ?? 0).toDouble();
    final humidity = current['relative_humidity_2m'] ?? 0;
    final wind = (current['wind_speed_10m'] ?? 0).toDouble();
    final rain = (current['rain'] ?? 0).toDouble();

    final dates = List<String>.from(daily['time'] ?? []);
    final maxTemps = List.from(daily['temperature_2m_max'] ?? []);
    final minTemps = List.from(daily['temperature_2m_min'] ?? []);
    final rainChances =
    List.from(daily['precipitation_probability_max'] ?? []);

    return WeatherModel(
      location: 'Current Location',
      temperature: '${temp.toStringAsFixed(1)}°C',
      condition: _weatherCondition(weatherCode),
      humidity: '$humidity%',
      wind: '${wind.toStringAsFixed(1)} km/h',
      precipitation: '${rain.toStringAsFixed(1)} mm',
      feelsLike: '${temp.toStringAsFixed(1)}°C',
      uvIndex: 'N/A',
      visibility: 'N/A',
      farmingSuggestion: _farmingSuggestion(
        temp: temp,
        rain: rain,
        humidity: humidity,
        weatherCode: weatherCode,
      ),
      forecast: List.generate(dates.length, (index) {
        return WeatherForecastModel(
          day: _formatDay(dates[index]),
          condition: _weatherCondition(weatherCode),
          icon: _weatherIcon(weatherCode),
          highTemp: index < maxTemps.length
              ? '${(maxTemps[index] ?? 0).toDouble().toStringAsFixed(1)}°C'
              : 'N/A',
          lowTemp: index < minTemps.length
              ? '${(minTemps[index] ?? 0).toDouble().toStringAsFixed(1)}°C'
              : 'N/A',
          rainChance: index < rainChances.length ? '${rainChances[index]}%' : '0%',
        );
      }),
    );
  }

  static String _weatherCondition(int code) {
    switch (code) {
      case 0:
        return 'Clear Sky';
      case 1:
      case 2:
      case 3:
        return 'Partly Cloudy';
      case 45:
      case 48:
        return 'Foggy';
      case 51:
      case 53:
      case 55:
        return 'Drizzle';
      case 61:
      case 63:
      case 65:
        return 'Rainy';
      case 80:
      case 81:
      case 82:
        return 'Rain Showers';
      case 95:
        return 'Thunderstorm';
      default:
        return 'Normal Weather';
    }
  }

  static String _weatherIcon(int code) {
    if (code == 0) return '☀️';
    if ([1, 2, 3].contains(code)) return '⛅';
    if ([45, 48].contains(code)) return '🌫️';
    if ([51, 53, 55, 61, 63, 65, 80, 81, 82].contains(code)) return '🌧️';
    if (code == 95) return '⛈️';
    return '🌤️';
  }

  static String _farmingSuggestion({
    required double temp,
    required double rain,
    required int humidity,
    required int weatherCode,
  }) {
    if (rain > 0 || [61, 63, 65, 80, 81, 82, 95].contains(weatherCode)) {
      return 'Rain expected. Avoid pesticide spraying and delay irrigation.';
    }

    if (temp >= 38) {
      return 'High temperature. Check irrigation schedule and protect crops from heat stress.';
    }

    if (humidity >= 80) {
      return 'High humidity. Monitor crops for fungal disease risk.';
    }

    return 'Weather is suitable for normal farming activities.';
  }

  static String _formatDay(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      final now = DateTime.now();

      if (parsedDate.year == now.year &&
          parsedDate.month == now.month &&
          parsedDate.day == now.day) {
        return 'Today';
      }

      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[parsedDate.weekday - 1];
    } catch (_) {
      return date;
    }
  }
}