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
    final forecastJson = List<Map<String, dynamic>>.from(
      (json['forecast'] ?? []).map((e) => Map<String, dynamic>.from(e)),
    );

    final temp = _toDouble(current['temperature']);
    final feelsLike = _toDouble(current['feels_like']);
    final humidity = _toInt(current['humidity']);
    final wind = _toDouble(current['wind_speed']);
    final condition =
        current['description']?.toString() ??
        current['weather_main']?.toString() ??
        'Normal Weather';
    final weatherMain = current['weather_main']?.toString() ?? '';
    final clouds = _toInt(current['clouds']);

    final rainChance = forecastJson.isNotEmpty
        ? _toInt(forecastJson.first['rain_chance'])
        : 0;

    final rainVolume = forecastJson.isNotEmpty
        ? _toDouble(forecastJson.first['rain_volume'])
        : 0.0;

    return WeatherModel(
      location: json['location']?.toString() ?? 'Current Location',
      temperature: '${temp.toStringAsFixed(1)}°C',
      condition: _capitalize(condition),
      humidity: '$humidity%',
      wind: '${wind.toStringAsFixed(1)} m/s',
      precipitation: '$rainChance%',
      feelsLike: '${feelsLike.toStringAsFixed(1)}°C',
      uvIndex: 'N/A',
      visibility: 'N/A',
      farmingSuggestion: _farmingSuggestion(
        temp: temp,
        rainChance: rainChance,
        rainVolume: rainVolume,
        humidity: humidity,
        weatherMain: weatherMain,
        clouds: clouds,
      ),
      forecast: forecastJson.map((item) {
        final itemTemp = _toDouble(item['temperature']);
        final itemCondition =
            item['description']?.toString() ??
            item['weather_main']?.toString() ??
            'Normal Weather';

        return WeatherForecastModel(
          day: _formatDay(item['time']?.toString() ?? ''),
          condition: _capitalize(itemCondition),
          icon: _weatherIcon(item['weather_main']?.toString() ?? ''),
          highTemp: '${itemTemp.toStringAsFixed(1)}°C',
          lowTemp: '${itemTemp.toStringAsFixed(1)}°C',
          rainChance: '${_toInt(item['rain_chance'])}%',
        );
      }).toList(),
    );
  }

  static String _weatherIcon(String main) {
    final value = main.toLowerCase();

    if (value.contains('clear')) return '☀️';
    if (value.contains('cloud')) return '☁️';
    if (value.contains('rain')) return '🌧️';
    if (value.contains('drizzle')) return '🌦️';
    if (value.contains('thunder')) return '⛈️';
    if (value.contains('mist') ||
        value.contains('fog') ||
        value.contains('haze')) {
      return '🌫️';
    }

    return '🌤️';
  }

  static String _farmingSuggestion({
    required double temp,
    required int rainChance,
    required double rainVolume,
    required int humidity,
    required String weatherMain,
    required int clouds,
  }) {
    final weather = weatherMain.toLowerCase();

    if (rainChance >= 50 || rainVolume > 0 || weather.contains('rain')) {
      return 'Rain expected. Avoid pesticide spraying and delay irrigation.';
    }

    if (temp >= 38) {
      return 'High temperature. Check irrigation schedule and protect crops from heat stress.';
    }

    if (humidity >= 80) {
      return 'High humidity. Monitor crops for fungal disease risk.';
    }

    if (clouds >= 70) {
      return 'Cloudy weather. Monitor soil moisture before irrigation.';
    }

    return 'Weather is suitable for normal farming activities.';
  }

  static String _formatDay(String dateTime) {
    try {
      final parsedDate = DateTime.parse(dateTime);
      final now = DateTime.now();

      if (parsedDate.year == now.year &&
          parsedDate.month == now.month &&
          parsedDate.day == now.day) {
        return 'Today';
      }

      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[parsedDate.weekday - 1];
    } catch (_) {
      return 'N/A';
    }
  }

  static String _capitalize(String value) {
    if (value.isEmpty) return 'Normal Weather';

    return value
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.round();
    return int.tryParse(value.toString()) ?? 0;
  }
}
